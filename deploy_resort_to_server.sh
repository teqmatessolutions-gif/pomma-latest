#!/bin/bash

# Deployment Script for Resort Management System
# This script sets up the Resort application on the server

set -e  # Exit on error

echo "=========================================="
echo "Resort Management System - Server Deployment"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_DIR="/var/www/resort/resort_production"
GIT_REPO="https://github.com/teqmatessolutions-gif/Resort.git"
GIT_BRANCH="main"
DB_NAME="resort"
DB_USER="resortuser"
DB_PASSWORD="resort123"
BACKEND_PORT="8012"
DOMAIN="teqmates.com"

# Functions
print_section() {
    echo ""
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo ""
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run this script as root or with sudo"
    exit 1
fi

print_section "PREREQUISITES CHECK"

# Check if required commands exist
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if ! command_exists git; then
    print_status "Installing git..."
    apt-get update
    apt-get install -y git
fi

if ! command_exists python3; then
    print_error "Python 3 is not installed. Please install it first."
    exit 1
fi

if ! command_exists psql; then
    print_error "PostgreSQL is not installed. Please install it first."
    exit 1
fi

if ! command_exists nginx; then
    print_error "Nginx is not installed. Please install it first."
    exit 1
fi

print_status "All prerequisites are installed"

print_section "DATABASE SETUP"

# Run database setup script if it exists
if [ -f "setup_resort_database.sh" ]; then
    print_status "Running database setup script..."
    bash setup_resort_database.sh
else
    print_status "Setting up database manually..."
    
    # Create database user
    sudo -u postgres psql -c "DROP USER IF EXISTS $DB_USER;" || true
    sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" || true
    sudo -u postgres psql -c "ALTER USER $DB_USER CREATEDB;"
    
    # Create database
    sudo -u postgres psql -c "DROP DATABASE IF EXISTS $DB_NAME;" || true
    sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT ALL ON SCHEMA public TO $DB_USER;"
    
    print_status "Database created: $DB_NAME"
fi

print_section "CLONING/UPDATE REPOSITORY"

# Create application directory
mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Clone or update repository
if [ -d ".git" ]; then
    print_status "Repository exists, pulling latest changes..."
    git pull origin "$GIT_BRANCH" || {
        print_warning "Failed to pull. Checking out branch..."
        git checkout "$GIT_BRANCH" || true
    }
else
    print_status "Cloning repository..."
    git clone -b "$GIT_BRANCH" "$GIT_REPO" .
fi

print_section "PYTHON ENVIRONMENT SETUP"

# Navigate to backend directory
cd "$APP_DIR/ResortApp"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    print_status "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install/update dependencies
print_status "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

print_section "ENVIRONMENT CONFIGURATION"

# Create .env file
print_status "Creating .env file..."
cat > .env << EOF
# Production Environment Configuration
ENVIRONMENT=production
DEBUG=False

# Database Configuration
DATABASE_URL=postgresql+psycopg2://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME
DB_HOST=localhost
DB_PORT=5432
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD

# Security Configuration
SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# Server Configuration
HOST=0.0.0.0
PORT=$BACKEND_PORT
WORKERS=4
ROOT_PATH=/resortapi

# Domain Configuration
DOMAIN=$DOMAIN
ALLOWED_HOSTS=$DOMAIN,www.$DOMAIN

# CORS Configuration
CORS_ORIGINS=https://www.$DOMAIN,https://$DOMAIN

# File Upload Configuration
MAX_FILE_SIZE=10485760
UPLOAD_FOLDER=uploads
STATIC_FOLDER=static

# Redis Configuration
REDIS_URL=redis://localhost:6379/0
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_DB=0

# Logging Configuration
LOG_LEVEL=INFO
LOG_FILE=/var/log/resort/app.log

# SSL Configuration
SSL_ENABLED=True
SSL_CERT_PATH=/etc/letsencrypt/live/$DOMAIN/fullchain.pem
SSL_KEY_PATH=/etc/letsencrypt/live/$DOMAIN/privkey.pem

# Frontend Paths
LANDING_PAGE_PATH=../landingpage
DASHBOARD_PATH=../dasboard/build
USEREND_PATH=../userend/userend/build

# SMTP Email Configuration (Update with your credentials)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password-here
SMTP_FROM_EMAIL=noreply@teqmates.com
SMTP_FROM_NAME=Resort Management
SMTP_USE_TLS=true
EOF

print_status ".env file created"

print_section "DATABASE INITIALIZATION"

# Create uploads and static directories
mkdir -p uploads static
chmod 777 uploads
chmod 755 static

# Initialize database tables
print_status "Creating database tables..."
python3 -c "
try:
    from app.database import Base, engine
    Base.metadata.create_all(bind=engine)
    print('✅ Database tables created successfully')
except Exception as e:
    print(f'❌ Database setup error: {e}')
    exit(1)
"

print_section "FRONTEND BUILD"

# Build user frontend
if [ -d "../userend/userend" ]; then
    print_status "Building user frontend..."
    cd ../userend/userend
    if [ -f "package.json" ]; then
        npm install --legacy-peer-deps
        npm run build
        print_status "User frontend built successfully"
    else
        print_warning "package.json not found in userend/userend"
    fi
    cd "$APP_DIR/ResortApp"
else
    print_warning "User frontend directory not found"
fi

# Build admin dashboard
if [ -d "../dasboard" ]; then
    print_status "Building admin dashboard..."
    cd ../dasboard
    if [ -f "package.json" ]; then
        npm install --legacy-peer-deps
        npm run build
        print_status "Admin dashboard built successfully"
    else
        print_warning "package.json not found in dasboard"
    fi
    cd "$APP_DIR/ResortApp"
else
    print_warning "Admin dashboard directory not found"
fi

print_section "SYSTEMD SERVICE SETUP"

# Create systemd service file
print_status "Creating systemd service file..."
cp "$APP_DIR/../resort.service" /etc/systemd/system/resort.service || {
    # If file doesn't exist in parent, create it
    cat > /etc/systemd/system/resort.service << EOF
[Unit]
Description=Resort Management System - TeqMates
After=network.target postgresql.service redis.service
Wants=postgresql.service redis.service

[Service]
Type=notify
User=www-data
Group=www-data
WorkingDirectory=$APP_DIR/ResortApp
Environment=PATH=$APP_DIR/ResortApp/venv/bin
Environment=PYTHONPATH=$APP_DIR/ResortApp
EnvironmentFile=$APP_DIR/ResortApp/.env
ExecStart=$APP_DIR/ResortApp/venv/bin/gunicorn main:app -c gunicorn.conf.py --bind 127.0.0.1:$BACKEND_PORT
ExecReload=/bin/kill -s HUP \$MAINPID
KillMode=mixed
TimeoutStopSec=5
PrivateTmp=true
Restart=always
RestartSec=10

# Security settings
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
ReadWritePaths=$APP_DIR/ResortApp/uploads
ReadWritePaths=$APP_DIR/ResortApp/static
ReadWritePaths=/var/log/resort
ReadWritePaths=/var/run/resort

# Resource limits
LimitNOFILE=65536
LimitNPROC=32768

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=resort-management

[Install]
WantedBy=multi-user.target
EOF
}

# Reload systemd and enable service
systemctl daemon-reload
systemctl enable resort.service

print_section "NGINX CONFIGURATION"

# Check if nginx config exists and add resort paths
NGINX_CONFIG="/etc/nginx/sites-available/teqmates"
if [ -f "$NGINX_CONFIG" ]; then
    print_status "Adding resort paths to existing nginx configuration..."
    
    # Check if resort paths already exist
    if ! grep -q "location /resort" "$NGINX_CONFIG"; then
        # Add resort upstream if not exists
        if ! grep -q "upstream resort_backend" "$NGINX_CONFIG"; then
            sed -i '/upstream.*backend/a upstream resort_backend {\n    server 127.0.0.1:8012;\n    keepalive 32;\n}' "$NGINX_CONFIG"
        fi
        
        # Add resort location blocks before the closing brace of the server block
        # This is a simplified approach - you may need to adjust based on your nginx config structure
        print_status "Please manually add the resort location blocks from nginx_resort_paths.conf to your nginx configuration"
        print_warning "See nginx_resort_paths.conf for the location blocks to add"
    else
        print_status "Resort paths already configured in nginx"
    fi
else
    print_warning "Main nginx configuration not found at $NGINX_CONFIG"
    print_status "Please manually add the configuration from nginx_resort_paths.conf to your nginx server block"
fi

# Test nginx configuration
print_status "Testing nginx configuration..."
nginx -t || {
    print_error "Nginx configuration test failed"
    print_warning "Please fix nginx configuration before proceeding"
}

print_section "FILE PERMISSIONS"

# Set proper permissions
print_status "Setting file permissions..."
chown -R www-data:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"
chmod -R 777 "$APP_DIR/ResortApp/uploads"
chmod -R 755 "$APP_DIR/ResortApp/static"

# Create log directory
mkdir -p /var/log/resort
chown -R www-data:www-data /var/log/resort

print_section "STARTING SERVICES"

# Start resort service
print_status "Starting resort service..."
systemctl restart resort.service
systemctl status resort.service --no-pager | head -10

# Reload nginx
print_status "Reloading nginx..."
systemctl reload nginx

print_section "DEPLOYMENT COMPLETE"

echo ""
print_status "✅ Resort Management System deployed successfully!"
echo ""
echo "Service URLs:"
echo "  User Frontend:  https://$DOMAIN/resort/"
echo "  Admin Dashboard: https://$DOMAIN/resortadmin/"
echo "  API Base:        https://$DOMAIN/resortapi/api/"
echo "  File Uploads:    https://$DOMAIN/resortfiles/"
echo ""
echo "Service Management:"
echo "  Status:  systemctl status resort.service"
echo "  Logs:    journalctl -u resort.service -f"
echo "  Restart: systemctl restart resort.service"
echo ""
echo "Database:"
echo "  Name: $DB_NAME"
echo "  User: $DB_USER"
echo "  Connection: postgresql+psycopg2://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME"
echo ""
print_warning "⚠️  Don't forget to:"
print_warning "  1. Update SMTP settings in .env file"
print_warning "  2. Add resort location blocks to nginx configuration if not done automatically"
print_warning "  3. Change database password in production!"
echo ""

