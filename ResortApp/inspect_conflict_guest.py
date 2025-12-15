
from app.database import SessionLocal
from app.models.user import User
from app.models.booking import Booking

def inspect_users_and_booking():
    db = SessionLocal()
    try:
        print("--- Users ---")
        users = db.query(User).all()
        for u in users:
            print(f"ID {u.id}: '{u.name}' (Email: {u.email})")

        print("\n--- Latest Booking ---")
        # Get the most recent booking
        booking = db.query(Booking).order_by(Booking.id.desc()).first()
        if booking:
            print(f"Booking ID: {booking.id}")
            print(f"Guest: {booking.guest_name}")
            print(f"Checked-in By User ID: {booking.user_id}")
            if booking.user:
                 print(f"Checked-in By Name: '{booking.user.name}'")
            else:
                 print("User link is None")
        else:
            print("No bookings found.")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    inspect_users_and_booking()
