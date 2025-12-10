# Run Orchid Locally - Complete Guide

## Prerequisites

- Python 3.11+
- Node.js 16+ and npm
- PostgreSQL (or SQLite for quick testing)
- Git

---

## Step 1: Clone Orchid Repository

```powershell
cd C:\releasing
git clone https://github.com/teqmatessolutions-gif/orchidresort.git orchid
cd orchid
```

---

## Step 2: Setup Database

### Option A: PostgreSQL (Production-like)

```powershell
# Create database
# Connect to PostgreSQL and run:
# CREATE DATABASE orchiddb;
# CREATE USER orchiduser WITH PASSWORD 'orchid123';
# GRANT ALL PRIVILEGES ON DATABASE orchiddb TO orchiduser;
```

### Option B: SQLite (Quick Testing)

No setup needed - will create `orchid.db` automatically.

---

## Step 3: Configure Backend

```powershell
cd C:\releasing\orchid\ResortApp

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Create `.env` file

Create `ResortApp/.env`:

```env
# For PostgreSQL
DATABASE_URL=postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb

# OR for SQLite (quick testing)
# DATABASE_URL=sqlite:///./orchid.db

SECRET_KEY=orchid-secret-key-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
HOST=0.0.0.0
PORT=8011
ROOT_PATH=
```

---

## Step 4: Start Backend

```powershell
# Make sure venv is activated
.\venv\Scripts\activate

# Start backend on port 8011 (Orchid uses 8011, not 8000)
uvicorn app.main:app --reload --host 127.0.0.1 --port 8011
```

**Backend will run on:** `http://localhost:8011`  
**API Docs:** `http://localhost:8011/docs`

---

## Step 5: Setup Frontend - User Site

Open a **new terminal**:

```powershell
cd C:\releasing\orchid\userend\userend

# Install dependencies
npm install --legacy-peer-deps

# Update package.json homepage for local dev
# Change "homepage": "/orchid" to "homepage": "/"

# Start development server
npm start
```

**User frontend will run on:** `http://localhost:3002` (or 3000 if 3002 is taken)

---

## Step 6: Setup Frontend - Admin Dashboard

Open **another terminal**:

```powershell
cd C:\releasing\orchid\dasboard

# Install dependencies
npm install --legacy-peer-deps

# Update package.json homepage for local dev
# Change "homepage": "/orchidadmin" to "homepage": "/"

# Start development server
npm start
```

**Admin dashboard will run on:** `http://localhost:3000` (or next available port)

---

## Step 7: Create Admin User

Once backend is running, create admin user:

```powershell
# PowerShell
Invoke-RestMethod -Uri "http://localhost:8011/api/users/setup-admin" `
     -Method POST `
     -ContentType "application/json" `
     -Body '{
       "name": "Orchid Admin",
       "email": "admin@orchid.com",
       "password": "admin123",
       "phone": "+1234567890"
     }'
```

Or use curl:
```bash
curl -X POST "http://localhost:8011/api/users/setup-admin" \
     -H "Content-Type: application/json" \
     -d '{"name": "Orchid Admin", "email": "admin@orchid.com", "password": "admin123", "phone": "+1234567890"}'
```

---

## Step 8: Update Frontend API URLs

### User Frontend (`userend/userend/src/utils/env.js`)

```javascript
export const getApiBaseUrl = () => {
  // For local development
  return "http://localhost:8011/api";
};
```

### Admin Dashboard (`dasboard/src/utils/env.js`)

```javascript
export const getApiBaseUrl = () => {
  // For local development
  return "http://localhost:8011/api";
};
```

---

## Quick Start Script (Windows)

Create `start-orchid-local.bat`:

```bat
@echo off
echo ========================================
echo Starting Orchid Resort Locally
echo ========================================
echo.

echo [1/3] Starting Backend...
start "Orchid Backend" cmd /k "cd /d C:\releasing\orchid\ResortApp && venv\Scripts\activate && uvicorn app.main:app --reload --host 127.0.0.1 --port 8011"

timeout /t 5 /nobreak >nul

echo [2/3] Starting User Frontend...
start "Orchid User Frontend" cmd /k "cd /d C:\releasing\orchid\userend\userend && npm start"

timeout /t 5 /nobreak >nul

echo [3/3] Starting Admin Dashboard...
start "Orchid Admin" cmd /k "cd /d C:\releasing\orchid\dasboard && npm start"

echo.
echo ========================================
echo All services starting...
echo ========================================
echo Backend: http://localhost:8011
echo User Frontend: http://localhost:3002
echo Admin Dashboard: http://localhost:3000
echo.
echo Press any key to exit...
pause >nul
```

---

## Access Points

Once running:

- **Backend API:** `http://localhost:8011`
- **API Docs:** `http://localhost:8011/docs`
- **User Frontend:** `http://localhost:3002` (or 3000)
- **Admin Dashboard:** `http://localhost:3000` (or 3001)

---

## Login Credentials

- **Email:** `admin@orchid.com`
- **Password:** `admin123`

---

## Troubleshooting

### Port 8011 Already in Use

```powershell
# Find process using port 8011
netstat -ano | findstr :8011

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or use different port
uvicorn app.main:app --reload --host 127.0.0.1 --port 8012
```

### Database Connection Error

```powershell
# Check PostgreSQL is running
# Windows: Check Services for "postgresql"

# Test connection
cd ResortApp
.\venv\Scripts\activate
python -c "from app.database import engine; engine.connect(); print('Connected!')"
```

### Frontend Can't Connect to API

1. Check backend is running: `http://localhost:8011/health`
2. Update API URL in `env.js` files
3. Check CORS settings in backend

---

## Environment Variables Summary

**Backend (`ResortApp/.env`):**
```env
DATABASE_URL=postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb
SECRET_KEY=orchid-secret-key
PORT=8011
```

**Frontend (update `env.js` files):**
- API Base: `http://localhost:8011/api`
- Media Base: `http://localhost:8011`

---

## Notes

- Orchid uses **port 8011** (different from Pomma which uses 8010)
- Database: `orchiddb` (separate from `pommodb`)
- All paths use `/orchid/` and `/orchidadmin/` in production
- For local dev, use root paths `/` or configure React Router basename

