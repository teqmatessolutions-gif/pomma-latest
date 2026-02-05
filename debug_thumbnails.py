import urllib.request
import json
import urllib.parse 

api_url = "http://localhost:8000/api/food-items?limit=100"
base_media_url = "http://localhost:8000"

print(f"Fetching API...")

try:
    with urllib.request.urlopen(api_url) as response:
        content = response.read().decode()
        data = json.loads(content)
        items = data.get("items", [])
        
        targets = ["julie", "dayon", "fghj"]
        
        for item in items:
            name = item.get("name", "")
            if any(t in name.lower() for t in targets):
                print(f"--- {name} ---")
                for img in item.get("images", []):
                    u = img.get("image_url", "NO_URL")
                    print(f"DB URL raw: {repr(u)}")
                    
                    if u.startswith("http"):
                        full_url = u
                    else:
                        normalized = u if u.startswith("/") else f"/{u}"
                        full_url = f"{base_media_url}{normalized}"
                    
                    # Emulate the JS encodeURI (roughly)
                    # We want to verify if the server returns valid image data
                    path_part = full_url.replace(base_media_url, "")
                    encoded_path = urllib.parse.quote(path_part) # Encodes spaces to %20, slash to %2F?
                    # No, quote encodes / to %2F by default.
                    # JS encodeURI PRESERVES slashes.
                    encoded_path = urllib.parse.quote(path_part, safe="/:") 
                    
                    encoded_url = f"{base_media_url}{encoded_path}"
                    
                    print(f"Testing: {encoded_url}")
                    
                    try:
                        with urllib.request.urlopen(encoded_url) as img_resp:
                            print(f"  Status: {img_resp.getcode()}")
                            print(f"  Type: {img_resp.info().get_content_type()}")
                            print(f"  Length: {img_resp.info().get('Content-Length')}")
                    except Exception as e:
                        print(f"  Error: {e}")

except Exception as e:
    print(f"Global Error: {e}")
