import urllib.request
import urllib.parse
import json
import ssl

BASE_URL = "http://localhost:8010/api"

endpoints = [
    "/reports/checkin-by-employee",
    "/reports/service-charges",
    "/reports/food-orders",
    "/reports/expenses",
    "/expenses",
    "/food-orders", 
    "/bookings",
    "/employees",
    "/packages/bookingsall"
]

def login():
    try:
        url = f"{BASE_URL}/auth/login"
        data = json.dumps({"email": "admin@orchid.com", "password": "admin123"}).encode('utf-8')
        req = urllib.request.Request(url, data=data, method="POST")
        req.add_header('Content-Type', 'application/json')
        with urllib.request.urlopen(req) as resp:
            if resp.status == 200:
                resp_body = resp.read()
                return json.loads(resp_body)["access_token"]
            print(f"Login failed: {resp.status}")
    except urllib.error.HTTPError as e:
        print(f"Login failed: {e.code} {e.read()}")
    except Exception as e:
        print(f"Login error: {e}")
    return None

token = login()
headers = {}
if token:
    headers["Authorization"] = f"Bearer {token}"

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

with open("verification_result.txt", "w") as f:
    f.write(f"Testing endpoints with token: {token is not None}\n")
    for ep in endpoints:
        try:
            url = f"{BASE_URL}{ep}"
            req = urllib.request.Request(url, headers=headers)
            try:
                with urllib.request.urlopen(req, context=ctx) as resp:
                    f.write(f"GET {ep}: {resp.status}\n")
            except urllib.error.HTTPError as e:
                f.write(f"GET {ep}: {e.code}\n")
                f.write(f"Error response: {e.read()[:200]}\n")
        except Exception as e:
            f.write(f"GET {ep} failed: {e}\n")
