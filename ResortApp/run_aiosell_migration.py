import sys
import os
from sqlalchemy import text
# Add the project directory to sys.path to import app modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import engine

def run_migration():
    print("Starting Aiosell Integration Database Migration...")
    
    with engine.connect() as conn:
        # 1. Update 'rooms' table
        print("Updating 'rooms' table...")
        # Rename aiosell_room_code to channel_manager_id
        try:
            conn.execute(text("ALTER TABLE rooms RENAME COLUMN aiosell_room_code TO channel_manager_id;"))
            print("  - Renamed aiosell_room_code to channel_manager_id")
        except Exception as e:
            print(f"  - Skip rename aiosell_room_code: {str(e)}")

        # Add online_inventory
        try:
            conn.execute(text("ALTER TABLE rooms ADD COLUMN online_inventory INTEGER;"))
            print("  - Added online_inventory column")
        except Exception as e:
            print(f"  - Skip add online_inventory: {str(e)}")

        # 2. Update 'rate_plan_mappings' table
        print("Updating 'rate_plan_mappings' table...")
        # Rename aiosell_id to channel_manager_id
        try:
            conn.execute(text("ALTER TABLE rate_plan_mappings RENAME COLUMN aiosell_id TO channel_manager_id;"))
            print("  - Renamed aiosell_id to channel_manager_id")
        except Exception as e:
            print(f"  - Skip rename aiosell_id: {str(e)}")

        # Add price_offset
        try:
            conn.execute(text("ALTER TABLE rate_plan_mappings ADD COLUMN price_offset FLOAT DEFAULT 0.0;"))
            print("  - Added price_offset column")
        except Exception as e:
            print(f"  - Skip add price_offset: {str(e)}")

        # 3. Update 'bookings' table
        print("Updating 'bookings' table...")
        # Rename channel to source
        try:
            conn.execute(text("ALTER TABLE bookings RENAME COLUMN channel TO source;"))
            print("  - Renamed channel to source")
        except Exception as e:
            print(f"  - Skip rename channel: {str(e)}")

        # Rename external_booking_id to external_id
        try:
            conn.execute(text("ALTER TABLE bookings RENAME COLUMN external_booking_id TO external_id;"))
            print("  - Renamed external_booking_id to external_id")
        except Exception as e:
            print(f"  - Skip rename external_booking_id: {str(e)}")

        conn.commit()
    
    print("Migration completed successfully.")

if __name__ == "__main__":
    run_migration()
