import sys
import os
import datetime
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# Add current directory to path
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)

# Try importing app modules, if fails, fallback to direct DB connection string if known
try:
    from app.database import SessionLocal
    db = SessionLocal()
    print("Connected via SessionLocal")
except Exception as e:
    print(f"Import failed: {e}")
    # Fallback to direct connection (assuming sqlite or similar based on previous context, 
    # but user mentioned PostgreSQL in history? Actually 'pomma' sounds like local. 
    # Let's check .env if needed, but for now wait for imports)
    print("Cannot connect to DB without app.utils.db")
    sys.exit(1)

today = datetime.date.today()
print(f"\n--- SERVER DATE: {today} ---\n")

print("Checking Bookings relevant for Occupancy...")
# Query bookings that MIGHT be active (overlapping today roughly)
# Logic in dashboard: 
# status in ['booked', 'checked-in', 'checked_in'] (case insensitive now)
# check_in <= today
# check_out > today

try:
    from app.models.booking import Booking, BookingRoom
    from app.models.room import Room
    
    # Get all bookings
    bookings = db.query(Booking).all()
    print(f"Total Bookings in DB: {len(bookings)}")
    
    active_count = 0
    
    for b in bookings:
        # Check constraints
        status_ok = str(b.status).lower() in ['booked', 'checked-in', 'checked_in']
        
        # Ensure dates are dates
        b_in = b.check_in if isinstance(b.check_in, datetime.date) else b.check_in.date()
        b_out = b.check_out if isinstance(b.check_out, datetime.date) else b.check_out.date()
        
        date_ok = (b_in <= today) and (b_out > today)
        
        is_counted = status_ok and date_ok
        
        print(f"Booking {b.id}: '{b.guest_name}' Status='{b.status}' ({status_ok}) In={b_in} Out={b_out} ({date_ok}) -> Counted? {is_counted}")
        
        if is_counted:
            # Check rooms
            linked_rooms = db.query(BookingRoom).filter(BookingRoom.booking_id == b.id).all()
            print(f"  -> Linked Rooms: {[lr.room_id for lr in linked_rooms]}")
            if not linked_rooms:
                print("  !! WARNING: Active booking has NO linked rooms!")
            active_count += len(linked_rooms)

    print(f"\nCalculated Occupied Rooms Count: {active_count}")

except Exception as e:
    print(f"Error inspecting DB: {e}")
