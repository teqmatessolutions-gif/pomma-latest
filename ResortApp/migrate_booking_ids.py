import sys
from sqlalchemy import create_engine, text
import os

# db_url = os.getenv("DATABASE_URL")
db_url = None
try:
    with open(".env", "r", encoding="utf-8-sig") as f:
        for line in f:
            if line.startswith("DATABASE_URL="):
                db_url = line.strip().split("=", 1)[1]
                break
except Exception as e:
    print(f"Failed to read .env: {e}", file=sys.stderr)

if not db_url:
    print("Error: DATABASE_URL not found in .env", file=sys.stderr)
    sys.exit(1)

engine = create_engine(db_url)

def run_migration():
    with engine.connect() as conn:
        print("Starting migration...")
        
        # 1. Add columns if they don't exist
        print("Adding columns...")
        conn.execute(text("ALTER TABLE food_orders ADD COLUMN IF NOT EXISTS booking_id INTEGER REFERENCES bookings(id);"))
        conn.execute(text("ALTER TABLE food_orders ADD COLUMN IF NOT EXISTS package_booking_id INTEGER REFERENCES package_bookings(id);"))
        
        conn.execute(text("ALTER TABLE assigned_services ADD COLUMN IF NOT EXISTS booking_id INTEGER REFERENCES bookings(id);"))
        conn.execute(text("ALTER TABLE assigned_services ADD COLUMN IF NOT EXISTS package_booking_id INTEGER REFERENCES package_bookings(id);"))
        
        # 2. Backfill FoodOrders
        print("Backfilling FoodOrders...")
        # Backfill regular bookings
        conn.execute(text("""
            UPDATE food_orders fo
            SET booking_id = (
                SELECT b.id FROM bookings b
                JOIN booking_rooms br ON br.booking_id = b.id
                WHERE br.room_id = fo.room_id
                AND CAST(fo.created_at AS DATE) >= b.check_in
                AND CAST(fo.created_at AS DATE) <= b.check_out
                ORDER BY b.check_in DESC LIMIT 1
            )
            WHERE booking_id IS NULL AND package_booking_id IS NULL;
        """))
        
        # Backfill package bookings
        # Note: PackageBookingRoom table connects package bookings to rooms
        conn.execute(text("""
            UPDATE food_orders fo
            SET package_booking_id = (
                SELECT pb.id FROM package_bookings pb
                JOIN package_booking_rooms pbr ON pbr.package_booking_id = pb.id
                WHERE pbr.room_id = fo.room_id
                AND CAST(fo.created_at AS DATE) >= pb.check_in
                AND CAST(fo.created_at AS DATE) <= pb.check_out
                ORDER BY pb.check_in DESC LIMIT 1
            )
            WHERE booking_id IS NULL AND package_booking_id IS NULL;
        """))

        # 3. Backfill AssignedServices
        print("Backfilling AssignedServices...")
        # Backfill regular bookings
        conn.execute(text("""
            UPDATE assigned_services s
            SET booking_id = (
                SELECT b.id FROM bookings b
                JOIN booking_rooms br ON br.booking_id = b.id
                WHERE br.room_id = s.room_id
                AND CAST(s.assigned_at AS DATE) >= b.check_in
                AND CAST(s.assigned_at AS DATE) <= b.check_out
                ORDER BY b.check_in DESC LIMIT 1
            )
            WHERE booking_id IS NULL AND package_booking_id IS NULL;
        """))
        
        # Backfill package bookings
        conn.execute(text("""
            UPDATE assigned_services s
            SET package_booking_id = (
                SELECT pb.id FROM package_bookings pb
                JOIN package_booking_rooms pbr ON pbr.package_booking_id = pb.id
                WHERE pbr.room_id = s.room_id
                AND CAST(s.assigned_at AS DATE) >= pb.check_in
                AND CAST(s.assigned_at AS DATE) <= pb.check_out
                ORDER BY pb.check_in DESC LIMIT 1
            )
            WHERE booking_id IS NULL AND package_booking_id IS NULL;
        """))
        
        conn.commit()
        print("Migration completed successfully.")

if __name__ == "__main__":
    try:
        run_migration()
    except Exception as e:
        print(f"Migration failed: {e}")
        sys.exit(1)
