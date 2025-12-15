from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from datetime import date

def check_room():
    db: Session = SessionLocal()
    try:
        room_id = 2
        check_in = date(2025, 12, 13)
        check_out = date(2025, 12, 14)
        
        print(f"Checking Room {room_id} for {check_in} to {check_out}")
        
        # Check active regular bookings
        conflicting = db.query(Booking).join(BookingRoom).filter(
            BookingRoom.room_id == room_id,
            Booking.status.in_(['booked', 'checked-in']),
            Booking.check_in < check_out,
            Booking.check_out > check_in
        ).all()
        
        print(f"Found {len(conflicting)} conflicting bookings:")
        for b in conflicting:
            print(f" - ID: {b.id}, Guest: {b.guest_name}, Status: {b.status}, Dates: {b.check_in} to {b.check_out}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    check_room()
