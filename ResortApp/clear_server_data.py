from sqlalchemy import text
from app.database import SessionLocal
import sys

def clear_data():
    db = SessionLocal()
    try:
        # Check if tables exist first to avoid errors if they don't
        # But TRUNCATE usually works fine if tables exist.
        
        tables = [
            # Child tables first (though CASCADE handles it, explicit is cleaner for logging)
            "checkouts",
            "expenses",
            "booking_rooms", 
            "food_order_items",
            "assigned_services", # If exists
            
            # Parent tables
            "food_orders",
            "bookings",
            "food_items",
            "rooms"
        ]
        
        print("Starting cleanup process...")
        
        # We use TRUNCATE ... CASCADE on the parent tables to ensure everything is wiped
        # Order: 
        # 1. checkouts (depends on bookings)
        # 2. expenses (independent mostly, but good to clear)
        # 3. food_orders (depends on rooms, bookings, employees) -> clears food_order_items
        # 4. bookings (depends on users) -> clears booking_rooms, assigned_services
        # 5. rooms (depends on nothing mostly)
        # 6. food_items (referenced by food_order_items)
        
        # Group 1: Transactional Data
        transactional_tables = ["checkouts", "expenses", "food_orders", "bookings"]
        for table in transactional_tables:
            try:
                print(f"Clearing {table}...")
                db.execute(text(f"TRUNCATE TABLE {table} CASCADE;"))
            except Exception as e:
                # If table doesn't exist, ignore
                if "does not exist" in str(e):
                    print(f"Table {table} skipped (does not exist)")
                else:
                    print(f"Error clearing {table}: {e}")

        # Group 2: Master Data (Requested by User)
        master_tables = ["food_items", "food_categories", "services", "rooms"]
        for table in master_tables:
            try:
                print(f"Clearing {table}...")
                db.execute(text(f"TRUNCATE TABLE {table} CASCADE;"))
            except Exception as e:
                if "does not exist" in str(e):
                    print(f"Table {table} skipped (does not exist)")
                else:
                    print(f"Error clearing {table}: {e}")

        db.commit()
        print("\nSUCCESS: Selected tables have been cleared.")
        
    except Exception as e:
        print(f"\nFATAL ERROR: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    print("WARNING: This will DELETE ALL DATA from:")
    print("- Bookings & Checkouts")
    print("- Food Orders & Expenses")
    print("- Rooms & Food Items")
    
    confirm = input("\nType 'yes' to proceed: ")
    if confirm.lower() == "yes":
        clear_data()
    else:
        print("Operation cancelled.")
