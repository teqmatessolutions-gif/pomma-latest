from sqlalchemy import text
from app.database import SessionLocal
import sys

def wipe_data_raw():
    db = SessionLocal()
    print("Connecting to DB...")
    print("WARNING: This will wipe ALL operational data using raw SQL.")
    print("ONLY Users, Roles, and Employees will be PRESERVED.")
    
    # List of tables to clear in order (Child -> Parent)
    # Using raw strings for table names
    tables = [
        # 1. Employee Logs
        "leaves", "attendances", "working_logs",

        # 2. Financials
        "payments", "expenses",

        # 3. Operations
        "checkouts", "assigned_services", 
        "food_order_items", "food_orders", 
        "guest_suggestions", "check_availability",

        # 4. Bookings & Packages (Children)
        "booking_rooms", "checkin_documents", "package_checkin_documents", 
        "package_booking_rooms", "package_bookings", 
        "package_images",

        # 5. Core Bookings & Packages
        "bookings", "packages",

        # 6. Services
        "service_images", "services",

        # 7. Rooms
        "room_images", "rooms",

        # 8. Food Menu
        "food_item_images", "food_items", "food_categories",

        # 9. CMS Content
        "nearby_attraction_banners", "nearby_attractions",
        "plan_weddings", "signature_experiences",
        "resort_info", "reviews", "gallery", "header_banner"
    ]

    try:
        # Try to disable FK checks for this session (Postgres specific, might require superuser)
        # db.execute(text("SET session_replication_role = 'replica';")) 
        
        for table in tables:
            try:
                # Use text() for raw SQL
                # Check if table exists first? Or just try delete.
                # 'TRUNCATE TABLE x CASCADE' is faster but might be too aggressive if permissions issue.
                # DELETE FROM is safer.
                print(f"- Deleting from {table}...")
                db.execute(text(f"DELETE FROM {table}"))
                db.commit() # Commit after each table to ensure progress is saved
            except Exception as table_err:
                print(f"  Warning: Could not delete from {table}. Error: {table_err}")
                db.rollback()

        # Re-enable FK checks
        # db.execute(text("SET session_replication_role = 'origin';"))
        
        print("Cleanup completed successfully.")
        
    except Exception as e:
        print(f"Critical Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    wipe_data_raw()
