from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.room import Room
from sqlalchemy import text

db = SessionLocal()

print("--- Checking Bookings ---")
bookings = db.query(Booking).all()
if not bookings:
    print("No bookings found.")
else:
    for b in bookings:
        print(f"Booking ID: {b.id}, Guest: {b.guest_name}, Status: {b.status}, Check-in: {b.check_in}, Check-out: {b.check_out}")
        for br in b.booking_rooms:
            print(f"  - Room ID: {br.room_id} (Room Number: {br.room.number if br.room else 'Unknown'})")

print("\n--- Checking Room Statuses ---")
rooms = db.query(Room).all()
for r in rooms:
    print(f"Room {r.number}: Status='{r.status}'")

db.close()
