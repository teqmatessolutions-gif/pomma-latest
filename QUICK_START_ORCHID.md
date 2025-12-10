# Quick Start - Orchid Local Development

## 🚀 Fastest Way to Start

Simply run:
```powershell
cd C:\releasing\orchid
.\start_all_local.bat
```

This will open 3 separate command windows:
1. **Backend API** - Port 8000
2. **Userend** - Port 3000  
3. **Dashboard** - Port 3001

---

## 📍 Access URLs

Once started, access:

- **Backend API:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **User Frontend:** http://localhost:3000
- **Admin Dashboard:** http://localhost:3001

---

## 🔑 Login Credentials

- **Email:** `admin@orchid.com`
- **Password:** `admin123`

---

## 🛠️ Manual Start (If Needed)

### Start Backend Only
```powershell
cd C:\releasing\orchid
.\start_orchid_local.bat
```

### Start Userend Only
```powershell
cd C:\releasing\orchid
.\start_userend_local.bat
```

### Start Dashboard Only
```powershell
cd C:\releasing\orchid
.\start_dashboard_local.bat
```

---

## ⚙️ Prerequisites Check

Before starting, ensure:

1. **Python 3.11+** installed
2. **Node.js 16+** installed
3. **PostgreSQL** running (or SQLite for quick testing)
4. **Virtual environment** created:
   ```powershell
   cd C:\releasing\orchid\ResortApp
   python -m venv venv
   .\venv\Scripts\activate
   pip install -r requirements.txt
   ```

5. **Database** created (if using PostgreSQL):
   ```sql
   CREATE USER orchiduser WITH PASSWORD 'orchid123';
   CREATE DATABASE orchiddb OWNER orchiduser;
   GRANT ALL PRIVILEGES ON DATABASE orchiddb TO orchiduser;
   ```

6. **Frontend dependencies** installed:
   ```powershell
   # Userend
   cd C:\releasing\orchid\userend\userend
   npm install --legacy-peer-deps
   
   # Dashboard
   cd C:\releasing\orchid\dasboard
   npm install --legacy-peer-deps
   ```

---

## 🔧 Environment Configuration

### Backend `.env` file
Location: `C:\releasing\orchid\ResortApp\.env`

```env
DATABASE_URL=postgresql+psycopg2://orchiduser:orchid123@localhost:5432/orchiddb
# OR for SQLite:
# DATABASE_URL=sqlite:///./orchid.db

SECRET_KEY=dev-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
ROOT_PATH=
```

### Frontend API Configuration
The frontend automatically detects localhost and uses:
- API: `http://localhost:8000/api`
- Media: `http://localhost:8000`

No manual configuration needed for local development!

---

## 🐛 Troubleshooting

### Port Already in Use

**Backend (8000):**
```powershell
# Find process
netstat -ano | findstr :8000
# Kill process (replace PID)
taskkill /PID <PID> /F
```

**Frontend (3000/3001):**
- React will automatically use next available port
- Check console output for actual port

### Database Connection Error

1. Check PostgreSQL is running
2. Verify database exists: `psql -U orchiduser -d orchiddb`
3. Check `.env` file has correct connection string

### Frontend Can't Connect to API

1. Verify backend is running: http://localhost:8000/health
2. Check browser console for CORS errors
3. Ensure backend CORS allows `localhost:3000` and `localhost:3001`

### Create Admin User (If Login Fails)

```powershell
Invoke-RestMethod -Uri "http://localhost:8000/api/users/setup-admin" `
     -Method POST `
     -ContentType "application/json" `
     -Body '{"name": "Orchid Admin", "email": "admin@orchid.com", "password": "admin123", "phone": "+1234567890"}'
```

---

## 📝 Notes

- **Local Development Port:** 8000 (different from production 8011)
- **Database:** `orchiddb` (separate from `pommodb`)
- **Auto-detection:** Frontend automatically uses localhost API when running locally
- **Hot Reload:** All services support hot reload during development

---

## ✅ Verification Checklist

- [ ] Backend running on port 8000
- [ ] Userend running on port 3000
- [ ] Dashboard running on port 3001
- [ ] Can access http://localhost:8000/docs
- [ ] Can login to dashboard with admin credentials
- [ ] Userend loads correctly

---

**That's it! You're ready to develop Orchid locally! 🎉**

