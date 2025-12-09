# 🎯 Pre-Docker Action Plan - Fix All Bugs First

**Current Date**: November 24, 2025  
**Strategy**: Test → Fix → Verify → Document → Docker

---

## ⚡ **Phase 1: Critical Features Testing** (Priority: HIGH)

### 1. Food Management System (MUST TEST FIRST)
**Why**: This was the last reported bug

**Test Steps**:
1. Open **Incognito browser**: http://localhost:3000
2. Login: `admin@resort.com` / `admin123`
3. Navigate to Food Items
4. Create food item **WITHOUT image**:
   - Name: Test Item 1
   - Description: Test Description
   - Price: 100
   - Category: Select any
   - Click "Add Food Item"
   - ✅ **PASS**: Success message appears, item in list
   - ❌ **FAIL**: Document error message
5. Create food item **WITH image**:
   - Fill all fields
   - Upload 1 image (< 5MB)
   - Click "Add Food Item"
   - ✅ **PASS**: Item created with image visible
   - ❌ **FAIL**: Document error
6. Test **Edit** and **Delete** operations

**Expected Issues**: None (already fixed)
**If Issues Found**: Check browser console (F12) for 405 errors

---

### 2. Image Upload Functionality
**Why**: Previously had 5MB limit issue

**Test Cases**:
- [ ] Upload image < 5MB → Should work
- [ ] Upload image 5MB - 50MB → Should work (fixed)
- [ ] Upload image > 50MB → Should show error
- [ ] Verify uploaded images display correctly
- [ ] Test in: Food Items, Rooms, Packages

**Common Issues**:
- Images not displaying: Check `getMediaBaseUrl()` in `env.js`
- Upload fails: Check Nginx `client_max_body_size`

---

### 3. Authentication & Dashboard
**Why**: Core functionality

**Test**:
- [ ] Login with correct credentials
- [ ] Login with wrong credentials (should show error)
- [ ] Dashboard loads without blank page
- [ ] All KPIs display correctly
- [ ] Navigation works
- [ ] Logout works

**Known Issues**: None currently

---

## 🔧 **Phase 2: Feature Completeness** (Priority: MEDIUM)

### 4. Room Management
- [ ] Create room with images
- [ ] Edit room details
- [ ] Change room status
- [ ] Delete room
- [ ] View room list

### 5. Booking System
- [ ] Create new booking
- [ ] Check-in booking
- [ ] Extend booking
- [ ] Check-out booking
- [ ] Cancel booking
- [ ] View booking history

### 6. Checkout & Payments
- [ ] View active bookings
- [ ] Generate bill
- [ ] Bill includes: room charges, food orders, services
- [ ] Process payment
- [ ] Print receipt

### 7. Employee Management
- [ ] Add employee
- [ ] Edit employee
- [ ] Mark attendance
- [ ] View attendance report
- [ ] Assign roles

---

## 🌐 **Phase 3: User Frontend** (Priority: MEDIUM)

### 8. Public Website (http://localhost:3002)
- [ ] Homepage loads
- [ ] Resort details display
- [ ] Images load
- [ ] Navigation works
- [ ] Available rooms display
- [ ] Contact form works (if applicable)

**Known Issue**: 
- "Unable to load resort details" → Check if resort data exists in DB

---

## 🔍 **Phase 4: Backend API Health** (Priority: HIGH)

### 9. API Endpoint Tests
Open: http://localhost:8010/docs

Test these endpoints:
- [ ] `GET /health` → Should return 200 OK
- [ ] `POST /api/auth/login` → Should return token
- [ ] `GET /api/food-items` → Should return items list
- [ ] `POST /api/food-items` → Should create item
- [ ] `GET /api/rooms` → Should return rooms
- [ ] `GET /api/bookings` → Should return bookings

**Check for**:
- Correct response codes (200, 201, 404, etc.)
- No 500 Internal Server Errors
- Proper error messages

---

## 📋 **Phase 5: Code Quality Checks** (Priority: LOW)

### 10. Clean Up Debug Code
**Found in codebase**:
- `ResortApp/app/api/packages.py` (lines 481-531): Lots of DEBUG prints
- `ResortApp/app/api/frontend.py` (line 23, 99): Debug logs

