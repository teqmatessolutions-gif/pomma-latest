
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.room import Room
from sqlalchemy.orm import joinedload

def list_room_bookings():
    db = SessionLocal()
    try:
        # Find Room 301
        room = db.query(Room).filter(Room.number == "301").first()
        if not room:
            print("Room 301 not found")
            return

        print(f"Room 301 ID: {room.id}")

        # Find all bookings for this room
        booking_rooms = db.query(BookingRoom).filter(BookingRoom.room_id == room.id).all()
        booking_ids = [br.booking_id for br in booking_rooms]
        
        bookings = db.query(Booking).filter(Booking.id.in_(booking_ids)).order_by(Booking.id.desc()).all()
        
        print(f"Found {len(bookings)} bookings for Room 301:")
        for b in bookings:
            print(f"  ID: {b.id}")
            print(f"  Guest: {b.guest_name}")
            print(f"  Check-in: {b.check_in}")
            print(f"  Check-out: {b.check_out}")
            print(f"  Status: {b.status}")
            print("-" * 20)
            
    finally:
        db.close()

if __name__ == "__main__":
    list_room_bookings()
