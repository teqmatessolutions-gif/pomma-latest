# Orchid Deployment - Complete Reference

## Overview

This document contains the complete deployment details for the Orchid Resort Management System.

---

## Repository & Branch

- **Git Repository:** `https://github.com/teqmatessolutions-gif/orchidresort.git`
- **Branch:** `master`
- **Deployment Path:** `/var/www/resort/orchid_production`

---

## Frontend Builds

### User Site (Public Frontend)

- **Build Path:** `/var/www/resort/orchid_production/userend/userend/build`
- **Public URL:** `https://teqmates.com/orchid/`
- **Source Code:** `/var/www/resort/orchid_production/userend/userend/`

### Admin Dashboard

- **Build Path:** `/var/www/resort/orchid_production/dasboard/build`
- **Public URL:** `https://teqmates.com/orchidadmin/`
- **Source Code:** `/var/www/resort/orchid_production/dasboard/`

---

## Backend Configuration

### Code Location

- **Path:** `/var/www/resort/orchid_production/ResortApp`
- **Framework:** FastAPI (Python)
- **Server:** Gunicorn + Uvicorn workers

### Systemd Service

- **Service Name:** `orchid.service`
- **Status Check:** `systemctl status orchid.service`
- **Start/Stop:** `systemctl start/stop/restart orchid.service`
- **Logs:** `journalctl -u orchid.service -f`

### Virtual Environment

- **Path:** `/var/www/resort/orchid_production/ResortApp/venv`
- **Activate:** `source /var/www/resort/orchid_production/ResortApp/venv/bin/activate`

### Gunicorn Configuration

- **Bind Address:** `127.0.0.1:8011`
- **Port:** `8011` (different from pomma which uses 8010)
- **Workers:** Configured in systemd service or gunicorn config

---

## API Endpoints

### Public API Path

- **Nginx Path:** `/orchidapi/`
- **Public URL:** `https://teqmates.com/orchidapi/api/*`
- **Backend:** Nginx rewrites `/orchidapi/...` to backend on port 8011

### Example API Calls

```
GET  https://teqmates.com/orchidapi/api/rooms
GET  https://teqmates.com/orchidapi/api/bookings
POST https://teqmates.com/orchidapi/api/auth/login
POST https://teqmates.com/orchidapi/api/bookings/guest
```

---

## Database Configuration

### Database Details

- **Engine:** PostgreSQL
- **Database Name:** `orchiddb`
- **Database User:** `orchiduser`
- **Password:** `orchid123`
- **Host:** `localhost`
- **Port:** `5432` (default PostgreSQL port)

### Connection String

```
postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb
```

### Environment File

- **Location:** `/var/www/resort/orchid_production/ResortApp/.env`
- **Contains:** Database connection string and other environment variables
- **Also Used By:** Gunicorn service (loaded via systemd)

### Example .env File

```env
DATABASE_URL=postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
HOST=0.0.0.0
PORT=8011
ROOT_PATH=/orchidapi
```

---

## Media & Static Files

### API Uploads/Static

- **Server Path:** `/var/www/resort/orchid_production/ResortApp/uploads`
- **Public URL:** `https://teqmates.com/orchidfiles/`
- **Nginx Location:** `/orchidfiles/` → serves uploads directory

### Admin Assets

- **Favicon/Logo:** `/var/www/resort/orchid_production/dasboard/build/pommalogo.png`
- **Static Assets:** `/var/www/resort/orchid_production/dasboard/build/static/`

---

## Nginx Configuration

### Expected Location Blocks

