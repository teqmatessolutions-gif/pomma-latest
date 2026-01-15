import requests
import os

BASE_URL = "http://localhost:8000/api"

def test_image_update_issue():
    print("Test: Creating room...")
    # 1. Create dummy image
    with open("init.jpg", "wb") as f: f.write(os.urandom(1024))
    
    files = [('images', ('init.jpg', open('init.jpg', 'rb'), 'image/jpeg'))]
    data = {"number": "TST-99", "type": "Test", "price": "100"}
    
    resp = requests.post(f"{BASE_URL}/rooms", data=data, files=files)
    if resp.status_code != 200:
        print(f"Create failed: {resp.text}")
        return
    
    room_id = resp.json()['id']
    base_images = resp.json().get('images', [])
    print(f"Initial Images Count: {len(base_images)}")

    # 2. Update room adding NEW image
    print("\nTest: Updating room with NEW image...")
    with open("new.jpg", "wb") as f: f.write(os.urandom(1024))
    
    files_new = [('images', ('new.jpg', open('new.jpg', 'rb'), 'image/jpeg'))]
    resp = requests.put(f"{BASE_URL}/rooms/{room_id}", data={}, files=files_new)
    
    if resp.status_code != 200:
        print(f"Update failed: {resp.text}")
        return

    updated_room = resp.json()
    new_images = updated_room.get('images', [])
    print(f"Updated Images Count (Response): {len(new_images)}")
    
    # Check if 'new.jpg' is there AND 'init.jpg' is still there
    # Note: filenames in URL will be UUIDs, so we just check count
    if len(new_images) == 2:
        print("SUCCESS: Both images present in response.")
    else:
        print("FAILURE: Expected 2 images, got", len(new_images))
        print("Returned Images:", new_images)

    # 3. Explicit Fetch check
    print("\nTest: Explicit GET fetch...")
    resp = requests.get(f"{BASE_URL}/rooms?limit=1000")
    all_rooms = resp.json()
    our_room = next((r for r in all_rooms if r['id'] == room_id), None)
    
    if our_room:
        print(f"Explicit GET Count: {len(our_room.get('images', []))}")
    
    # Cleanup
    requests.delete(f"{BASE_URL}/rooms/{room_id}")
    os.remove("init.jpg")
    os.remove("new.jpg")

if __name__ == "__main__":
    test_image_update_issue()
