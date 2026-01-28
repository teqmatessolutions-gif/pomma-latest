
import requests
import sys

BASE_URL = "http://localhost:8000/api"

def check_active_rooms():
    print(f"Checking {BASE_URL}/bookings/active-light...")
    try:
        resp = requests.get(f"{BASE_URL}/bookings/active-light")
        if resp.status_code == 200:
            data = resp.json()
            print(f"Response (first 2 items): {data[:2]}")
            print(f"Total active bookings: {len(data)}")
            
            rooms = []
            for b in data:
                if 'rooms' in b:
                    for r in b['rooms']:
                        rooms.append(r)
            
            print(f"Total derived rooms: {len(rooms)}")
            if rooms:
                print(f"First room: {rooms[0]}")
        else:
            print(f"Error: {resp.status_code} - {resp.text}")

    except Exception as e:
        print(f"Exception: {e}")

    print("-" * 20)
    print(f"Checking {BASE_URL}/rooms?limit=1000...")
    try:
        resp = requests.get(f"{BASE_URL}/rooms?limit=1000")
        if resp.status_code == 200:
            data = resp.json()
            print(f"Total rooms: {len(data)}")
            
            # Check for checked-in or occupied status
            occupied = [r for r in data if r['status'] in ['Occupied', 'Checked-in', 'Checked-In', 'checked-in', 'Booked']]
            print(f"Occupied/Checked-in rooms: {len(occupied)}")
            if occupied:
                 print(f"First occupied room: {occupied[0]}")
                 print(f"Statuses found: {set(r['status'] for r in occupied)}")
            else:
                 print("No rooms with status Occupied/Checked-in found.")
                 print(f"All statuses: {set(r['status'] for r in data)}")
        else:
             print(f"Error: {resp.status_code} - {resp.text}")
    except Exception as e:
        print(f"Exception: {e}")

if __name__ == "__main__":
    check_active_rooms()