```nginx
# Orchid User Frontend
location /orchid {
    alias /var/www/resort/orchid_production/userend/userend/build;
    try_files $uri $uri/ /orchid/index.html;
}

location /orchid/static/ {
    alias /var/www/resort/orchid_production/userend/userend/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Orchid Admin Dashboard
location /orchidadmin {
    alias /var/www/resort/orchid_production/dasboard/build;
    try_files $uri $uri/ /orchidadmin/index.html;
}

location /orchidadmin/static/ {
    alias /var/www/resort/orchid_production/dasboard/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Orchid API Backend
location /orchidapi/ {
    rewrite ^/orchidapi/(.*)$ /$1 break;
    proxy_pass http://127.0.0.1:8011;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_buffering off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}

# Orchid File Uploads
location /orchidfiles/ {
    alias /var/www/resort/orchid_production/ResortApp/uploads/;
    expires 30d;
    add_header Cache-Control "public";
}
```

### Upstream (if used)

```nginx
upstream orchid_backend {
    server 127.0.0.1:8011;
    keepalive 32;
}
```

---

## Verification Commands

### 1. Check Service Status

```bash
# Check orchid service status
sudo systemctl status orchid.service

# View recent logs
sudo journalctl -u orchid.service -n 50

# Follow logs in real-time
sudo journalctl -u orchid.service -f
```

### 2. Verify Database Connection

```bash
# Method 1: Via Python
cd /var/www/resort/orchid_production/ResortApp
source venv/bin/activate
python3 -c "from app.database import engine; conn = engine.connect(); print('✅ Database connection successful'); conn.close()"

# Method 2: Direct PostgreSQL connection
sudo -u postgres psql orchiddb -U orchiduser
# Enter password: orchid123
# Then run: \dt (to list tables)
# Exit: \q

# Method 3: Check connection string
cd /var/www/resort/orchid_production/ResortApp
cat .env | grep DATABASE_URL
```

### 3. Check Backend Port

```bash
# Check if port 8011 is listening
sudo netstat -tlnp | grep 8011
# or
sudo ss -tlnp | grep 8011

# Test backend directly
curl http://127.0.0.1:8011/health
curl http://127.0.0.1:8011/api/rooms
```

### 4. Verify Frontend Builds

```bash
# Check user frontend build
ls -la /var/www/resort/orchid_production/userend/userend/build/
ls -la /var/www/resort/orchid_production/userend/userend/build/index.html

# Check admin dashboard build
ls -la /var/www/resort/orchid_production/dasboard/build/
ls -la /var/www/resort/orchid_production/dasboard/build/index.html

# Check admin logo
ls -la /var/www/resort/orchid_production/dasboard/build/pommalogo.png
```

### 5. Check Nginx Configuration

```bash
# Test nginx configuration
sudo nginx -t

# Check for orchid location blocks
sudo grep -r "orchid" /etc/nginx/sites-enabled/
sudo grep -r "orchid" /etc/nginx/conf.d/

# View nginx access logs
sudo tail -f /var/log/nginx/access.log | grep orchid

# View nginx error logs
sudo tail -f /var/log/nginx/error.log | grep orchid
```

### 6. Verify Public URLs

```bash
# Test user frontend
curl -I https://teqmates.com/orchid/

# Test admin dashboard
curl -I https://teqmates.com/orchidadmin/

# Test API endpoint
curl https://teqmates.com/orchidapi/api/health
curl https://teqmates.com/orchidapi/api/rooms

# Test file uploads
curl -I https://teqmates.com/orchidfiles/
```

### 7. Check Database Tables

```bash
# Connect to database and list tables
sudo -u postgres psql orchiddb -U orchiduser -c "\dt"

# Count rooms
sudo -u postgres psql orchiddb -U orchiduser -c "SELECT COUNT(*) FROM rooms;"

# Check for orchid rooms
sudo -u postgres psql orchiddb -U orchiduser -c "SELECT COUNT(*) FROM rooms WHERE LOWER(type) LIKE '%orchid%';"

# List all tables
sudo -u postgres psql orchiddb -U orchiduser -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
```

### 8. Verify Environment Variables

```bash
# Check .env file
cat /var/www/resort/orchid_production/ResortApp/.env

# Check systemd service environment
sudo systemctl show orchid.service | grep Environment
```

