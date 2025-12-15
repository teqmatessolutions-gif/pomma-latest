import urllib.request
import json
import ssl

BASE_URL = "http://localhost:8010/api"

def login(email, password):
    url = f"{BASE_URL}/auth/login"
    data = {"email": email, "password": password}
    req = urllib.request.Request(url, data=json.dumps(data).encode('utf-8'), headers={'Content-Type': 'application/json'})
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    try:
        with urllib.request.urlopen(req, context=ctx) as response:
            if response.status == 200:
                return json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"Login failed: {e.code} {e.reason}")
        print(e.read().decode())
    return None

def reproduce_booking():
    # 1. Login first
    token_data = login("admin@resort.com", "admin123")
    if not token_data:
        print("Could not log in.")
        return
    
    access_token = token_data['access_token']
    
    url = f"{BASE_URL}/bookings"
    # Payload from the user's log
    payload = {
        "room_ids": [2],
        "guest_name": "mathew",
        "guest_mobile": "67890890",
        "guest_email": "mathew@gmail.com",
        "check_in": "2025-12-13",
        "check_out": "2025-12-14",
        "adults": 1,
        "children": 0
    }
    
    req = urllib.request.Request(url, data=json.dumps(payload).encode('utf-8'), headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {access_token}'
    })
    
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    
    try:
        with urllib.request.urlopen(req, context=ctx) as response:
            print(f"Status: {response.status}")
            print(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"Status: {e.code} {e.reason}")
        print("Error Body:")
        print(e.read().decode())
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    reproduce_booking()
