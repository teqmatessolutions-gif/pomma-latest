import urllib.request
import urllib.parse
import json
import ssl
from datetime import datetime

BASE_URL = "http://localhost:8000/api/bill/checkouts"
LOGIN_URL = "http://localhost:8000/api/auth/login"  # Corrected URL

def get_token():
    try:
        # Corrected payload: JSON with 'email', not form-data with 'username'
        payload = json.dumps({"email": "admin@orchid.com", "password": "admin123"}).encode('utf-8')
        req = urllib.request.Request(
            LOGIN_URL, 
            data=payload, 
            method="POST",
            headers={"Content-Type": "application/json"}
        )
        
        with urllib.request.urlopen(req) as response:
            if response.status == 200:
                body = json.loads(response.read().decode())
                return body.get("access_token")
    except Exception as e:
        print(f"Login failed: {e}")
        # Print response body if possible for debugging
        try:
             if hasattr(e, 'read'): print(e.read().decode())
        except: pass
    return None

def test_filter():
    token = get_token()
    if not token:
        print("Cannot process without token.")
        return

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    # 1. Test ALL
    print("--- Testing ALL Records ---")
    try:
        req = urllib.request.Request(BASE_URL, headers=headers)
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            print(f"Total Records: {len(data)}")
            if len(data) > 0:
                print(f"Sample Date 1: {data[0].get('created_at')}")
    except Exception as e:
        print(f"Failed ALL: {e}")

    # 2. Test Filter Last Month (Example: Dec 2023 or Jan 2024 depending on today)
    # User said "filtering last months data". If today is Jan 15 2026 (from metadata), last month is Dec 2025.
    # Metadata: "The current local time is: 2026-01-15T..."
    # So "Last Month" = 2025-12-01 to 2025-12-31.
    
    start_str = "2025-12-01"
    end_str = "2025-12-31" 
    
    # Or try Jan 2026
    # start_str = "2026-01-01"
    # end_str = "2026-01-31"
    
    print(f"\n--- Testing Filter: {start_str} to {end_str} ---")
    
    params = urllib.parse.urlencode({
        "from_date": start_str, 
        "to_date": end_str
    })
    url = f"{BASE_URL}?{params}"
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            print(f"Filtered Records: {len(data)}")
            for c in data:
                 print(f"ID: {c['id']}, Created: {c.get('created_at')}")
    except Exception as e:
        print(f"Failed FILTER: {e}")

if __name__ == "__main__":
    try:
        ssl._create_default_https_context = ssl._create_unverified_context
    except AttributeError:
        pass
    test_filter()