### 9. Check Git Repository

```bash
# Navigate to project
cd /var/www/resort/orchid_production

# Check git remote
git remote -v

# Check current branch
git branch

# Check latest commit
git log -1 --oneline

# Check if there are uncommitted changes
git status
```

### 10. Verify File Permissions

```bash
# Check ownership
ls -la /var/www/resort/orchid_production/

# Check uploads directory permissions
ls -la /var/www/resort/orchid_production/ResortApp/uploads/

# Check build directories
ls -la /var/www/resort/orchid_production/userend/userend/build/
ls -la /var/www/resort/orchid_production/dasboard/build/
```

---

## Complete Verification Script

```bash
#!/bin/bash
# Complete Orchid Deployment Verification Script

echo "=========================================="
echo "Orchid Deployment Verification"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Service Status
echo -e "${YELLOW}1. Checking orchid.service status...${NC}"
if systemctl is-active --quiet orchid.service; then
    echo -e "${GREEN}✅ orchid.service is running${NC}"
    systemctl status orchid.service --no-pager | head -5
else
    echo -e "${RED}❌ orchid.service is not running${NC}"
fi
echo ""

# 2. Port Check
echo -e "${YELLOW}2. Checking port 8011...${NC}"
if netstat -tlnp 2>/dev/null | grep -q ":8011"; then
    echo -e "${GREEN}✅ Port 8011 is listening${NC}"
    netstat -tlnp | grep 8011
else
    echo -e "${RED}❌ Port 8011 is not listening${NC}"
fi
echo ""

# 3. Database Connection
echo -e "${YELLOW}3. Testing database connection...${NC}"
cd /var/www/resort/orchid_production/ResortApp
if [ -f venv/bin/activate ]; then
    source venv/bin/activate
    if python3 -c "from app.database import engine; conn = engine.connect(); conn.close()" 2>/dev/null; then
        echo -e "${GREEN}✅ Database connection successful${NC}"
    else
        echo -e "${RED}❌ Database connection failed${NC}"
    fi
    deactivate
else
    echo -e "${RED}❌ Virtual environment not found${NC}"
fi
echo ""

# 4. Frontend Builds
echo -e "${YELLOW}4. Checking frontend builds...${NC}"
if [ -f /var/www/resort/orchid_production/userend/userend/build/index.html ]; then
    echo -e "${GREEN}✅ User frontend build exists${NC}"
else
    echo -e "${RED}❌ User frontend build missing${NC}"
fi

if [ -f /var/www/resort/orchid_production/dasboard/build/index.html ]; then
    echo -e "${GREEN}✅ Admin dashboard build exists${NC}"
else
    echo -e "${RED}❌ Admin dashboard build missing${NC}"
fi
echo ""

# 5. Nginx Configuration
echo -e "${YELLOW}5. Checking Nginx configuration...${NC}"
if sudo nginx -t 2>&1 | grep -q "successful"; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
else
    echo -e "${RED}❌ Nginx configuration has errors${NC}"
    sudo nginx -t
fi
echo ""

# 6. Public URLs
echo -e "${YELLOW}6. Testing public URLs...${NC}"
if curl -s -o /dev/null -w "%{http_code}" https://teqmates.com/orchid/ | grep -q "200\|301\|302"; then
    echo -e "${GREEN}✅ /orchid/ is accessible${NC}"
else
    echo -e "${RED}❌ /orchid/ is not accessible${NC}"
fi

if curl -s -o /dev/null -w "%{http_code}" https://teqmates.com/orchidadmin/ | grep -q "200\|301\|302"; then
    echo -e "${GREEN}✅ /orchidadmin/ is accessible${NC}"
else
    echo -e "${RED}❌ /orchidadmin/ is not accessible${NC}"
fi

if curl -s -o /dev/null -w "%{http_code}" https://teqmates.com/orchidapi/api/health | grep -q "200"; then
    echo -e "${GREEN}✅ /orchidapi/api/health is accessible${NC}"
else
    echo -e "${RED}❌ /orchidapi/api/health is not accessible${NC}"
fi
echo ""

# 7. Database Tables
echo -e "${YELLOW}7. Checking database tables...${NC}"
TABLE_COUNT=$(sudo -u postgres psql orchiddb -U orchiduser -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')
if [ ! -z "$TABLE_COUNT" ] && [ "$TABLE_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✅ Database has $TABLE_COUNT tables${NC}"
else
    echo -e "${RED}❌ Could not access database tables${NC}"
fi
echo ""

# 8. Environment File
echo -e "${YELLOW}8. Checking .env file...${NC}"
if [ -f /var/www/resort/orchid_production/ResortApp/.env ]; then
    echo -e "${GREEN}✅ .env file exists${NC}"
    if grep -q "orchiddb" /var/www/resort/orchid_production/ResortApp/.env; then
        echo -e "${GREEN}✅ Database name configured correctly${NC}"
    else
        echo -e "${RED}❌ Database name not found in .env${NC}"
    fi
else
    echo -e "${RED}❌ .env file not found${NC}"
fi
echo ""

echo "=========================================="
echo "Verification Complete"
echo "=========================================="
```

