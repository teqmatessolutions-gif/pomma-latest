from sqlalchemy.orm import Session
from sqlalchemy import text
from dotenv import load_dotenv
import os

load_dotenv()

from app.database import SessionLocal, engine
# Import all models to ensure they are registered
from app.models.booking import Booking, BookingRoom
from app.models.Package import Package, PackageBooking, PackageBookingRoom, PackageCheckInDocument, PackageImage
from app.models.service import AssignedService, Service, ServiceImage
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.expense import Expense
from app.models.checkout import Checkout
from app.models.room import Room, RoomImage
from app.models.payment import Payment
from app.models.employee import Leave, Attendance, WorkingLog
from app.models.suggestion import GuestSuggestion
from app.models.food_item import FoodItem, FoodItemImage
from app.models.food_category import FoodCategory
# CMS / Frontend Models
from app.models.frontend import (
    HeaderBanner, CheckAvailability, Gallery, Review,
    ResortInfo, SignatureExperience, PlanWedding,
    NearbyAttraction, NearbyAttractionBanner
)

def wipe_data_keep_auth():
    print(f"Connecting to DB...")
    db: Session = SessionLocal()

    def safe_delete(model, name):
        try:
            print(f"- Deleting {name}...")
            db.query(model).delete()
        except Exception as e:
            print(f"  Warning: Could not delete {name}. It might not exist. Error: {e}")
            # db.rollback() # Rollback is needed if an error occurs to reset transaction state
            # But here we are in one big transaction. If one fails, the whole transaction is invalid.
            # So we should probably commit after each successful delete? Or use savepoints?
            # Or simpler: verify table existence.
            # But for now, let's try to proceed. 
            # Actually, standard SQLAlchemy: once exception, transaction is rolled back.
            pass

    # Better approach: 
    # If we catch exception inside the transaction, the transaction is marked for rollback.
    # So we need nested transactions or just let it fail?
    # No, let's try this: 
    
    try:
        print("WARNING: This will wipe ALL operational data (Transactional + CMS + Catalogs).")
        print("ONLY Users, Roles, and Employees will be PRESERVED.")

        print("Starting cleanup...")

        # Order matters for foreign keys! Delete children first.

        models_to_delete = [
            # 1. Employee Logs
            (Leave, "Leaves"),
            (Attendance, "Attendances"),
            (WorkingLog, "Working Logs"),

            # 2. Payments & Finances
            (Payment, "Payments"),
            (Expense, "Expenses"),

            # 3. Operations Details
            (Checkout, "Checkouts"),
            (AssignedService, "Assigned Services"),
            (FoodOrderItem, "Food Order Items"),
            (FoodOrder, "Food Orders"),
            (GuestSuggestion, "Guest Suggestions"),
            (CheckAvailability, "Check Availability Enquiries"),

            # 4. Booking Details & Packages (Children)
            (BookingRoom, "Booking Rooms"),
            (PackageCheckInDocument, "Package Check-in Docs"),
            (PackageBookingRoom, "Package Booking Rooms"),
            (PackageBooking, "Package Bookings"),
            (PackageImage, "Package Images"),

            # 5. Core Bookings & Packages
            (Booking, "Bookings"),
            (Package, "Packages"),
            
            # 6. Services
            (ServiceImage, "Service Images"),
            (Service, "Services"),

            # 7. Rooms
            (RoomImage, "Room Images"),
            (Room, "Rooms"),

            # 8. Food Menu
            (FoodItemImage, "Food Item Images"),
            (FoodItem, "Food Items"),
            (FoodCategory, "Food Categories"),

            # 9. CMS Content
            (NearbyAttractionBanner, "Nearby Attraction Banners"),
            (NearbyAttraction, "Nearby Attractions"),
            (PlanWedding, "Plan Weddings"),
            (SignatureExperience, "Signature Experiences"),
            (ResortInfo, "Resort Info"),
            (Review, "Reviews"),
            (Gallery, "Gallery"),
            (HeaderBanner, "Header Banners"),
        ]

        for model, name in models_to_delete:
            try:
                # Use a nested transaction (savepoint) so failure doesn't abort the whole thing
                with db.begin_nested():
                    print(f"- Deleting {name}...")
                    db.query(model).delete()
            except Exception as e:
                 print(f"  Warning: Could not delete {name}. Error: {e}")

        db.commit()
        print("Cleanup completed successfully.")
        print("Preserved: Users, Roles, Employees.")

    except Exception as e:
        print(f"Critical Error during cleanup: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    wipe_data_keep_auth()
