from sqlalchemy.orm import Session
from sqlalchemy import text
from dotenv import load_dotenv
import os

load_dotenv()

from app.database import SessionLocal, engine
# Import all models to ensure they are registered (though we use raw SQL or dynamic deletion usually, importing helps with ORM deletes)
from app.models.booking import Booking, BookingRoom
from app.models.Package import PackageBooking, PackageBookingRoom
from app.models.service import AssignedService
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.expense import Expense
from app.models.checkout import Checkout
from app.models.room import Room
# Additional transactional models
from app.models.payment import Payment
from app.models.employee import Leave, Attendance, WorkingLog
from app.models.suggestion import GuestSuggestion

def wipe_data_keep_auth():
    print(f"Connecting to DB...")
    db: Session = SessionLocal()
    try:
        print("WARNING: This will wipe all transactional data (Bookings, Orders, Payments, etc).")
        print("Users, Roles, Employees, Rooms, Services, Menu, and Packages will be PRESERVED.")
        # Confirmation (commented out for automation, assume user knows what they are running)
        # confirm = input("Are you sure? Type 'yes' to proceed: ")
        # if confirm != 'yes': return

        print("Starting cleanup...")

        # Order matters for foreign keys! Delete children first.

        # 1. Employee Logs
        print("- Deleting Leaves...")
        db.query(Leave).delete()
        print("- Deleting Attendances...")
        db.query(Attendance).delete()
        print("- Deleting Working Logs...")
        db.query(WorkingLog).delete()

        # 2. Payments & Finances
        print("- Deleting Payments...")
        db.query(Payment).delete()
        print("- Deleting Expenses...")
        db.query(Expense).delete()

        # 3. Operations Details
        print("- Deleting Checkouts...")
        # Checkouts might depend on Bookings, but Bookings might depend on Checkouts (circular?). 
        # Usually Checkout -> Booking (FK in Checkout). So delete Checkout first.
        db.query(Checkout).delete()
        
        print("- Deleting Assigned Services...")
        db.query(AssignedService).delete()
        
        print("- Deleting Food Order Items...")
        db.query(FoodOrderItem).delete()
        print("- Deleting Food Orders...")
        db.query(FoodOrder).delete()
        
        print("- Deleting Guest Suggestions...")
        db.query(GuestSuggestion).delete()

        # 4. Booking Details
        print("- Deleting Booking Rooms...")
        db.query(BookingRoom).delete()
        print("- Deleting Package Booking Rooms...")
        db.query(PackageBookingRoom).delete()

        # 5. Core Bookings
        print("- Deleting Bookings...")
        db.query(Booking).delete()
        print("- Deleting Package Bookings...")
        db.query(PackageBooking).delete()
        
        # 6. Reset Master Data Status
        # Reset rooms to Available
        print("- Resetting Room Status to 'Available'...")
        db.query(Room).update({"status": "Available"})

        db.commit()
        print("Cleanup completed successfully.")
        print("Preserved: Users, Roles, Employees, Rooms, Services, Food Items/Categories, Packages.")

    except Exception as e:
        print(f"Error during cleanup: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    wipe_data_keep_auth()
