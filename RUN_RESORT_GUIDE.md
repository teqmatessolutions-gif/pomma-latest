# Resort Management System - Run Guide

## Quick Start

### Option 1: Run All Services at Once (Recommended)

```powershell
cd C:\releasing\Resort
.\run_all.ps1
```

This will start:
- Backend API on port 8012
- Admin Dashboard on port 3000
- User Frontend on port 3001

Each service runs in a separate PowerShell window.

---

### Option 2: Run Services Individually

#### 1. Setup (First Time Only)

```powershell
cd C:\releasing\Resort
.\setup_and_run_resort.ps1
```

#### 2. Run Backend

```powershell
cd C:\releasing\Resort
.\run_backend.ps1
```

Backend runs on: `http://localhost:8012`
API Docs: `http://localhost:8012/docs`

#### 3. Run Admin Dashboard

Open a **new PowerShell window**:

```powershell
cd C:\releasing\Resort
.\run_admin.ps1
```

Admin Dashboard runs on: `http://localhost:3000`

#### 4. Run User Frontend

Open **another PowerShell window**:

```powershell
cd C:\releasing\Resort
.\run_userfrontend.ps1
```

User Frontend runs on: `http://localhost:3001`

---

## Prerequisites

Before running, make sure you have:

1. **Python 3.11+** installed
2. **Node.js 16+** installed
3. **PostgreSQL** installed and running
4. **Database created** (run `setup_resort_database_local.ps1` from Pumaholidays directory)

---

## First Time Setup

### Step 1: Clone Repository

If the Resort directory is empty, run:

```powershell
cd C:\releasing\Resort
.\setup_and_run_resort.ps1
```

This will:
- Clone the repository from GitHub
- Check prerequisites
- Prepare the project

### Step 2: Setup Database

```powershell
cd C:\releasing\Pumaholidays
.\setup_resort_database_local.ps1
```

This creates:
- Database: `resort`
- User: `resortuser`
- Password: `resort123`

### Step 3: Run Services

```powershell
cd C:\releasing\Resort
.\run_all.ps1
```

---

## Service URLs

| Service | URL | Port |
|---------|-----|------|
| Backend API | http://localhost:8012 | 8012 |
| API Documentation | http://localhost:8012/docs | 8012 |
| Admin Dashboard | http://localhost:3000 | 3000 |
| User Frontend | http://localhost:3001 | 3001 |

---

## Troubleshooting

### Port Already in Use

If a port is already in use:

```powershell
# Find process using port
netstat -ano | findstr :8012
netstat -ano | findstr :3000
netstat -ano | findstr :3001

# Kill the process (replace PID)
taskkill /PID <PID> /F
```

### Database Connection Failed

1. Check PostgreSQL is running:
   ```powershell
   Get-Service postgresql*
   ```

2. Verify database exists:
   ```powershell
   psql -U resortuser -d resort -c "SELECT version();"
   ```

3. Check .env file in `ResortApp` directory has correct database credentials

### Dependencies Not Installing

```powershell
# For backend
cd C:\releasing\Resort\ResortApp
.\venv\Scripts\activate
pip install -r requirements.txt

# For frontend
cd C:\releasing\Resort\dasboard
rm -r node_modules
npm install --legacy-peer-deps
```

### Services Not Starting

1. **Backend:**
   - Check Python is installed: `python --version`
   - Check virtual environment exists: `ResortApp\venv`
   - Check .env file exists

2. **Frontend:**
   - Check Node.js is installed: `node --version`
   - Check node_modules exists
   - Try clearing cache: `npm cache clean --force`

---

## Development Workflow

1. **Make changes to code**
2. **Backend:** Auto-reloads if using `uvicorn --reload`
3. **Frontend:** Auto-reloads in browser (React hot reload)
4. **Test changes** in browser

---

## Stopping Services

- **Backend:** Press `Ctrl+C` in the backend window
- **Admin:** Press `Ctrl+C` in the admin window
- **User Frontend:** Press `Ctrl+C` in the user frontend window
- **All at once:** Close all PowerShell windows

---

## Production Deployment

For server deployment, see:
- `deploy_resort_to_server.sh` - Server deployment script
- `RESORT_DEPLOYMENT_COMPLETE.md` - Complete deployment guide

---

## Quick Commands Reference

```powershell
# Setup (first time)
cd C:\releasing\Resort
.\setup_and_run_resort.ps1

# Run all services
.\run_all.ps1

# Run individually
.\run_backend.ps1
.\run_admin.ps1
.\run_userfrontend.ps1

# Check if services are running
netstat -ano | findstr :8012
netstat -ano | findstr :3000
netstat -ano | findstr :3001
```

---

## Support

For issues:
- Check logs in the PowerShell windows
- Verify prerequisites are installed
- Check database connection
- Review `RESORT_LOCAL_SETUP.md` for detailed setup

