import requests
from datetime import date, timedelta

BASE_URL = "http://localhost:8000"

def create_booking(guest_name, room_id, check_in, check_out):
    print(f"Creating booking for {guest_name}...")
    resp = requests.post(f"{BASE_URL}/api/bookings/guest", json={
        "guest_name": guest_name,
        "guest_mobile": "1234567890",
        "guest_email": f"{guest_name.lower()}@example.com",
        "room_ids": [room_id],
        "check_in": str(check_in),
        "check_out": str(check_out),
        "adults": 1,
        "children": 0
    })
    if resp.status_code != 200:
        print(f"Failed to create booking for {guest_name}: {resp.text}")
        return None
    data = resp.json()
    print(f"Created booking {data['id']}")
    return data['id']

def check_in_booking(booking_id):
    print(f"Checking in booking {booking_id}...")
    # Simulate file upload
    files = {
        'id_card_images': ('id_card.jpg', b'fake_image_content', 'image/jpeg'),
        'guest_photos': ('photo.jpg', b'fake_image_content', 'image/jpeg')
    }
    resp = requests.put(f"{BASE_URL}/api/bookings/{booking_id}/check-in", files=files)
    if resp.status_code == 200:
        print(f"Check-in successful for {booking_id}")
        return True
    else:
        print(f"Check-in failed for {booking_id}: {resp.text}")
        return False

def main():
    today = date.today()
    tomorrow = today + timedelta(days=1)
    day_after = today + timedelta(days=2)
    
    # Ideally, we need a room. Let's assume room 102 exists or find first available room.
    # For repro, hardcoding a likely room ID or fetching one.
    # Fetch rooms
    rooms_resp = requests.get(f"{BASE_URL}/api/rooms")
    if rooms_resp.status_code != 200:
        print("Failed to fetch rooms")
        return
    rooms = rooms_resp.json()
    if not rooms:
        print("No rooms found")
        return
    
    target_room_id = rooms[0]['id']
    print(f"Using room {target_room_id}")

    # Create Booking A (Today -> Tomorrow)
    booking_a_id = create_booking("Guest A", target_room_id, today, tomorrow)
    if not booking_a_id: return

    # Check in Booking A
    if not check_in_booking(booking_a_id): return

    # Create Booking B (Tomorrow -> Day After) 
    # Valid non-overlapping booking
    booking_b_id = create_booking("Guest B", target_room_id, tomorrow, day_after)
    if not booking_b_id: return

    # Attempt to Check in Booking B TODAY (Early check-in)
    # This should FAIL because Room is occupied by A
    print("\nAttempting Early Check-in for Guest B (should fail)...")
    check_in_booking(booking_b_id)
    
    # Clean up (cancel bookings)
    # ... logic to cancel/delete ...

if __name__ == "__main__":
    main()
