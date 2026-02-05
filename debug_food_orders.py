import urllib.request
import json

url = "http://localhost:8000/api/food-orders/?limit=10"

print(f"Fetching {url}")

try:
    with urllib.request.urlopen(url) as response:
        content = response.read().decode()
        data = json.loads(content)
        
        items_list = data.get("items", []) if isinstance(data, dict) else data
        
        print(f"Total Orders: {len(items_list)}")
        
        for order in items_list:
            print(f"--- Order ID: {order.get('id')} ---")
            print(f"Amount: {order.get('amount')}")
            print(f"Items Key: {order.get('items')}")
            if order.get('items'):
                for i in order.get('items'):
                    print(f"  - {i}")
            else:
                print("  NO ITEMS FOUND")
            
except Exception as e:
    print(f"Error: {e}")
