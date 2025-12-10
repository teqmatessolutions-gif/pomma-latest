# Orchid Path Details - https://teqmates.com/orchid/

## Overview

The path `https://teqmates.com/orchid/` is a **path-based route** on the main domain, not a subdomain. Based on the current nginx configuration and codebase structure, here's how it works:

---

## Current Configuration Status

### ❌ Not Explicitly Configured in Nginx

Looking at the nginx configuration files (`nginx_resort.conf`), there is **no specific location block** for `/orchid/`. This means:

1. **If it exists on the server**, it's likely handled by:
   - A backend fallback route (`@backend`)
   - A React Router route in the frontend
   - A separate nginx configuration on the server not in this codebase

2. **If it doesn't exist**, requests to `/orchid/` would:
   - Fall through to the backend API (if matching a route pattern)
   - Return 404 if no matching route exists

---

## How It Could Work

### Option 1: Backend Route Handling

If `/orchid/` is handled by the backend, it would be processed by FastAPI:

```python
# Potential backend route (not currently in codebase)
@router.get("/orchid/")
def get_orchid_rooms():
    # Return orchid-specific content
    pass
```

**Nginx Behavior:**
- Since there's no specific location block, it would match the backend fallback
- Request goes to: `http://127.0.0.1:8010/orchid/` (pomma_backend)
- Or: `http://127.0.0.1:8000/orchid/` (resort_backend)

### Option 2: Frontend React Router

If it's a frontend route, the React app would handle it:

```javascript
// In userend/userend/src/App.js
// React Router would handle /orchid/ path
// The app is served from /pommaholidays, so it would be:
// https://teqmates.com/pommaholidays/orchid/
```

**Current Frontend Setup:**
- Frontend is served from `/pommaholidays` path
- React Router handles client-side routing
- `/orchid/` would need to be a route within the React app

### Option 3: Separate Nginx Location Block (On Server)

If configured on the server but not in this codebase, it might look like:

```nginx
# Location block for /orchid/ path
location /orchid {
    alias /var/www/resort/Resort_first/orchid/build;
    try_files $uri $uri/ /orchid/index.html;
}

location /orchid/static/ {
    alias /var/www/resort/Resort_first/orchid/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

---

## Recommended Configuration

To properly set up `/orchid/` as a dedicated path for Orchid room type content:

### Step 1: Add Nginx Location Block

Add this to your nginx configuration (`nginx_resort.conf`):

```nginx
# Orchid path - serves filtered content for Orchid rooms
location /orchid {
    alias /var/www/resort/Resort_first/userend/userend/build;
    try_files $uri $uri/ /orchid/index.html;
    
    # Add custom header to identify orchid path
    add_header X-Path-Type "orchid" always;
}

