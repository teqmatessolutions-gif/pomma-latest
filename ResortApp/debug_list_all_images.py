import urllib.request
import json
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

try:
    with urllib.request.urlopen("http://localhost:8010/api/rooms/test", context=ctx) as url:
        data = json.loads(url.read().decode())
        if data:
            print(f"Found {len(data)} rooms.")
            for room in data:
                print(f"Room {room['number']}: {room.get('image_url')}")
        else:
            print("No rooms found.")
except Exception as e:
    print(f"Error: {e}")
