
import urllib.request
import json

def test_endpoint():
    print("Testing /api/reports/room-bookings on port 8010...")
    url = "http://localhost:8010/api/reports/room-bookings?limit=5"
    
    try:
        with urllib.request.urlopen(url) as response:
            data = response.read()
            json_data = json.loads(data)
            
            with open("api_check_result.txt", "w", encoding="utf-8") as f:
                f.write(f"Status: {response.getcode()}\n")
                f.write(f"Got {len(json_data)} records.\n")
                
                for item in json_data:
                    f.write(f"ID: {item.get('id')}, Guest: {item.get('guest_name')}\n")
                    f.write(f"  Total Amount (from API): {item.get('total_amount')}\n")
                    f.write("-" * 20 + "\n")
                    
    except Exception as e:
        with open("api_check_result.txt", "w", encoding="utf-8") as f:
            f.write(f"Error: {e}\n")
        print(f"Error: {e}")

if __name__ == "__main__":
    test_endpoint()
