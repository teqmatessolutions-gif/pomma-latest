import urllib.request
import json
import ssl

# Create a context that ignores SSL verification
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

try:
    with urllib.request.urlopen("http://localhost:8010/api/rooms/test", context=ctx) as url:
        data = json.loads(url.read().decode())
        if data:
            print(f"Found {len(data)} rooms.")
            room = data[0]
            print("First room keys:", list(room.keys()))
            print("First room image_url:", room.get('image_url'))
            print("First room images:", room.get('images'))
        else:
            print("No rooms found.")
except Exception as e:
    print(f"Error: {e}")
