import urllib.request
import json

url = "http://localhost:8000/api/food-items?limit=20"

print(f"Fetching {url}")

try:
    with urllib.request.urlopen(url) as response:
        content = response.read().decode()
        data = json.loads(content)
        
        print(f"Type: {type(data)}")
        if isinstance(data, dict):
            print(f"Keys: {list(data.keys())}")
            if "items" in data:
                 print(f"Items type: {type(data['items'])}")
                 print(f"Items length: {len(data['items'])}")
        elif isinstance(data, list):
            print(f"List length: {len(data)}")
            
except Exception as e:
    print(f"Error: {e}")
