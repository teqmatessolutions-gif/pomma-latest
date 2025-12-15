
import urllib.request
import urllib.parse
import urllib.error
import json
import ssl
from datetime import date, timedelta
import sys
import contextlib

BASE_URL = "http://localhost:8010/api"

# Create SSL context that ignores verify
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

def login(email, password):
    url = f"{BASE_URL}/auth/login"
    data = json.dumps({"email": email, "password": password}).encode('utf-8')
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header('Content-Type', 'application/json')
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            if resp.status == 200:
                return json.loads(resp.read())["access_token"]
    except Exception as e:
        print(f"Login failed: {e}")
        return None

def create_whole_property_package(token):
    url = f"{BASE_URL}/packages"
    # Form data for package creation
    data = urllib.parse.urlencode({
        "title": "Test Whole Property",
        "description": "Test Description",
        "price": 50000,
        "booking_type": "whole_property"
    }).encode('ascii')
    
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Authorization", f"Bearer {token}")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            pkg = json.loads(resp.read())
            print(f"Created Whole Property Package ID: {pkg['id']}")
            return pkg['id']
    except Exception as e:
        print(f"Create package failed: {e}")
        if hasattr(e, 'read'): print(e.read())
        return None

def book_single_room(token, room_id, check_in, check_out):
    url = f"{BASE_URL}/bookings"
    payload = {
        "room_ids": [room_id],
        "check_in": str(check_in),
        "check_out": str(check_out),
        "guest_name": "Single Room Guest",
        "guest_email": "single@test.com",
        "guest_mobile": "1234567890",
        "adults": 1,
        "children": 0
    }
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Content-Type", "application/json")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            res_json = json.loads(resp.read())
            print(f"Booked Single Room {room_id} for {check_in} to {check_out}")
            return res_json.get('id')
    except Exception as e:
        print(f"Book single room failed: {e}")
        if hasattr(e, 'read'): print(e.read())
        return None

def book_package(token, package_id, check_in, check_out):
    url = f"{BASE_URL}/packages/book"
    payload = {
        "package_id": package_id,
        "check_in": str(check_in),
        "check_out": str(check_out),
        "guest_name": "Whole Property Guest",
        "guest_email": "whole@test.com",
        "guest_mobile": "0987654321",
        "adults": 2,
        "children": 0,
        "room_ids": []
    }
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Content-Type", "application/json")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            print("FAILED: Whole Property booking SUCCEEDED despite conflict!")
            return False
    except urllib.error.HTTPError as e:
        if e.code == 400:
            error_body = e.read().decode('utf-8')
            print("Successfully BLOCKED Whole Property booking due to conflict.")
            print(f"Error message: {error_body}")
            return True
        else:
            print(f"Unexpected status code: {e.code}")
            print(e.read())
            return False
    except Exception as e:
        print(f"Book package request failed checking: {e}")
        return False

def main():
    admin_email = "admin@resort.com"
    admin_pass = "admin123"
    
    token = login(admin_email, admin_pass)
    if not token:
        print("Login failed, aborting.")
        sys.exit(1)

    # 1. Create Whole Property Package
    pkg_id = create_whole_property_package(token)
    if not pkg_id:
        sys.exit(1)

    # 2. Pick dates
    today = date.today()
    start_date = today + timedelta(days=100) # Far future
    end_date = start_date + timedelta(days=2)

    # 3. Book Single Room (ID 1) by explicitly creating a booking
    # Assuming valid room ID 1. If not, script might fail.
    # We can try to get active rooms or something, but booking will fail with 400 if room invalid.
    room_id = 1
    booking_id = book_single_room(token, room_id, start_date, end_date)
    if not booking_id:
        print("Could not book single room. Ensure Room ID 1 exists.")
        sys.exit(1)

    # 4. Try to book Whole Property
    success = book_package(token, pkg_id, start_date, end_date)

    if success:
        print("\nVERIFICATION PASSED: Whole property booking was correctly restricted.")
    else:
        print("\nVERIFICATION FAILED")

if __name__ == "__main__":
    main()
