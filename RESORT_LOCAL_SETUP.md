# Resort Management System - Local Setup Guide

## Overview

This guide will help you set up the Resort Management System on your local Windows machine.

---

## Prerequisites

- **Python 3.11+** installed
- **Node.js 16+** and npm installed
- **PostgreSQL** installed and running
- **Git** installed

---

## Step 1: Clone Repository

```powershell
# Navigate to your working directory
cd C:\releasing

# Clone the repository
git clone https://github.com/teqmatessolutions-gif/Resort.git

# Navigate to the project
cd Resort
```

---

## Step 2: Setup Database

### Option A: Using PowerShell Script (Recommended)

```powershell
# Navigate to Pumaholidays directory (where the script is)
cd C:\releasing\Pumaholidays

# Run the database setup script
.\setup_resort_database_local.ps1
```

### Option B: Manual Setup

```powershell
# Open PostgreSQL command line
psql -U postgres

# Run these SQL commands:
CREATE USER resortuser WITH PASSWORD 'resort123';
ALTER USER resortuser CREATEDB;
CREATE DATABASE resort OWNER resortuser;
GRANT ALL PRIVILEGES ON DATABASE resort TO resortuser;

# Exit psql
\q
```

---

## Step 3: Setup Backend (FastAPI)

```powershell
# Navigate to backend directory
cd C:\releasing\Resort\ResortApp

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
# Copy .env.example to .env and update with your database credentials
# Or create .env with:
```

### .env File Content

```env
# Database Configuration
DATABASE_URL=postgresql+psycopg2://resortuser:resort123@localhost:5432/resort
DB_HOST=localhost
DB_PORT=5432
DB_NAME=resort
DB_USER=resortuser
DB_PASSWORD=resort123

# Security Configuration
SECRET_KEY=your-secret-key-here-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# Server Configuration
HOST=0.0.0.0
PORT=8012
ROOT_PATH=/resortapi

# CORS Configuration
CORS_ORIGINS=http://localhost:3000,http://localhost:3001

# File Upload Configuration
MAX_FILE_SIZE=10485760
UPLOAD_FOLDER=uploads
STATIC_FOLDER=static
```

```powershell
# Create uploads and static directories
mkdir uploads
mkdir static

# Initialize database tables
python -c "from app.database import Base, engine; Base.metadata.create_all(bind=engine)"

# Or if using Alembic
alembic upgrade head

# Start the backend server
python main.py
# OR
uvicorn main:app --reload --host 0.0.0.0 --port 8012
```

Backend will run on: `http://localhost:8012`
API Docs: `http://localhost:8012/docs`

---

## Step 4: Setup Frontend Dashboard (React)

Open a new terminal window:

```powershell
# Navigate to dashboard directory
cd C:\releasing\Resort\dasboard

# Install dependencies
npm install --legacy-peer-deps

# Create .env file for frontend (if needed)
# Update API URL to point to your backend
# REACT_APP_API_URL=http://localhost:8012

# Start development server
npm start
```

Dashboard will run on: `http://localhost:3000`

---

## Step 5: Setup User Frontend (React)

Open another terminal window:

```powershell
# Navigate to userend directory
cd C:\releasing\Resort\userend\userend

# Install dependencies
npm install --legacy-peer-deps

# Create .env file for frontend (if needed)
# Update API URL to point to your backend
# REACT_APP_API_URL=http://localhost:8012

# Start development server
npm start
```

User frontend will run on: `http://localhost:3001`

---

## Step 6: Verify Setup

### Test Backend

```powershell
# Test health endpoint
curl http://localhost:8012/health

# Test API endpoint
curl http://localhost:8012/api/rooms
```

### Test Database Connection

```powershell
# Connect to database
psql -U resortuser -d resort

# List tables
\dt

# Exit
\q
```

---

## Troubleshooting

### Database Connection Issues

1. **Check PostgreSQL is running:**
   ```powershell
   # Check service status
   Get-Service postgresql*
   ```

2. **Verify connection string in .env:**
   - Make sure password matches
   - Check host and port are correct

3. **Check PostgreSQL authentication:**
   - Edit `pg_hba.conf` if needed
   - Usually located in: `C:\Program Files\PostgreSQL\<version>\data\pg_hba.conf`

### Port Already in Use

If port 8012 is already in use:

```powershell
# Find process using port
netstat -ano | findstr :8012

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

Or change the port in `.env` file and restart the backend.

### Frontend Build Issues

```powershell
# Clear node_modules and reinstall
rm -r node_modules
rm package-lock.json
npm install --legacy-peer-deps
```

---

## Development Workflow

1. **Backend Changes:**
   - Make changes to Python files
   - Backend will auto-reload if using `uvicorn --reload`

2. **Frontend Changes:**
   - Make changes to React files
   - Frontend will auto-reload in browser

3. **Database Changes:**
   - Create Alembic migration: `alembic revision --autogenerate -m "description"`
   - Apply migration: `alembic upgrade head`

---

## Next Steps

- Review the API documentation at `http://localhost:8012/docs`
- Test the admin dashboard at `http://localhost:3000`
- Test the user frontend at `http://localhost:3001`
- Set up SMTP for email functionality
- Configure production settings before deploying

---

## Quick Reference

| Component | URL | Port |
|-----------|-----|------|
| Backend API | http://localhost:8012 | 8012 |
| API Docs | http://localhost:8012/docs | 8012 |
| Admin Dashboard | http://localhost:3000 | 3000 |
| User Frontend | http://localhost:3001 | 3001 |
| Database | localhost:5432 | 5432 |

---

## Support

For issues or questions:
- Check the main deployment guide: `RESORT_DEPLOYMENT_COMPLETE.md`
- Review server deployment guide for production setup
- Check logs: Backend logs in terminal, Frontend logs in browser console

