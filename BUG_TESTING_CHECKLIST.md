# 🐛 Bug Testing Checklist - Pomma Resort Application

**Test Date**: November 24, 2025  
**Environment**: Local Development  
**Services**: Backend (8010), Admin (3000), User (3002)

---

## ✅ Pre-Testing Setup

1. [ ] All services running (Backend, Admin Dashboard, User Frontend)
2. [ ] Open browser in **Incognito/Private mode** (to avoid cache)
3. [ ] Login credentials ready: `admin@resort.com` / `admin123`
4. [ ] Backend API health check: http://localhost:8010/health
5. [ ] Clear browser cache if using regular browser (Ctrl+Shift+Delete)

---

## 🔐 **1. Authentication & Authorization**

### Admin Dashboard Login
- [ ] Navigate to http://localhost:3000
- [ ] Login with `admin@resort.com` / `admin123`
- [ ] Redirects to `/dashboard` correctly
- [ ] Dashboard loads without blank page
- [ ] User name/role displays correctly in header
- [ ] Logout works properly

### User Frontend Access
- [ ] Navigate to http://localhost:3002
- [ ] Resort details load on homepage
- [ ] No blank page errors
- [ ] Images display correctly

---

## 📊 **2. Dashboard KPIs**

Test on: http://localhost:3000/dashboard

- [ ] Total Revenue displays
- [ ] Total Bookings count
- [ ] Available Rooms count
- [ ] Active Services count
- [ ] Food Items Available count
- [ ] No console errors
- [ ] Charts render properly

---

## 🍽️ **3. Food Management (CRITICAL - Recent Bug)**

### Food Categories
Navigate to: http://localhost:3000/food-categories

- [ ] Categories list loads
- [ ] Can create new category
- [ ] Can edit existing category
- [ ] Can delete category
- [ ] Success/error messages display

### Food Items
Navigate to: http://localhost:3000/food-items

#### CREATE Food Item (WITHOUT IMAGE)
- [ ] Fill in: Name, Description, Price, Category
- [ ] Leave images empty
- [ ] Click "Add Food Item"
- [ ] **Expected**: Success message appears
- [ ] **Expected**: Item appears in list below
- [ ] **Expected**: No 405 error in console (F12)

#### CREATE Food Item (WITH IMAGE)
- [ ] Fill in: Name, Description, Price, Category
- [ ] Upload 1-2 images (< 50MB each)
- [ ] Click "Add Food Item"
- [ ] **Expected**: Success message appears
- [ ] **Expected**: Item appears with images
- [ ] **Expected**: Images display in item card

#### EDIT Food Item
- [ ] Click "Edit" on existing item
- [ ] Modify name or price
- [ ] Click "Update Food Item"
- [ ] **Expected**: Success message
- [ ] **Expected**: Changes reflected in list

#### DELETE Food Item
- [ ] Click "Delete" on an item
- [ ] Confirm deletion
- [ ] **Expected**: Item removed from list
- [ ] **Expected**: Success message

#### Toggle Availability
- [ ] Click availability toggle
- [ ] **Expected**: Status changes
- [ ] **Expected**: Success message

---

## 🏨 **4. Room Management**

Navigate to: http://localhost:3000/rooms

- [ ] Rooms list loads
- [ ] Can create new room
- [ ] Can upload room images (up to 50MB)
- [ ] Images display correctly in form preview
- [ ] Can edit room details
- [ ] Can change room status (Available/Occupied/Maintenance)
- [ ] Can delete room

---

## 📦 **5. Package Management**

Navigate to: http://localhost:3000/packages

- [ ] Packages list loads
- [ ] Can create new package
- [ ] Can upload package images
- [ ] Can edit package
- [ ] Can delete package
- [ ] Package details display correctly

---

## 📅 **6. Booking Management**

Navigate to: http://localhost:3000/bookings

