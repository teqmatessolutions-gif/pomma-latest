# 🔧 Quick Fix - Access Apps with Subdirectory Paths on Localhost

## The Issue
You want to access:
- `http://localhost:3000/pommaadmin` ❌ (was showing blank)
- `http://localhost:3002/pommaholidays` ❌ (was showing blank)

## The Solution

Use the new `start:pomma` scripts that enable subdirectory paths in development:

### Option 1: Run with Subdirectory Paths (like production)

**Terminal 1 - Admin Dashboard:**
```bash
cd dasboard
npm run start:pomma
```
Then access: **http://localhost:3000/pommaadmin** ✅

**Terminal 2 - User Frontend:**
```bash
cd userend\userend
npm run start:pomma
```
Then access: **http://localhost:3002/pommaholidays** ✅

---

### Option 2: Run at Root Paths (simpler for development)

**Terminal 1 - Admin Dashboard:**
```bash
cd dasboard
npm start
```
Then access: **http://localhost:3000/** ✅

**Terminal 2 - User Frontend:**
```bash
cd userend\userend
npm start
```
Then access: **http://localhost:3002/** ✅

---

## What Changed

### 1. Router now respects the actual URL path
The `getRouterBasename()` function now checks if the URL contains `/pommaadmin` or `/admin` and uses it:

```javascript
const getRouterBasename = () => {
  const path = window.location.pathname || "";
  
  // If path includes /pommaadmin, use it
  if (path.startsWith("/pommaadmin")) {
    return "/pommaadmin";  // ✅ Works on localhost now!
  }
  
  // Default to root for simple localhost development
  return "/";
};
```

### 2. Added `start:pomma` scripts
These scripts set the `PUBLIC_URL` environment variable to enable subdirectory paths in development:

**dasboard/package.json:**
```json
"start:pomma": "set PUBLIC_URL=/pommaadmin && craco start"
```

**userend/userend/package.json:**
```json
"start:pomma": "set PORT=3002 && set PUBLIC_URL=/pommaholidays && react-scripts start"
```

---

## Quick Command Reference

| What You Want | Command | Access URL |
|---------------|---------|------------|
| Admin at root | `npm start` | http://localhost:3000 |
| Admin with path | `npm run start:pomma` | http://localhost:3000/pommaadmin |
| User at root | `npm start` | http://localhost:3002 |
| User with path | `npm run start:pomma` | http://localhost:3002/pommaholidays |

---

## 🚀 Right Now - Try This

Stop your current dev servers (Ctrl+C) and restart with:

**Terminal 1:**
```bash
cd D:\resort_oc_10\Resortwithlandingpage\pomma-latest\dasboard
npm run start:pomma
```

**Terminal 2:**
```bash
cd D:\resort_oc_10\Resortwithlandingpage\pomma-latest\userend\userend
npm run start:pomma
```

Then access:
- **Admin:** http://localhost:3000/pommaadmin ✅
- **User:** http://localhost:3002/pommaholidays ✅

Both should work now! 🎉

---

## Why This Works

1. **PUBLIC_URL=/pommaadmin** tells Create React App to serve assets from `/pommaadmin/static/...`
2. **Router basename checks actual path** and uses `/pommaadmin` when detected
3. **Works in both modes:**
   - Root path: `npm start` → http://localhost:3000/
   - Subdirectory path: `npm run start:pomma` → http://localhost:3000/pommaadmin

No more blank pages! 🚀

