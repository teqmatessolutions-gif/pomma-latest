# Complete Details: /orchid/ and /orchidadmin/ - API & Database Usage

## Overview

This document provides complete details about how `https://teqmates.com/orchid/` and `https://teqmates.com/orchidadmin/` use the API and database.

---

## Architecture Overview

```
User Browser
    ↓
https://teqmates.com/orchid/          (Frontend - User Interface)
https://teqmates.com/orchidadmin/     (Frontend - Admin Dashboard)
    ↓
Nginx (Port 443)
    ↓
FastAPI Backend (Port 8010 - pomma_backend)
    ↓
PostgreSQL Database (pommodb)
```

---

## 1. Frontend Paths Configuration

### `/orchid/` - User Frontend

**Purpose:** User-facing interface for Orchid room bookings

**Nginx Configuration (Recommended):**

```nginx
# Orchid user frontend
location /orchid {
    alias /var/www/resort/Resort_first/userend/userend/build;
    try_files $uri $uri/ /orchid/index.html;
    
    # Add header to identify orchid path
    add_header X-Path-Type "orchid" always;
}

location /orchid/static/ {
    alias /var/www/resort/Resort_first/userend/userend/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# API routes for orchid frontend
location /orchid/api/ {
    rewrite ^/orchid/api/(.*)$ /$1 break;
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

**Frontend Build Path:**
- **Location:** `/var/www/resort/Resort_first/userend/userend/build`
- **Source:** `userend/userend/` directory
- **Build Command:** `npm run build`
- **Homepage Config:** Set `"homepage": "/orchid"` in `package.json`

---

### `/orchidadmin/` - Admin Dashboard

**Purpose:** Admin interface for managing Orchid rooms and bookings

**Nginx Configuration (Recommended):**

```nginx
# Orchid admin dashboard
location /orchidadmin {
    alias /var/www/resort/Resort_first/dasboard/build;
    try_files $uri $uri/ /orchidadmin/index.html;
    
    # Add header to identify orchid admin path
    add_header X-Path-Type "orchid-admin" always;
}

