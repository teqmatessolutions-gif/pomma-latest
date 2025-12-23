import urllib.request
import json
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

try:
    with urllib.request.urlopen("http://localhost:8010/api/packages/", context=ctx) as url:
        data = json.loads(url.read().decode())
        print(f"Found {len(data)} packages.")
        if data:
            print("First package images:", data[0].get('images'))
except Exception as e:
    print(f"Error: {e}")
