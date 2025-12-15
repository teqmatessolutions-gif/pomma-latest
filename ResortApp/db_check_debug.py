import sys
from sqlalchemy import create_engine, text
import os
import json
from datetime import datetime

# Custom JSON encoder for datetime objects
class DateTimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super(DateTimeEncoder, self).default(obj)

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

def debug_check():
    with engine.connect() as conn:
        print("--- Debugging DB State for Checkout 9 ---")
        
        # 1. Get Checkout 9
        checkout = conn.execute(text("SELECT * FROM checkouts WHERE id = 9")).mappings().first()
        if not checkout:
             print("Checkout 9 not found")
             return
        print(f"Checkout 9: booking_id={checkout.booking_id}, package_booking_id={checkout.package_booking_id}, room_number={checkout.room_number}")
        
        if checkout.package_booking_id:
             pbid = checkout.package_booking_id
             print(f"\n[Comparison] Checkout links to PackageBooking {pbid}")
             
             for pid in [pbid, 3]:
                 pb = conn.execute(text("SELECT id, check_in, check_out FROM package_bookings WHERE id = :id"), {"id": pid}).mappings().first()
                 if pb:
                     print(f"PB{pid}: {pb.check_in} to {pb.check_out}")
                 else:
                     print(f"PB{pid}: Not Found")

        # 3. Get Food Orders for Room 101
        room = conn.execute(text("SELECT * FROM rooms WHERE number = '101'")).mappings().first()
        if room:
             orders = conn.execute(text("SELECT id, created_at, package_booking_id FROM food_orders WHERE room_id = :rid AND id=8"), {"rid": room.id}).mappings().all()
             for o in orders:
                 print(f"FO{o.id}: {o.created_at} (PBID={o.package_booking_id})")
        else:
             print("Room 101 not found")

if __name__ == "__main__":
    try:
        debug_check()
    except Exception as e:
        print(f"Debug failed: {e}")
