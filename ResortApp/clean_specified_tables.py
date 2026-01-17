from sqlalchemy.orm import Session
from sqlalchemy import text
from dotenv import load_dotenv
import os
import sys

# Add parent directory to path to allow imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

load_dotenv()

from app.database import SessionLocal, engine
from app.models.room import Room, RoomImage
from app.models.booking import Booking, BookingRoom, CheckInDocument
from app.models.Package import PackageBooking, PackageBookingRoom, PackageCheckInDocument
from app.models.checkout import Checkout
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.service import AssignedService

def clean_specified_tables():
    print(f"Connecting to DB...")
    db: Session = SessionLocal()
    
    try:
        print("Starting cleanup of Rooms, Bookings, and Checkouts...")

        # 1. Clear Checkouts (Dependencies of Bookings)
        print("- Deleting Checkouts...")
        db.query(Checkout).delete()

        # 2. Clear Operational Data (Dependencies of Rooms/Bookings)
        # Note: These MUST be deleted to allow Rooms/Bookings to be deleted.
        print("- Deleting Food Order Items (Child of FoodOrder)...")
        db.query(FoodOrderItem).delete()
        
        print("- Deleting Food Orders (Depends on Room/Booking)...")
        db.query(FoodOrder).delete()
        
        print("- Deleting Assigned Services (Depends on Room/Booking)...")
        db.query(AssignedService).delete()

        # 3. Clear Package Bookings (Dependencies of Rooms)
        print("- Deleting Package Check-in Documents...")
        db.query(PackageCheckInDocument).delete()
        
        print("- Deleting Package Booking Rooms...")
        db.query(PackageBookingRoom).delete()
        
        print("- Deleting Package Bookings...")
        db.query(PackageBooking).delete()

        # 4. Clear Standard Bookings (Dependencies of Rooms)
        print("- Deleting Check-in Documents...")
        db.query(CheckInDocument).delete()
        
        print("- Deleting Booking Rooms...")
        db.query(BookingRoom).delete()
        
        print("- Deleting Bookings...")
        db.query(Booking).delete()

        # 5. Clear Rooms
        print("- Deleting Room Images...")
        db.query(RoomImage).delete()
        
        print("- Deleting Rooms...")
        db.query(Room).delete()

        db.commit()
        print("Cleanup completed successfully.")
        print("Preserved: Users, Employees, Food Items, Services, Package Definitions, CMS Content.")
        
    except Exception as e:
        print(f"Critical Error during cleanup: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    clean_specified_tables()
