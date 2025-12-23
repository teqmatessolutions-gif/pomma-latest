import requests
import json

try:
    response = requests.get("http://localhost:8010/api/rooms/test")
    if response.status_code == 200:
        rooms = response.json()
        if rooms:
            print(f"Found {len(rooms)} rooms.")
            print("First room keys:", rooms[0].keys())
            print("First room image_url:", rooms[0].get('image_url'))
            print("First room images:", rooms[0].get('images'))
        else:
            print("No rooms found.")
    else:
        print(f"Failed to fetch rooms: {response.status_code}")
except Exception as e:
    print(f"Error: {e}")