---

## Quick Access Commands

### Service Management

```bash
# Start service
sudo systemctl start orchid.service

# Stop service
sudo systemctl stop orchid.service

# Restart service
sudo systemctl restart orchid.service

# Reload service (after config changes)
sudo systemctl reload orchid.service

# View logs
sudo journalctl -u orchid.service -f
```

### Database Access

```bash
# Connect to database
sudo -u postgres psql orchiddb -U orchiduser

# Run SQL query
sudo -u postgres psql orchiddb -U orchiduser -c "SELECT COUNT(*) FROM rooms;"
```

### Frontend Rebuild

```bash
# Rebuild user frontend
cd /var/www/resort/orchid_production/userend/userend
npm install --legacy-peer-deps
npm run build

# Rebuild admin dashboard
cd /var/www/resort/orchid_production/dasboard
npm install --legacy-peer-deps
npm run build
```

### Backend Update

```bash
# Pull latest code
cd /var/www/resort/orchid_production
git pull origin master

# Activate virtual environment
cd ResortApp
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt --upgrade

# Restart service
sudo systemctl restart orchid.service
```

---

## Summary

### Key Paths

| Component | Path |
|-----------|------|
| **Project Root** | `/var/www/resort/orchid_production` |
| **Backend Code** | `/var/www/resort/orchid_production/ResortApp` |
| **User Frontend Build** | `/var/www/resort/orchid_production/userend/userend/build` |
| **Admin Build** | `/var/www/resort/orchid_production/dasboard/build` |
| **Virtual Environment** | `/var/www/resort/orchid_production/ResortApp/venv` |
| **Environment File** | `/var/www/resort/orchid_production/ResortApp/.env` |
| **Uploads** | `/var/www/resort/orchid_production/ResortApp/uploads` |

### URLs

| Service | URL |
|---------|-----|
| **User Frontend** | `https://teqmates.com/orchid/` |
| **Admin Dashboard** | `https://teqmates.com/orchidadmin/` |
| **API Base** | `https://teqmates.com/orchidapi/api/` |
| **File Uploads** | `https://teqmates.com/orchidfiles/` |

### Database

- **Name:** `orchiddb`
- **User:** `orchiduser`
- **Password:** `orchid123`
- **Connection:** `postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb`

### Service

- **Name:** `orchid.service`
- **Port:** `8011`
- **Backend:** FastAPI + Gunicorn

---

## References

- **Repository:** https://github.com/teqmatessolutions-gif/orchidresort.git
- **Server:** `root@139.84.211.200`
- **Main Domain:** https://teqmates.com

