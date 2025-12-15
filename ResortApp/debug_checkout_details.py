
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

def get_checkout_details(token, checkout_id):
    url = f"{BASE_URL}/bill/checkouts/{checkout_id}/details"
    req = urllib.request.Request(url, method="GET")
    req.add_header("Authorization", f"Bearer {token}")
    
    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            data = json.loads(resp.read())
            print(json.dumps(data, indent=2))
            return data
    except urllib.error.HTTPError as e:
        print(f"HTTP Error {e.code}: {e.reason}")
        print(e.read().decode())
    except Exception as e:
        print(f"Error: {e}")

def main():
    token = login("admin@resort.com", "admin123")
    if not token:
        sys.exit(1)

    print("Fetching details for Checkout ID 15...")
    data = get_checkout_details(token, 15)
    if data:
        services = data.get("services", [])
        print(f"\nServices Count: {len(services)}")
        print(json.dumps(services, indent=2))
        print(f"Service Total: {data.get('service_total')}")

if __name__ == "__main__":
    main()
