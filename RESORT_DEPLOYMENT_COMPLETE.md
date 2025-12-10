# Resort Deployment - Complete Reference

## Overview

This document contains the complete deployment details for the Resort Management System.

---

## Repository & Branch

- **Git Repository:** `https://github.com/teqmatessolutions-gif/Resort.git`
- **Branch:** `main` (or `master` - verify in repository)
- **Local Path:** `C:\releasing\Resort`
- **Server Deployment Path:** `/var/www/resort/resort_production`

---

## Frontend Builds

### User Site (Public Frontend)

- **Build Path:** `/var/www/resort/resort_production/userend/userend/build`
- **Public URL:** `https://teqmates.com/resort/`
- **Source Code:** `/var/www/resort/resort_production/userend/userend/`

### Admin Dashboard

- **Build Path:** `/var/www/resort/resort_production/dasboard/build`
- **Public URL:** `https://teqmates.com/resortadmin/`
- **Source Code:** `/var/www/resort/resort_production/dasboard/`

---

## Backend Configuration

### Code Location

- **Path:** `/var/www/resort/resort_production/ResortApp`
- **Framework:** FastAPI (Python)
- **Server:** Gunicorn + Uvicorn workers

### Systemd Service

- **Service Name:** `resort.service`
- **Status Check:** `systemctl status resort.service`
- **Start/Stop:** `systemctl start/stop/restart resort.service`
- **Logs:** `journalctl -u resort.service -f`

### Virtual Environment

- **Path:** `/var/www/resort/resort_production/ResortApp/venv`
- **Activate:** `source /var/www/resort/resort_production/ResortApp/venv/bin/activate`

### Gunicorn Configuration

- **Bind Address:** `127.0.0.1:8012`
- **Port:** `8012` (different from pomma: 8010, orchid: 8011)
- **Workers:** Configured in systemd service or gunicorn config

---

## API Endpoints

### Public API Path

- **Nginx Path:** `/resortapi/`
- **Public URL:** `https://teqmates.com/resortapi/api/*`
- **Backend:** Nginx rewrites `/resortapi/...` to backend on port 8012

### Example API Calls

```
GET  https://teqmates.com/resortapi/api/rooms
GET  https://teqmates.com/resortapi/api/bookings
POST https://teqmates.com/resortapi/api/auth/login
POST https://teqmates.com/resortapi/api/bookings/guest
```

---

## Database Configuration

### Database Details

- **Engine:** PostgreSQL
- **Database Name:** `resort`
- **Database User:** `resortuser`
- **Password:** `resort123` (change in production!)
- **Host:** `localhost`
- **Port:** `5432` (default PostgreSQL port)

### Connection String

```
postgresql+psycopg2://resortuser:resort123@localhost:5432/resort
```

### Environment File

- **Location:** `/var/www/resort/resort_production/ResortApp/.env`
- **Contains:** Database connection string and other environment variables
- **Also Used By:** Gunicorn service (loaded via systemd)

### Example .env File

```env
DATABASE_URL=postgresql+psycopg2://resortuser:resort123@localhost:5432/resort
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
HOST=0.0.0.0
PORT=8012
ROOT_PATH=/resortapi
```

---

## Media & Static Files

### API Uploads/Static

- **Server Path:** `/var/www/resort/resort_production/ResortApp/uploads`
- **Public URL:** `https://teqmates.com/resortfiles/`
- **Nginx Location:** `/resortfiles/` → serves uploads directory

### Admin Assets

- **Favicon/Logo:** `/var/www/resort/resort_production/dasboard/build/resortlogo.png`
- **Static Assets:** `/var/www/resort/resort_production/dasboard/build/static/`

---

## Nginx Configuration

### Expected Location Blocks

```nginx
# Resort User Frontend
location /resort {
    alias /var/www/resort/resort_production/userend/userend/build;
    try_files $uri $uri/ /resort/index.html;
}

location /resort/static/ {
    alias /var/www/resort/resort_production/userend/userend/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Resort Admin Dashboard
location /resortadmin {
    alias /var/www/resort/resort_production/dasboard/build;
    try_files $uri $uri/ /resortadmin/index.html;
}

location /resortadmin/static/ {
    alias /var/www/resort/resort_production/dasboard/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Resort API Backend
location /resortapi/ {
    rewrite ^/resortapi/(.*)$ /$1 break;
    proxy_pass http://127.0.0.1:8012;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_buffering off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}

# Resort File Uploads
location /resortfiles/ {
    alias /var/www/resort/resort_production/ResortApp/uploads/;
    expires 30d;
    add_header Cache-Control "public";
}
```

### Upstream (if used)

```nginx
upstream resort_backend {
    server 127.0.0.1:8012;
    keepalive 32;
}
```

---