**Action**:
```python
# Remove or comment out debug prints like:
print(f"[DEBUG] Status is 'booked' - allowing extension")
# OR wrap in if DEBUG: block
```

### 11. Environment Variables Check
Verify `.env` file has all required variables:
```bash
DATABASE_URL=postgresql://postgres:qwerty123@localhost:5432/pommadb
SECRET_KEY=your-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=43200
```

### 12. Remove Temporary Files
Clean up test/helper scripts:
- `check_users_table.py` ← Can delete after confirming users exist
- `check_resort_columns.py` ← Can delete
- `create_admin_final.py` ← Can delete (admin created)
- `insert_resort_data.py` ← Can delete
- `insert_resort_final.py` ← Can delete (resort data inserted)

---

## 🚨 **Bug Tracking Template**

When you find a bug, document it here:

### Bug #1: [Title]
```
Feature: [e.g., Food Item Creation]
Severity: [Critical/High/Medium/Low]
URL: [e.g., http://localhost:3000/food-items]

Steps to Reproduce:
1. 
2. 
3. 

Expected: 
Actual: 

Error Message: [From console or UI]
Browser Console (F12): [Copy errors]
Backend Logs: [Copy from terminal]

Status: [ ] Not Started | [ ] In Progress | [ ] Fixed | [ ] Verified
```

---

## ✅ **Testing Workflow**

### For Each Feature:
1. **Test** → Follow testing checklist
2. **Document** → If bug found, use template above
3. **Fix** → Modify code
4. **Verify** → Test again (in incognito mode!)
5. **Move on** → Next feature

### After Each Fix:
```bash
# Restart services to apply changes
# Kill all processes
taskkill /F /IM node.exe
Get-Process | Where-Object {$_.ProcessName -eq "python"} | Stop-Process -Force

# Start again
# Backend
cd "D:\resort_oc_10\Resortwithlandingpage\pomma-latest\ResortApp"
.\venv\Scripts\activate
uvicorn main:app --reload --host 0.0.0.0 --port 8010

# Admin Dashboard (new terminal)
cd "D:\resort_oc_10\Resortwithlandingpage\pomma-latest\dasboard"
npm start

# User Frontend (new terminal)
cd "D:\resort_oc_10\Resortwithlandingpage\pomma-latest\userend\userend"
npm start
```

---

## 📊 **Progress Tracker**

### Critical (Must Pass)
- [ ] Food Items - Create (no image)
- [ ] Food Items - Create (with image)
- [ ] Food Items - Edit
- [ ] Food Items - Delete
- [ ] Image Upload (< 5MB)
- [ ] Image Upload (5-50MB)
- [ ] Login/Logout
- [ ] Dashboard loads

### Important (Should Pass)
- [ ] Room Management (full CRUD)
- [ ] Booking Creation
- [ ] Booking Check-in/Check-out
- [ ] Payment Processing
- [ ] User Frontend loads

### Nice to Have (Can fix later)
- [ ] All reports work
- [ ] Excel export works
- [ ] Charts display
- [ ] Mobile responsive

---

## 🎯 **Ready for Docker Criteria**

✅ **You can proceed to Docker when**:
1. All **Critical** items pass
2. At least 80% of **Important** items pass
3. No 500/405 errors in console
4. No blank pages
5. Images upload and display correctly
6. Basic CRUD operations work

---

## 📝 **Next Steps After Testing**

1. **Fill out testing checklist**: `BUG_TESTING_CHECKLIST.md`
2. **Document any bugs found** in this file
3. **Fix bugs one by one**
4. **Re-test after each fix**
5. **When all critical bugs fixed** → Report back
6. **Then** → Proceed to Docker setup

---

## 🚀 **Quick Start Testing Now**

```bash
# 1. Ensure services are running
# Check ports: 8010, 3000, 3002

# 2. Open Incognito browser

# 3. Test CRITICAL items first:
# - Food item creation (with/without image)
# - Image upload
# - Login/Dashboard

# 4. Report any errors immediately
```

---

**Remember**: Test in **Incognito mode** to avoid cache issues! 🎯

