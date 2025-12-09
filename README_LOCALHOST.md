# 🚀 Pomma Holidays - Localhost Setup (FIXED!)

## ✅ Problem Solved!

Your apps now work at these URLs:
- **Admin Dashboard:** http://localhost:3000/pommaadmin ✅
- **User Frontend:** http://localhost:3002/pommaholidays ✅

---

## 🎯 Super Quick Start (3 Steps)

### Step 1: Start Backend API
Double-click: **`start-backend.bat`**

Or manually:
```bash
cd ResortApp
venv\Scripts\activate
uvicorn main:app --reload --host 0.0.0.0 --port 8010
```

### Step 2: Start Admin Dashboard  
Double-click: **`start-pomma-admin.bat`**

Or manually:
```bash
cd dasboard
npm run start:pomma
```

### Step 3: Start User Frontend
Double-click: **`start-pomma-userend.bat`**

Or manually:
```bash
cd userend\userend
npm run start:pomma
```

---

## 🌐 Access URLs

Once all three are running:

| Application | URL | Status |
|-------------|-----|--------|
| **Backend API** | http://localhost:8010 | ✅ Working |
| **API Docs** | http://localhost:8010/docs | ✅ Swagger UI |
| **Admin Dashboard** | http://localhost:3000/pommaadmin | ✅ Fixed! |
| **User Frontend** | http://localhost:3002/pommaholidays | ✅ Fixed! |

---

## 🔧 What Was Fixed

### Before (Broken ❌)
```
Access: http://localhost:3000/pommaadmin
Result: Blank white page 😞
```

### After (Working ✅)
```
Access: http://localhost:3000/pommaadmin
Result: App loads perfectly! 🎉
```

### Technical Changes Made:

1. **Router Configuration** (`dasboard/src/App.js`)
   ```javascript
   // Now checks actual URL path
   const getRouterBasename = () => {
     const path = window.location.pathname;
     if (path.startsWith("/pommaadmin")) {
       return "/pommaadmin";  // ✅ Works!
     }
     return "/";
   };
   ```

2. **New Start Scripts** (`package.json`)
   ```json
   {
     "start": "craco start",  // For root: localhost:3000/
     "start:pomma": "set PUBLIC_URL=/pommaadmin && craco start"  // For subdirectory
   }
   ```

3. **Environment Detection** (`utils/env.js`)
   - Automatically detects localhost
   - Uses correct API URL: `http://localhost:8010/api`

---

## 📋 Commands Reference

### Admin Dashboard

| Command | URL | Use Case |
|---------|-----|----------|
| `npm start` | http://localhost:3000/ | Simple development |
| `npm run start:pomma` | http://localhost:3000/pommaadmin | Test with production path |
| `npm run build:prod` | (build only) | Production deployment |

### User Frontend

| Command | URL | Use Case |
|---------|-----|----------|
| `npm start` | http://localhost:3002/ | Simple development |
| `npm run start:pomma` | http://localhost:3002/pommaholidays | Test with production path |
| `npm run build:prod` | (build only) | Production deployment |

---

## 🆘 Troubleshooting

### Still Seeing Blank Page?

1. **Stop all dev servers** (Ctrl+C in all terminals)

2. **Restart with the new command:**
   ```bash
   cd dasboard
   npm run start:pomma
   ```

3. **Clear browser cache:**
   - Press `Ctrl + Shift + Delete`
   - Check "Cached images and files"
   - Click "Clear data"

4. **Open in Incognito/Private mode:**
   - Chrome: `Ctrl + Shift + N`
   - Firefox: `Ctrl + Shift + P`

5. **Check the URL matches exactly:**
   - ✅ `http://localhost:3000/pommaadmin`
   - ❌ `http://localhost:3000/pommaadmin/` (extra slash)
   - ❌ `http://localhost:3000` (missing path)

### API Connection Errors?

1. **Ensure backend is running:**
   ```bash
   # Visit this URL in browser:
   http://localhost:8010/docs
   ```
   Should show Swagger UI ✅

2. **Check browser console (F12):**
   - Look for red errors
   - Should see successful API calls (green in Network tab)

### Port Already in Use?

```bash
# Windows - Find and kill process on port 3000:
netstat -ano | findstr :3000
taskkill /PID <PID_NUMBER> /F

# Or change the port in package.json
```

---

## 📁 File Structure

```
pomma-latest/
├── 📄 start-backend.bat          ← Double-click to start backend
├── 📄 start-pomma-admin.bat      ← Double-click to start admin
├── 📄 start-pomma-userend.bat    ← Double-click to start userend
│
├── 📁 ResortApp/                  Backend API (Python/FastAPI)
│   ├── main.py
│   ├── venv/
│   └── .env
│
├── 📁 dasboard/                   Admin Dashboard (React)
│   ├── src/
│   │   ├── App.js                ← ✏️ Fixed router
│   │   └── utils/env.js          ← ✏️ Fixed API URLs
│   └── package.json              ← ✏️ Added start:pomma
│
└── 📁 userend/userend/            User Frontend (React)
    ├── src/
    │   ├── App.js
    │   └── utils/env.js          ← ✏️ Fixed API URLs
    └── package.json              ← ✏️ Added start:pomma
```

---

## 🎨 How It Works Now

### When You Run `npm run start:pomma`:

```
1. Sets PUBLIC_URL=/pommaadmin
   ↓
2. React serves assets from /pommaadmin/static/...
   ↓
3. Router detects path starts with /pommaadmin
   ↓
4. Uses basename="/pommaadmin"
   ↓
5. ✅ App loads at http://localhost:3000/pommaadmin
```

### API Calls Automatically Route:

```
Frontend Request → http://localhost:8010/api/...
                ↓
         Backend API responds
                ↓
         ✅ Data flows correctly
```

---

## 🎉 Success Checklist

After starting all three services, verify:

- [ ] Backend running: http://localhost:8010/docs shows Swagger UI
- [ ] Admin accessible: http://localhost:3000/pommaadmin shows login page
- [ ] User frontend loads: http://localhost:3002/pommaholidays shows landing page
- [ ] No console errors (Press F12 → Console tab)
- [ ] Can login to admin dashboard
- [ ] Pages navigate correctly

---

## 💡 Pro Tips

1. **Use the batch files!** Just double-click:
   - `start-backend.bat`
   - `start-pomma-admin.bat`
   - `start-pomma-userend.bat`

2. **Keep all three running** in separate terminal windows

3. **For simple development**, use `npm start` (works at root path)

4. **To test production-like setup**, use `npm run start:pomma`

5. **Check backend health** at http://localhost:8010/docs anytime

---

## 🚀 You're All Set!

Your apps now work perfectly on localhost with the same paths as production:
- ✅ http://localhost:3000/pommaadmin
- ✅ http://localhost:3002/pommaholidays

No more blank pages! Happy coding! 🎊