location /orchid/static/ {
    alias /var/www/resort/Resort_first/userend/userend/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# API routes for orchid path
location /orchid/api/ {
    # Remove /orchid/api prefix before passing to backend
    rewrite ^/orchid/api/(.*)$ /api/$1 break;
    proxy_pass http://pomma_backend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Room-Type "orchid";
    proxy_buffering off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

### Step 2: Frontend Configuration

Update the frontend to detect the `/orchid/` path and filter rooms:

```javascript
// In userend/userend/src/App.js
useEffect(() => {
    const fetchRooms = async () => {
        try {
            const response = await fetch(`${getApiBaseUrl()}/rooms`);
            const allRooms = await response.json();
            
            // Check if we're on /orchid/ path
            const isOrchidPath = window.location.pathname.startsWith('/orchid');
            
            // Filter for orchid rooms if on orchid path
            const filteredRooms = isOrchidPath 
                ? allRooms.filter(room => 
                    room.type && room.type.toLowerCase() === 'orchid'
                  )
                : allRooms;
            
            setRooms(filteredRooms);
        } catch (error) {
            console.error('Error fetching rooms:', error);
        }
    };
    
    fetchRooms();
}, []);
```

### Step 3: Update package.json

If using a separate build for orchid:

```json
{
  "homepage": "/orchid"
}
```

Or if reusing the same frontend:

```json
{
  "homepage": "/pommaholidays"
}
```

---

## Current Path Structure

Based on the nginx configuration, here's the current path structure:

```
teqmates.com/
├── / → Landing page
├── /pommaholidays → User frontend (React app)
├── /pommaadmin → Admin dashboard (React app)
├── /pommaapi → Backend API
├── /orchid → ❓ Not configured (would fall to backend or 404)
└── /pomma/uploads → File uploads
```

---

## How to Check Current Status

### 1. Check Nginx Configuration on Server

```bash
# SSH to server
ssh root@139.84.211.200

# Check active nginx config
cat /etc/nginx/sites-enabled/* | grep -A 10 "location /orchid"

# Or check all nginx configs
grep -r "orchid" /etc/nginx/
```

### 2. Check Backend Routes

```bash
# Check if backend has /orchid/ route
curl https://teqmates.com/pommaapi/api/orchid/
curl https://teqmates.com/pommaapi/orchid/
```

### 3. Check Frontend Routes

```bash
# Check if frontend handles /orchid/
curl -I https://teqmates.com/orchid/
```

### 4. Check Server Logs

```bash
# Check nginx access logs
sudo tail -f /var/log/nginx/access.log | grep orchid

# Check nginx error logs
sudo tail -f /var/log/nginx/error.log | grep orchid

# Check backend logs
sudo journalctl -u resort.service -f | grep orchid
```

---

## Database Query for Orchid Rooms

If you want to see what Orchid rooms exist:

```sql
-- Connect to database
sudo -u postgres psql pommodb

-- Query orchid rooms
SELECT id, number, type, price, status, adults, children 
FROM rooms 
WHERE LOWER(type) LIKE '%orchid%';

-- Or exact match
SELECT * FROM rooms WHERE LOWER(type) = 'orchid';
```

---

## API Endpoints for Orchid Rooms

### Get All Rooms (Filter in Frontend)
```
GET https://teqmates.com/pommaapi/api/rooms
```

### Filter by Type (If Backend Endpoint Exists)
```
GET https://teqmates.com/pommaapi/api/rooms?type=orchid
```

### Custom Orchid Endpoint (Would Need to Be Created)
```python
# In ResortApp/app/api/room.py
@router.get("/rooms/orchid", response_model=list[RoomOut])
def get_orchid_rooms(db: Session = Depends(get_db)):
    rooms = db.query(Room).filter(
        Room.type.ilike("%orchid%")
    ).all()
    return rooms
```

Then access via:
```
GET https://teqmates.com/pommaapi/api/rooms/orchid
```

---

## Complete Setup Example

If you want to set up `/orchid/` as a fully functional path:

### 1. Nginx Configuration

```nginx
# Add to nginx_resort.conf after /pommaholidays location block

# Orchid path - serves userend with orchid filtering
location /orchid {
    alias /var/www/resort/Resort_first/userend/userend/build;
    try_files $uri $uri/ /orchid/index.html;
}

location /orchid/static/ {
    alias /var/www/resort/Resort_first/userend/userend/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### 2. Frontend Detection

```javascript
// Detect orchid path and filter rooms
const path = window.location.pathname;
const isOrchidPath = path.startsWith('/orchid');

if (isOrchidPath) {
    // Filter rooms for orchid type
    const orchidRooms = rooms.filter(room => 
        room.type && room.type.toLowerCase().includes('orchid')
    );
    setRooms(orchidRooms);
}
```

### 3. Deploy

```bash
# SSH to server
ssh root@139.84.211.200

# Edit nginx config
sudo nano /etc/nginx/sites-available/default
# or
sudo nano /etc/nginx/conf.d/resort.conf

# Add orchid location blocks
# Test configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Rebuild frontend if needed
cd /var/www/resort/Resort_first/userend/userend
npm run build
```

---

## Summary

**Current State:**
- ❓ `/orchid/` path is **not explicitly configured** in the local nginx config files
- ✅ Could be handled by backend fallback or React Router
- ✅ May be configured on the server but not in this codebase

**To Make It Work:**
1. Add nginx location block for `/orchid/`
2. Configure frontend to filter rooms when on `/orchid/` path
3. Optionally create backend endpoint for orchid rooms
4. Deploy and test

**URL Structure:**
- Main: `https://teqmates.com/orchid/`
- API: `https://teqmates.com/pommaapi/api/rooms` (filter for orchid)
- Static: `https://teqmates.com/orchid/static/`

---

## Testing

After configuration, test with:

```bash
# Test the path
curl -I https://teqmates.com/orchid/

# Test API
curl https://teqmates.com/pommaapi/api/rooms | jq '.[] | select(.type | ascii_downcase | contains("orchid"))'

# Check in browser
# Visit: https://teqmates.com/orchid/
```

---

## References

- Main Domain: [https://teqmates.com](https://teqmates.com)
- Orchid Path: [https://teqmates.com/orchid/](https://teqmates.com/orchid/)
- Nginx Config: `nginx_resort.conf`
- Backend API: `ResortApp/app/api/room.py`
- Frontend: `userend/userend/src/App.js`