location /orchidadmin/static/ {
    alias /var/www/resort/Resort_first/dasboard/build/static/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# API routes for orchid admin
location /orchidadmin/api/ {
    rewrite ^/orchidadmin/api/(.*)$ /$1 break;
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

**Frontend Build Path:**
- **Location:** `/var/www/resort/Resort_first/dasboard/build`
- **Source:** `dasboard/` directory
- **Build Command:** `npm run build`
- **Homepage Config:** Set `"homepage": "/orchidadmin"` in `package.json`

---

## 2. API Configuration

### Backend Server

**Upstream Configuration:**
```nginx
upstream pomma_backend {
    server 127.0.0.1:8010;
    keepalive 32;
}
```

**Backend Service:**
- **Port:** `8010`
- **Service Name:** `pommoapi.service` or `resort.service`
- **Location:** `/var/www/resort/pomma_production/ResortApp`
- **Framework:** FastAPI (Python)

### API Base URLs

**For `/orchid/` Frontend:**
```javascript
// In userend/userend/src/utils/env.js
export const getApiBaseUrl = () => {
  if (typeof window !== "undefined" && window.location.pathname.startsWith("/orchid")) {
    return `${window.location.origin}/orchid/api`;
  }
  // Fallback
  return process.env.NODE_ENV === "production"
    ? "https://www.teqmates.com/pommaapi/api"
    : "http://localhost:8000/api";
};
```

**For `/orchidadmin/` Frontend:**
```javascript
// In dasboard/src/utils/env.js
export const getApiBaseUrl = () => {
  if (typeof window !== "undefined" && window.location.pathname.startsWith("/orchidadmin")) {
    return `${window.location.origin}/orchidadmin/api`;
  }
  // Fallback
  return process.env.NODE_ENV === "production"
    ? "https://www.teqmates.com/pommaapi/api"
    : "http://localhost:8000/api";
};
```

---

## 3. Database Configuration

### Database Connection

**File:** `ResortApp/app/database.py`

```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv
import os

# Load from .env file
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL")

# Example: postgresql://user:password@localhost:5432/pommodb
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={
        "sslmode": "disable",
        "connect_timeout": 10,
        "options": "-c statement_timeout=30000"
    },
    pool_size=20,
    max_overflow=30,
    pool_pre_ping=True,
    pool_recycle=1800,
    pool_timeout=30
)

SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()
```

**Database Details:**
- **Type:** PostgreSQL
- **Database Name:** `pommodb` (or as configured in DATABASE_URL)
- **Connection Pool:** 20 connections, max 30 overflow
- **Timeout:** 30 seconds for statements

### Environment Variables

**File:** `ResortApp/.env` or `ResortApp/.env.production`

```env
DATABASE_URL=postgresql://resort_user:password@localhost:5432/pommodb
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
```

---

## 4. API Endpoints Used

### Room Endpoints

**Get All Rooms:**
```
GET /api/rooms
GET /orchid/api/rooms
GET /orchidadmin/api/rooms
```

**Backend Implementation:**
```python
# ResortApp/app/api/room.py
@router.get("", response_model=list[RoomOut])
def get_rooms(db: Session = Depends(get_db), skip: int = 0, limit: int = 20):
    return _get_rooms_impl(db, skip, limit)
```

**Database Query:**
```python
rooms = db.query(Room).offset(skip).limit(limit).all()
```

**SQL Equivalent:**
```sql
SELECT * FROM rooms 
ORDER BY id 
LIMIT 20 OFFSET 0;
```

**Filter for Orchid Rooms:**
```python
# In frontend or backend
orchid_rooms = [room for room in rooms if room.type and 'orchid' in room.type.lower()]
```

**Or Database Query:**
```sql
SELECT * FROM rooms 
WHERE LOWER(type) LIKE '%orchid%'
ORDER BY id;
```

---

### Booking Endpoints

**Create Booking:**
```
POST /api/bookings/guest
POST /orchid/api/bookings/guest
```

**Backend Implementation:**
```python
# ResortApp/app/api/booking.py
@router.post("/guest", response_model=BookingOut)
async def create_guest_booking(
    booking: GuestBookingCreate,
    db: Session = Depends(get_db)
):
    # Creates booking in database
    # Sends email confirmation
    pass
```

**Database Tables Used:**
- `bookings` - Main booking record
- `booking_rooms` - Junction table for booking-room relationship

**SQL Insert:**
```sql
INSERT INTO bookings (guest_name, guest_email, guest_mobile, check_in, check_out, adults, children, status)
VALUES ('John Doe', 'john@example.com', '1234567890', '2024-01-01', '2024-01-05', 2, 0, 'booked')
RETURNING id;

INSERT INTO booking_rooms (booking_id, room_id)
VALUES (booking_id, room_id);
```

---

### Package Endpoints

**Get Packages:**
```
GET /api/packages
GET /orchid/api/packages
```

**Backend Implementation:**
```python
# ResortApp/app/api/packages.py
@router.get("", response_model=list[PackageOut])
def get_packages(db: Session = Depends(get_db)):
    packages = db.query(Package).all()
    return packages
```

**Database Query:**
```sql
SELECT * FROM packages;
SELECT * FROM package_images WHERE package_id = ?;
```

---

### Authentication Endpoints

**Login:**
```
POST /api/auth/login
POST /orchidadmin/api/auth/login
```

**Backend Implementation:**
```python
# ResortApp/app/api/auth.py
@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == request.username).first()
    # Verify password
    # Generate JWT token
    return {"access_token": token, "token_type": "bearer"}
```

**Database Query:**
```sql
SELECT * FROM users 
WHERE username = 'admin' 
AND is_active = true;
```

---

### Dashboard Endpoints

**Get KPIs:**
```
GET /api/dashboard/kpis
GET /orchidadmin/api/dashboard/kpis
```

**Backend Implementation:**
```python
# ResortApp/app/api/dashboard.py
@router.get("/kpis")
def get_kpis(db: Session = Depends(get_db)):
    # Query multiple tables
    total_bookings = db.query(Booking).count()
    total_revenue = db.query(func.sum(Booking.total_amount)).scalar()
    # ... more queries
    return {"bookings": total_bookings, "revenue": total_revenue}
```

**Database Queries:**
```sql
SELECT COUNT(*) FROM bookings;
SELECT SUM(total_amount) FROM bookings WHERE status = 'checked_out';
SELECT COUNT(*) FROM rooms WHERE status = 'Available';
```

---

## 5. Complete Request Flow

### Example: Loading Orchid Rooms in Frontend

**1. Frontend Request:**
```javascript
// In userend/userend/src/App.js
const fetchRooms = async () => {
    const apiUrl = getApiBaseUrl(); // Returns: https://teqmates.com/orchid/api
    const response = await fetch(`${apiUrl}/rooms`);
    const rooms = await response.json();
    
    // Filter for orchid rooms
    const orchidRooms = rooms.filter(room => 
        room.type && room.type.toLowerCase().includes('orchid')
    );
    setRooms(orchidRooms);
};
```

**2. Nginx Routing:**
```
Request: GET https://teqmates.com/orchid/api/rooms
    ↓
Nginx matches: location /orchid/api/
    ↓
Rewrite: /orchid/api/rooms → /rooms
    ↓
Proxy to: http://127.0.0.1:8010/rooms
```

**3. Backend Processing:**
```python
# FastAPI receives: GET /rooms
@router.get("", response_model=list[RoomOut])
def get_rooms(db: Session = Depends(get_db)):
    # Get database session
    db = SessionLocal()
    
    # Query database
    rooms = db.query(Room).all()
    
    # Serialize to JSON
    return rooms
```

**4. Database Query:**
```sql
-- Executed by SQLAlchemy
SELECT 
    rooms.id,
    rooms.number,
    rooms.type,
    rooms.price,
    rooms.status,
    rooms.adults,
    rooms.children,
    rooms.image_url,
    rooms.air_conditioning,
    rooms.wifi,
    -- ... other fields
FROM rooms;
```

**5. Response Flow:**
```
Database Results
    ↓
SQLAlchemy ORM (Python objects)
    ↓
Pydantic Serialization (JSON)
    ↓
FastAPI Response
    ↓
Nginx Proxy
    ↓
Frontend (React)
    ↓
Display in UI
```

---

## 6. Database Schema

### Rooms Table

```sql
CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    number VARCHAR UNIQUE NOT NULL,
    type VARCHAR,                    -- 'Orchid', 'Cottage', etc.
    price FLOAT,
    status VARCHAR DEFAULT 'Available',
    image_url VARCHAR,
    adults INTEGER DEFAULT 2,
    children INTEGER DEFAULT 0,
    
    -- Room features
    air_conditioning BOOLEAN DEFAULT FALSE,
    wifi BOOLEAN DEFAULT FALSE,
    bathroom BOOLEAN DEFAULT FALSE,
    living_area BOOLEAN DEFAULT FALSE,
    terrace BOOLEAN DEFAULT FALSE,
    parking BOOLEAN DEFAULT FALSE,
    kitchen BOOLEAN DEFAULT FALSE,
    family_room BOOLEAN DEFAULT FALSE,
    bbq BOOLEAN DEFAULT FALSE,
    garden BOOLEAN DEFAULT FALSE,
    dining BOOLEAN DEFAULT FALSE,
    breakfast BOOLEAN DEFAULT FALSE
);
```

### Bookings Table

```sql
CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    guest_name VARCHAR NOT NULL,
    guest_email VARCHAR,
    guest_mobile VARCHAR,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    adults INTEGER DEFAULT 1,
    children INTEGER DEFAULT 0,
    status VARCHAR DEFAULT 'booked',
    total_amount FLOAT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Booking Rooms Junction Table

```sql
CREATE TABLE booking_rooms (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(id) ON DELETE CASCADE,
    room_id INTEGER REFERENCES rooms(id) ON DELETE CASCADE,
    UNIQUE(booking_id, room_id)
);
```

---

## 7. Frontend API Calls

### User Frontend (`/orchid/`)

**Fetch Rooms:**
```javascript
// userend/userend/src/App.js
useEffect(() => {
    const fetchRooms = async () => {
        try {
            const apiBase = getApiBaseUrl(); // /orchid/api
            const response = await fetch(`${apiBase}/rooms`);
            const allRooms = await response.json();
            
            // Filter for orchid
            const orchidRooms = allRooms.filter(room => 
                room.type && room.type.toLowerCase().includes('orchid')
            );
            
            setRooms(orchidRooms);
        } catch (error) {
            console.error('Error fetching rooms:', error);
        }
    };
    
    fetchRooms();
}, []);
```

**Create Booking:**
```javascript
const handleBooking = async (bookingData) => {
    const apiBase = getApiBaseUrl(); // /orchid/api
    const response = await fetch(`${apiBase}/bookings/guest`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            guest_name: bookingData.guest_name,
            guest_email: bookingData.guest_email,
            guest_mobile: bookingData.guest_mobile,
            check_in: bookingData.check_in,
            check_out: bookingData.check_out,
            adults: bookingData.adults,
            children: bookingData.children,
            room_ids: bookingData.room_ids
        })
    });
    
    const result = await response.json();
    return result;
};
```

---

### Admin Dashboard (`/orchidadmin/`)

**Fetch All Rooms:**
```javascript
// dasboard/src/pages/CreateRooms.jsx
const fetchRooms = async () => {
    const apiBase = getApiBaseUrl(); // /orchidadmin/api
    const response = await fetch(`${apiBase}/rooms`);
    const rooms = await response.json();
    
    // Filter for orchid if needed
    const orchidRooms = rooms.filter(room => 
        room.type && room.type.toLowerCase().includes('orchid')
    );
    
    setRooms(orchidRooms);
};
```

**Create Room:**
```javascript
const createRoom = async (roomData) => {
    const apiBase = getApiBaseUrl(); // /orchidadmin/api
    const formData = new FormData();
    formData.append('number', roomData.number);
    formData.append('type', 'Orchid'); // Set type as Orchid
    formData.append('price', roomData.price);
    formData.append('adults', roomData.adults);
    formData.append('children', roomData.children);
    if (roomData.image) {
        formData.append('image', roomData.image);
    }
    
    const response = await fetch(`${apiBase}/rooms`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        },
        body: formData
    });
    
    return await response.json();
};
```

**Get Bookings:**
```javascript
// dasboard/src/pages/Bookings.jsx
const fetchBookings = async () => {
    const apiBase = getApiBaseUrl(); // /orchidadmin/api
    const response = await fetch(`${apiBase}/bookings`, {
        headers: {
            'Authorization': `Bearer ${token}`
        }
    });
    const bookings = await response.json();
    
    // Filter for orchid room bookings
    const orchidBookings = bookings.filter(booking => 
        booking.rooms && booking.rooms.some(room => 
            room.type && room.type.toLowerCase().includes('orchid')
        )
    );
    
    setBookings(orchidBookings);
};
```

---

## 8. Database Queries for Orchid

### Get All Orchid Rooms

```sql
SELECT 
    id,
    number,
    type,
    price,
    status,
    adults,
    children,
    image_url,
    air_conditioning,
    wifi,
    bathroom,
    living_area,
    terrace,
    parking,
    kitchen,
    family_room,
    bbq,
    garden,
    dining,
    breakfast