- [ ] Bookings list loads
- [ ] Can create new booking
- [ ] Date pickers work correctly
- [ ] Room selection works
- [ ] Guest information saves
- [ ] Can view booking details
- [ ] Can update booking status
- [ ] Can check out booking

---

## 💳 **7. Checkout & Payments**

Navigate to: http://localhost:3000/checkout

- [ ] Active bookings list loads
- [ ] Can select booking for checkout
- [ ] Bill calculation correct
- [ ] Food orders included in bill
- [ ] Services included in bill
- [ ] Can process payment
- [ ] Payment modes work (Cash/Card/UPI)

---

## 👥 **8. Employee Management**

Navigate to: http://localhost:3000/employees

- [ ] Employees list loads
- [ ] Can add new employee
- [ ] Can assign roles
- [ ] Can edit employee details
- [ ] Can view attendance
- [ ] Can mark attendance

---

## 📈 **9. Reports**

Navigate to: http://localhost:3000/reports

- [ ] Revenue report loads
- [ ] Date filters work
- [ ] Export to Excel works
- [ ] Charts display correctly
- [ ] Booking report loads
- [ ] Occupancy report loads

---

## 🌐 **10. User Frontend (Public)**

Navigate to: http://localhost:3002

### Homepage
- [ ] Resort name and details display
- [ ] Images load correctly
- [ ] Navigation menu works
- [ ] No "Unable to load resort details" error

### Rooms/Packages
- [ ] Available rooms display
- [ ] Package cards render
- [ ] Images load
- [ ] Prices display correctly

### Booking (if public booking enabled)
- [ ] Booking form loads
- [ ] Date selection works
- [ ] Can submit booking request

---

## 🔍 **11. API Backend Tests**

Open: http://localhost:8010/docs

### Test Endpoints
- [ ] `/health` returns 200 OK
- [ ] `/api/auth/login` works with test credentials
- [ ] `/api/food-items` GET returns items
- [ ] `/api/food-items` POST creates item (test with Swagger)
- [ ] `/api/rooms` GET returns rooms
- [ ] `/api/bookings` GET returns bookings

---

## 🖼️ **12. Image Upload Tests**

### Small Images (< 5MB)
- [ ] Upload works in Food Items
- [ ] Upload works in Rooms
- [ ] Upload works in Packages
- [ ] Images display after upload

### Large Images (5MB - 50MB)
- [ ] Upload works without "size limit" error
- [ ] Upload completes successfully
- [ ] Images display correctly

---

## 🚨 **13. Error Handling**

- [ ] Invalid login shows error message
- [ ] Empty form submissions show validation errors
- [ ] Network errors display user-friendly messages
- [ ] 404 pages handled gracefully
- [ ] API errors don't crash the frontend

---

## 🖥️ **14. Browser Console Checks**

Press F12 and check:
- [ ] No 404 errors for static files
- [ ] No 405 Method Not Allowed errors
- [ ] No CORS errors
- [ ] No JavaScript errors
- [ ] API calls use correct endpoints (no trailing slashes)

---

## 📝 **Bug Report Template**

If you find any bug, document it like this:

```
**Bug #**: [Number]
**Feature**: [e.g., Food Item Creation]
**Steps to Reproduce**:
1. Go to...
2. Click on...
3. Expected...
4. Actual...

**Error Message**: [Copy from console or UI]
**Screenshots**: [If applicable]
**Priority**: [High/Medium/Low]
```

---

## ✅ **After Testing**

Once all tests pass:
1. Document any bugs found above
2. Fix bugs one by one
3. Re-test after each fix
4. When all bugs are fixed → **Ready for Docker**

---

## 🎯 **Critical Tests (Must Pass Before Docker)**

These are the absolute must-pass tests:
- ✅ Login works
- ✅ Dashboard loads
- ✅ Food items can be created (with and without images)
- ✅ Rooms can be created
- ✅ Bookings can be created
- ✅ Images upload and display
- ✅ No 405/500 errors in console

---

**Note**: Test in **Incognito mode** to avoid browser cache issues!

