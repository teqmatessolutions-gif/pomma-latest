import urllib.request
import json
import sys

def verify():
    url = "http://localhost:8010/api/packages?limit=1"
    try:
        with urllib.request.urlopen(url) as response:
            if response.status == 200:
                data = json.load(response)
                # Handle possible response structures
                packages = []
                if isinstance(data, dict) and "data" in data:
                    packages = data["data"]
                elif isinstance(data, list):
                    packages = data
                
                if packages and len(packages) > 0:
                    pkg = packages[0]
                    # Check for created_at
                    if "created_at" in pkg and pkg["created_at"]:
                        print(f"SUCCESS: Package has created_at: {pkg['created_at']}")
                    else:
                        print(f"FAILURE: Package missing created_at. Keys: {pkg.keys()}")
                else:
                    # If no packages, we can't fully verify, but we can check if schema didn't error
                    print("WARNING: No packages found to verify, but API is reachable.")
            else:
                print(f"Failed to fetch packages: {response.status}")
    except Exception as e:
        print(f"Error connecting to API: {e}")

if __name__ == "__main__":
    verify()