FROM rooms
WHERE LOWER(type) LIKE '%orchid%'
ORDER BY number;
```

### Get Orchid Room Bookings

```sql
SELECT 
    b.id,
    b.guest_name,
    b.guest_email,
    b.check_in,
    b.check_out,
    b.status,
    r.number as room_number,
    r.type as room_type
FROM bookings b
JOIN booking_rooms br ON b.id = br.booking_id
JOIN rooms r ON br.room_id = r.id
WHERE LOWER(r.type) LIKE '%orchid%'
ORDER BY b.check_in DESC;
```

### Get Available Orchid Rooms

```sql
SELECT r.*
FROM rooms r
WHERE LOWER(r.type) LIKE '%orchid%'
  AND r.status = 'Available'
  AND r.id NOT IN (
      SELECT br.room_id
      FROM booking_rooms br
      JOIN bookings b ON br.booking_id = b.id
      WHERE b.status IN ('booked', 'checked_in')
        AND b.check_out >= CURRENT_DATE
  );
```

### Get Orchid Room Statistics

```sql
SELECT 
    COUNT(*) as total_orchid_rooms,
    COUNT(CASE WHEN status = 'Available' THEN 1 END) as available_rooms,
    COUNT(CASE WHEN status = 'Booked' THEN 1 END) as booked_rooms,
    AVG(price) as average_price,
    SUM(CASE WHEN status = 'Available' THEN price ELSE 0 END) as potential_revenue
