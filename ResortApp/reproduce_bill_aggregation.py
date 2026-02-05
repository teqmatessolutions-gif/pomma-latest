import requests
import time
from datetime import date, timedelta

BASE_URL = "http://localhost:8000"

# Helper to clear previous data if needed (skipped for now, assuming clean state or unique room)
# ...

def create_booking(guest_name, room_id):
    print(f"Creating booking for {guest_name} in room {room_id}...")
    today = date.today()
    tomorrow = today + timedelta(days=1)
    
    resp = requests.post(f"{BASE_URL}/api/bookings/guest", json={
        "guest_name": guest_name,
        "guest_mobile": "9876543210",
        "guest_email": "test@example.com",
        "room_ids": [room_id],
        "check_in": str(today),
        "check_out": str(tomorrow),
        "adults": 1,
        "children": 0
    })
    if resp.status_code != 200:
        print(f"Failed to create booking: {resp.text}")
        return None
    data = resp.json()
    print(f"Created booking {data['id']}")
    return data['id']

def add_food_order(room_id, item_id, quantity=1):
    print(f"Adding food order: Item {item_id} x {quantity} to Room {room_id}")
    resp = requests.post(f"{BASE_URL}/api/food-orders/", json={
        "room_id": room_id,
        "items": [
            {"food_item_id": item_id, "quantity": quantity}
        ]
    })
    if resp.status_code != 200:
        print(f"Failed to add food order: {resp.text}")
        return False
    return True

def check_in_booking(booking_id):
    # Skip actual check-in logic for now as billing might work on 'booked' status too for testing, 
    # OR we need to simulate checkin. 
    # Based on previous context, billing works for 'booked' if date matches.
    pass

def get_bill(room_number):
    print(f"Fetching bill for room {room_number}...")
    resp = requests.get(f"{BASE_URL}/api/bill/{room_number}")
    if resp.status_code != 200:
        print(f"Failed to get bill: {resp.text}")
        return None
    return resp.json()

def main():
    # 1. Setup
    # Get a room
    rooms_resp = requests.get(f"{BASE_URL}/api/rooms")
    rooms = rooms_resp.json()
    target_room = next((r for r in rooms if r['status'] == 'Available'), None)
    if not target_room:
        print("No available rooms found.")
        return

    # Get a food item
    food_resp = requests.get(f"{BASE_URL}/api/food-items/")
    food_items = food_resp.json()
    if not food_items:
        print("No food items found.")
        return
    food_item = food_items[0]
    
    booking_id = create_booking("Aggregation Test Guest", target_room['id'])
    if not booking_id: return

    # 2. Create Duplicate Orders
    # Order the same item twice
    add_food_order(target_room['id'], food_item['id'], 1)
    add_food_order(target_room['id'], food_item['id'], 2) # Total should be 3

    # 3. Fetch Bill and Verify Aggregation
    bill = get_bill(target_room['number'])
    if not bill: return

    print("\n--- Bill Summary ---")
    food_items = bill['charges']['food_items']
    print(f"Food Items Found: {len(food_items)}")
    for item in food_items:
        print(f" - {item['item_name']}: Quantity {item['quantity']}, Amount {item['amount']}")
    
    # Verification Logic
    # We expect 1 item with quantity 3 if aggregated.
    # Currently (before fix), we expect 2 items (qty 1 and qty 2).
    
    item_names = [i['item_name'] for i in food_items]
    if len(item_names) != len(set(item_names)):
         print("\n[FAIL] Duplicates found! Items are NOT aggregated.")
    else:
         print("\n[SUCCESS] Items are aggregated.")

if __name__ == "__main__":
    main()
