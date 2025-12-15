import urllib.request
import json
import urllib.error

# Config
BASE_URL = "http://localhost:8010/api/resort-info"
ITEM_ID = 1  # Assuming ID 1 exists

def test_update():
    url = f"{BASE_URL}/{ITEM_ID}"
    print(f"Testing Update URL: {url}")
    
    # Payload matching frontend
    payload = {
        "name": "Pomma Resort",
        "address": "Munnar, Kerala",
        "gst_no": "GST12345",
        "email": "info@pomma.com",
        "support_email": "support@pomma.com",
        "contact_no": "9876543210",
        "property_location": "Munnar Hills",
        "facebook": "http://facebook.com",
        "instagram": "http://instagram.com",
        "twitter": "http://twitter.com",
        "linkedin": "http://linkedin.com",
        "is_active": True
    }
    
    data_json = json.dumps(payload).encode("utf-8")
    
    headers = {
        "Content-Type": "application/json"
    }
    
    req = urllib.request.Request(url, data=data_json, headers=headers, method="PUT")
    
    try:
        with urllib.request.urlopen(req) as response:
            print("Update Success!")
            print(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"Update Failed: {e.code} {e.reason}")
        print("Error Response Body:")
        print(e.read().decode())
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    test_update()