FROM rooms
WHERE LOWER(type) LIKE '%orchid%';
```

---

## 9. Environment Configuration

### Frontend Environment Variables

**For `/orchid/` (userend/userend/.env):**
```env
REACT_APP_API_BASE_URL=https://teqmates.com/orchid/api
REACT_APP_MEDIA_BASE_URL=https://teqmates.com/orchid
REACT_APP_ROOM_TYPE_FILTER=orchid
```

**For `/orchidadmin/` (dasboard/.env):**
```env
REACT_APP_API_BASE_URL=https://teqmates.com/orchidadmin/api
REACT_APP_MEDIA_BASE_URL=https://teqmates.com/orchidadmin
REACT_APP_ROOM_TYPE_FILTER=orchid
```

### Backend Environment Variables

**ResortApp/.env.production:**
```env
DATABASE_URL=postgresql://resort_user:password@localhost:5432/pommodb
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
HOST=0.0.0.0
PORT=8010
ROOT_PATH=/pommaapi
```

---

## 10. Complete Deployment Checklist

### 1. Nginx Configuration

```bash
# SSH to server
ssh root@139.84.211.200

# Edit nginx config
sudo nano /etc/nginx/sites-available/default
# or
sudo nano /etc/nginx/conf.d/resort.conf

# Add location blocks for /orchid/ and /orchidadmin/
# Test configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

