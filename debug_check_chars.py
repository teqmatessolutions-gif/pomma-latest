import urllib.request
import json

url = "http://localhost:8000/api/food-items?limit=100"

print(f"Fetching {url}")

try:
    with urllib.request.urlopen(url) as response:
        content = response.read().decode()
        data = json.loads(content)
        items = data.get("items", [])
        
        print(f"Total Items: {len(items)}")
        
        for item in items:
            name = item.get("name", "Unknown")
            print(f"--- Item: {name} ---")
            for img in item.get("images", []):
                u = img.get("image_url", "")
                print(f"  URL: {repr(u)}")
                # Hex debug for entire string
                print("  Hex: " + " ".join("{:02x}".format(ord(c)) for c in u))

except Exception as e:
    print(f"Error: {e}")
