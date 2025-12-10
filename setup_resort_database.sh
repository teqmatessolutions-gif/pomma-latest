#!/bin/bash

# Database Setup Script for Resort Management System
# This script creates the resort database and user for both local and server environments

set -e  # Exit on error

echo "=========================================="
echo "Resort Database Setup Script"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Database configuration
DB_NAME="resort"
DB_USER="resortuser"
DB_PASSWORD="resort123"

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Note: This script requires sudo privileges for PostgreSQL operations${NC}"
    echo -e "${YELLOW}Some commands will be run with sudo${NC}"
    echo ""
fi

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    print_error "PostgreSQL is not installed!"
    print_status "Installing PostgreSQL..."
    
    if [ -f /etc/debian_version ]; then
        # Debian/Ubuntu
        sudo apt-get update
        sudo apt-get install -y postgresql postgresql-contrib
    elif [ -f /etc/redhat-release ]; then
        # RHEL/CentOS
        sudo yum install -y postgresql-server postgresql-contrib
        sudo postgresql-setup initdb
    else
        print_error "Unsupported Linux distribution. Please install PostgreSQL manually."
        exit 1
    fi
fi

# Start PostgreSQL service
print_status "Starting PostgreSQL service..."
if command -v systemctl &> /dev/null; then
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
else
    sudo service postgresql start
fi

# Wait for PostgreSQL to be ready
sleep 2

# Create database user
print_status "Creating database user: $DB_USER"
sudo -u postgres psql -c "DROP USER IF EXISTS $DB_USER;" || true
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" || {
    print_warning "User might already exist, continuing..."
}

# Grant privileges
print_status "Granting privileges to $DB_USER..."
sudo -u postgres psql -c "ALTER USER $DB_USER CREATEDB;" || true

# Create database
print_status "Creating database: $DB_NAME"
sudo -u postgres psql -c "DROP DATABASE IF EXISTS $DB_NAME;" || true
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" || {
    print_error "Failed to create database"
    exit 1
}

# Grant all privileges on database
print_status "Granting all privileges on database $DB_NAME to $DB_USER..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" || true

# Connect to database and grant schema privileges
print_status "Granting schema privileges..."
sudo -u postgres psql -d $DB_NAME -c "GRANT ALL ON SCHEMA public TO $DB_USER;" || true

# Test connection
print_status "Testing database connection..."
if sudo -u postgres psql -d $DB_NAME -U $DB_USER -c "SELECT version();" > /dev/null 2>&1; then
    print_status "✅ Database connection successful!"
else
    print_warning "Direct connection test failed, but database was created"
    print_warning "You may need to configure pg_hba.conf for password authentication"
fi

echo ""
echo "=========================================="
echo "Database Setup Complete!"
echo "=========================================="
echo ""
echo "Database Details:"
echo "  Name: $DB_NAME"
echo "  User: $DB_USER"
echo "  Password: $DB_PASSWORD"
echo "  Host: localhost"
echo "  Port: 5432"
echo ""
echo "Connection String:"
echo "  postgresql+psycopg2://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME"
echo ""
echo "Next Steps:"
echo "  1. Update your .env file with the database connection string"
echo "  2. Run database migrations: alembic upgrade head"
echo "  3. Or create tables: python -c 'from app.database import Base, engine; Base.metadata.create_all(bind=engine)'"
echo ""

