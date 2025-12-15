from app.database import SessionLocal
from app.models.room import Room
from app.models.booking import Booking, BookingRoom
from datetime import date
from sqlalchemy import or_

def check_rooms_and_bookings():
    db = SessionLocal()
    try:
        rooms = db.query(Room).all()
        print(f"Total Rooms: {len(rooms)}")
        for room in rooms:
            print(f"Room {room.number} (ID: {room.id}): Status='{room.status}'")
            
        print("\n--- Active Bookings ---")
        today = date.today()
        bookings = db.query(Booking).filter(
            or_(
                Booking.status.ilike("%checked-in%"),
                Booking.status.ilike("%booked%")
            )
        ).all()
        
        for b in bookings:
            print(f"Booking {b.id}: Status='{b.status}', CheckIn={b.check_in}, CheckOut={b.check_out}")
            for br in b.booking_rooms:
                print(f"  -> Linked to Room ID: {br.room_id}")

        print("\n--- Running Update Statuses ---")
        try:
            from app.utils.room_status import update_room_statuses
            update_room_statuses(db)
            db.commit() # Ensure changes are committed if update_room_statuses doesn't do it
            print("Update function ran.")
        except Exception as e:
            print(f"Error running update: {e}")

        print("\n--- Rooms After Update ---")
        rooms_after = db.query(Room).all()
        for room in rooms_after:
            print(f"Room {room.number}: Status='{room.status}'")

    finally:
        db.close()

if __name__ == "__main__":
    check_rooms_and_bookings()