### 2. Frontend Builds

```bash
# Build userend for /orchid/
cd /var/www/resort/Resort_first/userend/userend
npm install --legacy-peer-deps
# Update package.json: "homepage": "/orchid"
npm run build

# Build dashboard for /orchidadmin/
cd /var/www/resort/Resort_first/dasboard
npm install --legacy-peer-deps
# Update package.json: "homepage": "/orchidadmin"
npm run build
```

### 3. Backend Service

```bash
# Check backend service
sudo systemctl status pommoapi.service
# or
sudo systemctl status resort.service

# Restart if needed
sudo systemctl restart pommoapi.service
```

### 4. Database Verification

```bash
# Connect to database
sudo -u postgres psql pommodb

# Verify orchid rooms exist
SELECT COUNT(*) FROM rooms WHERE LOWER(type) LIKE '%orchid%';

# Exit
\q
```

---

## 11. Testing

### Test Frontend Paths

```bash
# Test /orchid/
curl -I https://teqmates.com/orchid/

# Test /orchidadmin/
curl -I https://teqmates.com/orchidadmin/
```

### Test API Endpoints

```bash
# Test rooms API
curl https://teqmates.com/orchid/api/rooms

# Test with authentication
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://teqmates.com/orchidadmin/api/rooms
```

### Test Database Connection

```bash
# From backend directory
cd /var/www/resort/pomma_production/ResortApp
source venv/bin/activate
python3 -c "from app.database import engine; engine.connect(); print('Database connection OK')"
```

---

## 12. Summary

### Paths
- **User Frontend:** `https://teqmates.com/orchid/`
- **Admin Dashboard:** `https://teqmates.com/orchidadmin/`

### API Base URLs
- **Orchid API:** `https://teqmates.com/orchid/api`
- **Orchid Admin API:** `https://teqmates.com/orchidadmin/api`
- **Backend:** `http://127.0.0.1:8010` (pomma_backend)

### Database
- **Type:** PostgreSQL
- **Name:** `pommodb`
- **Connection:** Via SQLAlchemy ORM
- **Pool Size:** 20 connections

### Key Endpoints
- `GET /api/rooms` - Get all rooms (filter for orchid in frontend)
- `POST /api/bookings/guest` - Create guest booking
- `GET /api/bookings` - Get all bookings (admin)
- `POST /api/rooms` - Create room (admin)
- `POST /api/auth/login` - Admin login

---

## References

- **Main Domain:** [https://teqmates.com](https://teqmates.com)
- **Orchid Frontend:** [https://teqmates.com/orchid/](https://teqmates.com/orchid/)
- **Orchid Admin:** [https://teqmates.com/orchidadmin/](https://teqmates.com/orchidadmin/)
- **Backend API Docs:** `https://teqmates.com/pommaapi/docs`
- **Server:** `root@139.84.211.200`

