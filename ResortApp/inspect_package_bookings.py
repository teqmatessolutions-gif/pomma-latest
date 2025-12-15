
import urllib.request
import urllib.parse
import json
import ssl
import sys

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
           return json.loads(resp.read())["access_token"]
    except Exception as e:
        print(f"Login failed: {e}")
        return None

def verify_package_structure(token):
    # Fetch package bookings
    url = f"{BASE_URL}/packages/bookingsall?skip=0&limit=5"
    req = urllib.request.Request(url, method="GET")
    req.add_header("Authorization", f"Bearer {token}")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            bookings = json.loads(resp.read())
            print(f"Fetched {len(bookings)} package bookings.")
            if len(bookings) > 0:
                print("Sample Package Booking Rooms:")
                # Print just the rooms part to avoid truncation
                print(json.dumps(bookings[0].get("rooms"), indent=2))
                # Also print the first item's keys to be sure
                if bookings[0].get("rooms"):
                    print("Keys in first room item:", bookings[0]["rooms"][0].keys())
    except Exception as e:
        print(f"Error fetching package bookings: {e}")

    # Fetch regular bookings for comparison
    url_reg = f"{BASE_URL}/bookings?limit=1"
    req = urllib.request.Request(url_reg, method="GET")
    req.add_header("Authorization", f"Bearer {token}")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            data = json.loads(resp.read())
            reg_bookings = data.get("bookings", [])
            if len(reg_bookings) > 0:
                print("\nSample Regular Booking Structure:")
                print(json.dumps(reg_bookings[0], indent=2))
    except Exception as e:
        print(f"Error fetching regular bookings: {e}")

def main():
    token = login("admin@resort.com", "admin123")
    if not token:
        sys.exit(1)
    
    verify_package_structure(token)

if __name__ == "__main__":
    main()
