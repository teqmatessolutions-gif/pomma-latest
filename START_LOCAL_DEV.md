# 🚀 Quick Start - Pomma Holidays Local Development

## What Was Fixed

✅ **Removed hardcoded paths** - Apps now detect localhost automatically  
✅ **Updated routing** - Dashboard routes work at root path `/` in development  
✅ **Fixed API URLs** - Automatically use `localhost:8010` in development  
✅ **Removed homepage config** - No more blank pages on localhost  

## Start Development Servers

### Terminal 1: Backend API
```bash
cd ResortApp
# Activate virtual environment
venv\Scripts\activate  # Windows
# OR
source venv/bin/activate  # Mac/Linux

# Start backend
uvicorn main:app --reload --host 0.0.0.0 --port 8010
```
**Backend URL:** http://localhost:8010

---

### Terminal 2: Admin Dashboard  
```bash
cd dasboard
npm install  # First time only
npm start
```
**Admin Dashboard:** http://localhost:3000

---

### Terminal 3: User Frontend
```bash
cd userend/userend
npm install  # First time only
npm start
```
**User Frontend:** http://localhost:3002

---

## What Changed

### 1. **dasboard/src/App.js**
Added localhost detection to router basename:
```javascript
const getRouterBasename = () => {
  // Check if running on localhost for development
  const isLocalhost = window.location.hostname === "localhost" || 
                      window.location.hostname === "127.0.0.1";
  
  // For localhost, use root path
  if (isLocalhost) {
    return "/";
  }
  
  // For production, use /pommaadmin or /admin
  ...
}
```

### 2. **package.json files**
Removed `"homepage"` field and added separate build scripts:
- `npm start` - Development (uses `/` path)
- `npm run build:prod` - Production (uses `/pommaadmin` or `/pommaholidays` path)

### 3. **utils/env.js files**
Enhanced environment detection:
```javascript
export const isLocalhost = () => {
  const hostname = window.location.hostname;
  return hostname === "localhost" || 
         hostname === "127.0.0.1" || 
         hostname.startsWith("192.168.");
};

export const getApiBaseUrl = () => {
  if (isLocalhost()) {
    return "http://localhost:8010/api";
  }
  // Production paths...
};
```

## Environment Configuration

### Optional: Create .env files

**dasboard/.env.local** (optional):
```env
REACT_APP_API_BASE_URL=http://localhost:8010/api
REACT_APP_MEDIA_BASE_URL=http://localhost:8010
```

**userend/userend/.env.local** (optional):
```env
REACT_APP_API_BASE_URL=http://localhost:8010/api
REACT_APP_MEDIA_BASE_URL=http://localhost:8010
PORT=3002
```

> **Note:** These are optional! The apps will auto-detect localhost and use correct URLs.

## Verify It Works

### Check Admin Dashboard (http://localhost:3000)
1. Page loads without blank screen ✅
2. Login page visible ✅
3. Can login with credentials ✅
4. Dashboard pages load correctly ✅

### Check User Frontend (http://localhost:3002)
1. Landing page loads ✅
2. Images and content visible ✅
3. Navigation works ✅
4. No console errors ✅

### Check Backend API (http://localhost:8010)
1. Visit http://localhost:8010/docs for Swagger UI ✅
2. API endpoints respond ✅

## Production Deployment

When deploying to production, use:

```bash
# Admin Dashboard
cd dasboard
npm run build:prod

# User Frontend
cd userend/userend
npm run build:prod
```

These commands set `PUBLIC_URL` to the correct subdirectory paths.

## Troubleshooting

### Still seeing blank page?
1. Clear browser cache (Ctrl+Shift+Delete)
2. Stop dev server and restart: `npm start`
3. Check browser console for errors (F12)

### API connection errors?
1. Ensure backend is running on port 8010
2. Check `http://localhost:8010/docs` loads
3. Check Network tab in browser DevTools

### Port already in use?
```bash
# Change port in package.json:
"start": "set PORT=3001 && craco start"  # Use different port
```

---

## Summary

🎉 **You're all set!** The applications now work seamlessly in both environments:

- **Local Development:** Root paths (`/`), localhost APIs
- **Production:** Subdirectory paths (`/pommaadmin`, `/pommaholidays`), production APIs

No manual configuration changes needed when switching between environments!

