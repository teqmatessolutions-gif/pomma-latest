import sys
from sqlalchemy import create_engine, text
import os

# Load env safely
db_url = None
try:
    with open(".env", "r", encoding="utf-8-sig") as f:
        for line in f:
            if line.startswith("DATABASE_URL="):
                db_url = line.strip().split("=", 1)[1]
                break
except:
    pass

if not db_url:
    print("Error: DATABASE_URL not found")
    sys.exit(1)

engine = create_engine(db_url)

def run_fix():
    with engine.connect() as conn:
        print("Starting fix...")
        
        # 1. Backfill FoodOrders (Force update all)
        # Added: status check and ID sort for tie-breaking
        print("Updating FoodOrders...")
        conn.execute(text("""
            UPDATE food_orders fo
            SET booking_id = (
                SELECT b.id FROM bookings b
                JOIN booking_rooms br ON br.booking_id = b.id
                WHERE br.room_id = fo.room_id
                AND CAST(fo.created_at AS DATE) >= b.check_in
                AND CAST(fo.created_at AS DATE) <= b.check_out
                AND b.status != 'cancelled'
                ORDER BY b.check_in DESC, b.id DESC LIMIT 1
            )
            WHERE booking_id IS NULL; -- Only fill nulls first to be safe? 
            -- Actually, we WANT to overwrite mismatches.
            -- But overwriting ALL is slow if table is huge. For this resort app it's likely fine.
        """))
        
        # We need to run the update for rows that MIGHT be wrong.
        # Let's just update all rows where a valid booking CAN be found.
        # This query ensures we pick the BEST match.
        conn.execute(text("""
            UPDATE food_orders fo
            SET booking_id = (
                SELECT b.id FROM bookings b
                JOIN booking_rooms br ON br.booking_id = b.id
                WHERE br.room_id = fo.room_id
                AND CAST(fo.created_at AS DATE) >= b.check_in
                AND CAST(fo.created_at AS DATE) <= b.check_out
                AND b.status != 'cancelled'
                ORDER BY b.check_in DESC, b.id DESC LIMIT 1
            ),
            package_booking_id = (
                SELECT pb.id FROM package_bookings pb
                JOIN package_booking_rooms pbr ON pbr.package_booking_id = pb.id
                WHERE pbr.room_id = fo.room_id
                AND CAST(fo.created_at AS DATE) >= pb.check_in
                AND CAST(fo.created_at AS DATE) <= pb.check_out
                AND pb.status != 'cancelled'
                ORDER BY pb.check_in DESC, pb.id DESC LIMIT 1
            )
            -- Apply to all rows to fix correctness
        """))
        
        print("Updating AssignedServices...")
        conn.execute(text("""
            UPDATE assigned_services s
            SET booking_id = (
                SELECT b.id FROM bookings b
                JOIN booking_rooms br ON br.booking_id = b.id
                WHERE br.room_id = s.room_id
                AND CAST(s.assigned_at AS DATE) >= b.check_in
                AND CAST(s.assigned_at AS DATE) <= b.check_out
                AND b.status != 'cancelled'
                ORDER BY b.check_in DESC, b.id DESC LIMIT 1
            ),
            package_booking_id = (
                SELECT pb.id FROM package_bookings pb
                JOIN package_booking_rooms pbr ON pbr.package_booking_id = pb.id
                WHERE pbr.room_id = s.room_id
                AND CAST(s.assigned_at AS DATE) >= pb.check_in
                AND CAST(s.assigned_at AS DATE) <= pb.check_out
                AND pb.status != 'cancelled'
                ORDER BY pb.check_in DESC, pb.id DESC LIMIT 1
            )
        """))
        
        conn.commit()
        print("Fix completed.")

if __name__ == "__main__":
    try:
        run_fix()
    except Exception as e:
        print(f"Fix failed: {e}")
