
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

def get_bill(token, room_number):
    url = f"{BASE_URL}/bill/{room_number}?checkout_mode=single"
    req = urllib.request.Request(url, method="GET")
    req.add_header("Authorization", f"Bearer {token}")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            print(f"Success: {resp.status}")
            print(resp.read().decode())
    except urllib.error.HTTPError as e:
        print(f"HTTP Error {e.code}: {e.reason}")
        print(e.read().decode())
    except Exception as e:
        print(f"Error: {e}")

def main():
    token = login("admin@resort.com", "admin123")
    if not token:
        sys.exit(1)

    print("Fetching bill for room 101...")
    get_bill(token, "101")

if __name__ == "__main__":
    main()
