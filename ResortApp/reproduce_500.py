
import urllib.request
import urllib.error

def reproduce_500():
    url = "http://localhost:8010/api/bookings?skip=0&limit=20&order_by=id&order=desc"
    try:
        with urllib.request.urlopen(url) as response:
            print(f"Status Code: {response.getcode()}")
            print(response.read().decode('utf-8')) # Limit removed
    except urllib.error.HTTPError as e:
        print(f"Status Code: {e.code}")
        print("Response Content:")
        print(e.read().decode('utf-8')) # Limit removed
    except Exception as e:
        print(f"Error accessing API: {e}")

if __name__ == "__main__":
    reproduce_500()
