import urllib.request
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# One of the files I saw in list_dir
url = "http://localhost:8010/static/rooms/room_b0104faf9dcd4047aa28f03443d25f72.jpg"

try:
    resp = urllib.request.urlopen(url, context=ctx)
    print(f"Status Code: {resp.getcode()}")
    print(f"Content Type: {resp.info().get_content_type()}")
    print(f"Size: {len(resp.read())} bytes")
except Exception as e:
    print(f"Error fetching image: {e}")