## Verification Commands

### 1. Check Service Status

```bash
# Check resort service status
sudo systemctl status resort.service

# View recent logs
sudo journalctl -u resort.service -n 50

# Follow logs in real-time
sudo journalctl -u resort.service -f
```

### 2. Verify Database Connection

```bash
# Method 1: Via Python
cd /var/www/resort/resort_production/ResortApp
source venv/bin/activate
python3 -c "from app.database import engine; conn = engine.connect(); print('✅ Database connection successful'); conn.close()"

# Method 2: Direct PostgreSQL connection
sudo -u postgres psql resort -U resortuser
# Enter password: resort123
# Then run: \dt (to list tables)
# Exit: \q

# Method 3: Check connection string
cd /var/www/resort/resort_production/ResortApp
cat .env | grep DATABASE_URL
```

### 3. Check Backend Port

```bash
# Check if port 8012 is listening
sudo netstat -tlnp | grep 8012
# or
sudo ss -tlnp | grep 8012

# Test backend directly
curl http://127.0.0.1:8012/health
curl http://127.0.0.1:8012/api/rooms
```

### 4. Verify Frontend Builds

```bash
# Check user frontend build
ls -la /var/www/resort/resort_production/userend/userend/build/
ls -la /var/www/resort/resort_production/userend/userend/build/index.html

# Check admin dashboard build
ls -la /var/www/resort/resort_production/dasboard/build/
ls -la /var/www/resort/resort_production/dasboard/build/index.html
```

### 5. Check Nginx Configuration

```bash
# Test nginx configuration
sudo nginx -t

# Check for resort location blocks
sudo grep -r "resort" /etc/nginx/sites-enabled/
sudo grep -r "resort" /etc/nginx/conf.d/

# View nginx access logs
sudo tail -f /var/log/nginx/access.log | grep resort

# View nginx error logs
sudo tail -f /var/log/nginx/error.log | grep resort
```

### 6. Verify Public URLs

```bash
# Test user frontend
curl -I https://teqmates.com/resort/

# Test admin dashboard
curl -I https://teqmates.com/resortadmin/

# Test API endpoint
curl https://teqmates.com/resortapi/api/health
curl https://teqmates.com/resortapi/api/rooms

# Test file uploads
curl -I https://teqmates.com/resortfiles/
```

### 7. Check Database Tables

```bash
# Connect to database and list tables
sudo -u postgres psql resort -U resortuser -c "\dt"

# Count rooms
sudo -u postgres psql resort -U resortuser -c "SELECT COUNT(*) FROM rooms;"

# List all tables
sudo -u postgres psql resort -U resortuser -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
```

### 8. Verify Environment Variables

```bash
# Check .env file
cat /var/www/resort/resort_production/ResortApp/.env

# Check systemd service environment
sudo systemctl show resort.service | grep Environment
```

### 9. Check Git Repository

```bash
# Navigate to project
cd /var/www/resort/resort_production

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
ls -la /var/www/resort/resort_production/

# Check uploads directory permissions
ls -la /var/www/resort/resort_production/ResortApp/uploads/

# Check build directories
ls -la /var/www/resort/resort_production/userend/userend/build/
ls -la /var/www/resort/resort_production/dasboard/build/
```

---

## Summary

### Key Paths

| Component | Path |
|-----------|------|
| **Project Root** | `/var/www/resort/resort_production` |
| **Backend Code** | `/var/www/resort/resort_production/ResortApp` |
| **User Frontend Build** | `/var/www/resort/resort_production/userend/userend/build` |
| **Admin Build** | `/var/www/resort/resort_production/dasboard/build` |
| **Virtual Environment** | `/var/www/resort/resort_production/ResortApp/venv` |
| **Environment File** | `/var/www/resort/resort_production/ResortApp/.env` |
| **Uploads** | `/var/www/resort/resort_production/ResortApp/uploads` |

### URLs

| Service | URL |
|---------|-----|
| **User Frontend** | `https://teqmates.com/resort/` |
| **Admin Dashboard** | `https://teqmates.com/resortadmin/` |
| **API Base** | `https://teqmates.com/resortapi/api/` |
| **File Uploads** | `https://teqmates.com/resortfiles/` |

### Database

- **Name:** `resort`
- **User:** `resortuser`
- **Password:** `resort123` (change in production!)
- **Connection:** `postgresql+psycopg2://resortuser:resort123@localhost:5432/resort`

### Service

- **Name:** `resort.service`
- **Port:** `8012`
- **Backend:** FastAPI + Gunicorn

---

## References

- **Repository:** https://github.com/teqmatessolutions-gif/Resort.git
- **Server:** `root@139.84.211.200`
- **Main Domain:** https://teqmates.com
- **Local Path:** `C:\releasing\Resort`

