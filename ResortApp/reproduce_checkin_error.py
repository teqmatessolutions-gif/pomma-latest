import requests
import os

# Create dummy images if they don't exist
with open("test_id.jpg", "wb") as f:
    f.write(b"dummy image content")
with open("test_guest.jpg", "wb") as f:
    f.write(b"dummy guest content")

url = "http://localhost:8000/api/bookings/BK-000041/check-in"

files = [
    ('id_card_images', ('test_id.jpg', open('test_id.jpg', 'rb'), 'image/jpeg')),
    ('id_card_images', ('test_id.jpg', open('test_id.jpg', 'rb'), 'image/jpeg')),
    ('guest_photos', ('test_guest.jpg', open('test_guest.jpg', 'rb'), 'image/jpeg')),
    ('guest_photos', ('test_guest.jpg', open('test_guest.jpg', 'rb'), 'image/jpeg'))
]

# Login to get token
login_url = "http://localhost:8000/api/auth/login"
print(f"Logging in to {login_url}...")
try:
    login_resp = requests.post(login_url, json={"email": "admin@orchid.com", "password": "admin123"})
    if login_resp.status_code != 200:
        print(f"Login failed: {login_resp.status_code} {login_resp.text}")
        exit(1)
    token = login_resp.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
except Exception as e:
    print(f"Login error: {e}")
    exit(1)

print(f"Sending request to {url}...")
try:
    response = requests.put(url, files=files, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response Body: {response.text}")
except Exception as e:
    print(f"Error: {e}")

# Clean up
try:
    os.remove("test_id.jpg")
    os.remove("test_guest.jpg")
except:
    pass
