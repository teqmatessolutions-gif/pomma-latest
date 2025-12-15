from sqlalchemy.orm import Session
from sqlalchemy import text
from dotenv import load_dotenv
import os

load_dotenv()

from app.database import SessionLocal, engine
from app.models.booking import Booking, BookingRoom
from app.models.Package import PackageBooking, PackageBookingRoom
from app.models.service import AssignedService
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.expense import Expense
from app.models.checkout import Checkout
from app.models.room import Room

def clean_tables():
    # Force connection string print
    print(f"Connecting to DB...")
    db: Session = SessionLocal()
    try:
        print("Starting cleanup of specified tables...")

        # 1. Checkouts (Dependent on Bookings)
        deleted = db.query(Checkout).delete()
        print(f"Deleted {deleted} Checkouts.")

        # 2. Assigned Services (Dependent on Bookings)
        deleted = db.query(AssignedService).delete()
        print(f"Deleted {deleted} Assigned Services.")

        # 3. Food Order Items (Dependent on Food Orders)
        deleted = db.query(FoodOrderItem).delete()
        print(f"Deleted {deleted} Food Order Items.")

        # 4. Food Orders (Dependent on Bookings)
        deleted = db.query(FoodOrder).delete()
        print(f"Deleted {deleted} Food Orders.")

        # 5. Booking Rooms (Dependent on Bookings)
        deleted = db.query(BookingRoom).delete()
        print(f"Deleted {deleted} Booking Rooms.")

        # 6. Package Booking Rooms (Dependent on Package Bookings)
        deleted = db.query(PackageBookingRoom).delete()
        print(f"Deleted {deleted} Package Booking Rooms.")

        # 7. Bookings
        deleted = db.query(Booking).delete()
        print(f"Deleted {deleted} Bookings.")

        # 8. Package Bookings
        deleted = db.query(PackageBooking).delete()
        print(f"Deleted {deleted} Package Bookings.")

        # 9. Expenses
        deleted = db.query(Expense).delete()
        print(f"Deleted {deleted} Expenses.")

        # 10. Reset Room Status
        updated = db.query(Room).update({"status": "Available"})
        print(f"Reset {updated} Rooms to 'Available' status.")

        db.commit()
        print("Cleanup completed successfully.")

    except Exception as e:
        print(f"Error during cleanup: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    clean_tables()
