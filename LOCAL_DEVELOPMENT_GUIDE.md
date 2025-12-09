# Pomma Holidays - Local Development Guide

This guide will help you run Pomma Holidays applications on your local machine.

## 🎯 Overview

The Pomma Holidays system consists of:
1. **Backend API** (FastAPI - Python) - Port 8010
2. **Admin Dashboard** (React) - Port 3000
3. **User Frontend** (React) - Port 3002

## 📋 Prerequisites

- **Python 3.10+** with pip
- **Node.js 18+** with npm
- **PostgreSQL** database

## 🚀 Quick Start

### 1. Start the Backend API

```bash
# Navigate to backend directory
cd ResortApp

# Create virtual environment (first time only)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
source venv/bin/activate

# Install dependencies (first time only)
pip install -r requirements.txt

# Create .env file with database configuration
echo "DATABASE_URL=postgresql://resort_user:ResortDB2024@localhost:5432/pommadb" > .env

# Start the server
uvicorn main:app --reload --host 0.0.0.0 --port 8010
```

Backend will be available at: **http://localhost:8010**

### 2. Start the Admin Dashboard

```bash
# Navigate to dashboard directory
cd dasboard

# Install dependencies (first time only)
npm install

# Start development server
npm start
```

Admin Dashboard will be available at: **http://localhost:3000**

### 3. Start the User Frontend

```bash
# Navigate to user frontend directory
cd userend/userend

# Install dependencies (first time only)
npm install

# Start development server
npm start
```

User Frontend will be available at: **http://localhost:3002/pommaholidays**

## 🔧 Configuration

### Environment Variables

Both frontend applications have `.env.local` files for configuration:

**dasboard/.env.local:**
```env
REACT_APP_API_BASE_URL=http://localhost:8010/api
REACT_APP_MEDIA_BASE_URL=http://localhost:8010
```

**userend/userend/.env.local:**
```env
REACT_APP_API_BASE_URL=http://localhost:8010/api
REACT_APP_MEDIA_BASE_URL=http://localhost:8010
PORT=3002
```

## 📦 Building for Production

### Admin Dashboard
```bash
cd dasboard
npm run build:prod
```
This creates a production build with the `/pommaadmin` base path.

### User Frontend
```bash
cd userend/userend
npm run build:prod
```
This creates a production build with the `/pommaholidays` base path.

## 🔍 Key Differences: Local vs Production

### Local Development
- Apps run at root path: `/`
- Direct API calls to `localhost:8010`
- Hot reload enabled
- Development mode optimizations

### Production Deployment
- Apps run at subdirectories: `/pommaadmin` and `/pommaholidays`
- API calls through nginx: `/pommaapi/api`
- Optimized builds
- Static file serving

## 🐛 Troubleshooting

### Blank Page on Localhost

**Problem:** The app shows a blank page when accessing `http://localhost:3000` or `http://localhost:3002`

**Solution:** This is now fixed! The applications automatically detect localhost and use root paths.

### API Connection Errors

**Problem:** Frontend can't connect to the backend API

**Solutions:**
1. Ensure backend is running on port 8010
2. Check `.env.local` file has correct API URL
3. Check browser console for CORS errors
4. Verify database connection in backend

### Port Already in Use

**Problem:** Port 3000 or 3002 is already in use

**Solutions:**
1. Kill the process using the port:
   ```bash
   # On Windows
   netstat -ano | findstr :3000
   taskkill /PID <PID> /F
   
   # On Mac/Linux
   lsof -ti:3000 | xargs kill -9
   ```
2. Or change the port in package.json scripts

### Database Connection Failed

**Problem:** Backend can't connect to PostgreSQL

**Solutions:**
1. Ensure PostgreSQL is running
2. Verify database credentials in `.env` file
3. Create the database if it doesn't exist:
   ```sql
   CREATE DATABASE pommadb;
   CREATE USER resort_user WITH PASSWORD 'ResortDB2024';
   GRANT ALL PRIVILEGES ON DATABASE pommadb TO resort_user;
   ```

## 📚 Additional Resources

- **API Documentation:** Check `api.md` for API endpoints
- **Architecture:** See `architecture.md` for system overview
- **Deployment:** See deployment guide for production setup

## 🎉 Success Checklist

- [ ] Backend API running on http://localhost:8010
- [ ] Admin Dashboard accessible at http://localhost:3000
- [ ] User Frontend accessible at http://localhost:3002
- [ ] Can login to admin dashboard
- [ ] Can view pages on user frontend
- [ ] API calls working (check Network tab in browser DevTools)

---

**Note:** The applications are configured to work seamlessly in both local development and production environments. No manual configuration changes needed when switching between environments!

