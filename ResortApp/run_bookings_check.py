
import urllib.request
import json

def test_endpoint():
    print("Testing /api/bookings on port 8010...")
    url = "http://localhost:8010/api/bookings?limit=5"
    
    try:
        with urllib.request.urlopen(url) as response:
            data = response.read()
            json_data = json.loads(data)
            
            # The response is {"total": int, "bookings": list}
            bookings = json_data.get("bookings", [])
            
            with open("bookings_api_check_result.txt", "w", encoding="utf-8") as f:
                f.write(f"Status: {response.getcode()}\n")
                f.write(f"Got {len(bookings)} records.\n")
                
                for item in bookings:
                    f.write(f"ID: {item.get('id')}, Guest: {item.get('guest_name')}\n")
                    f.write(f"  Total Amount (from API): {item.get('total_amount')}\n")
                    f.write("-" * 20 + "\n")
                    
    except Exception as e:
        with open("bookings_api_check_result.txt", "w", encoding="utf-8") as f:
            f.write(f"Error: {e}\n")
        print(f"Error: {e}")

if __name__ == "__main__":
    test_endpoint()
