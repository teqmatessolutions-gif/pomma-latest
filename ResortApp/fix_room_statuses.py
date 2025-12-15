import sys
import os
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)

try:
    from app.database import SessionLocal
    from app.utils.room_status import update_room_statuses
    
    print("Connecting to DB...")
    db = SessionLocal()
    
    print("Running room status update (using FIXED code from disk)...")
    
    # Custom debug loop to see what's happening
    from app.models.room import Room
    from app.models.booking import Booking, BookingRoom
    import datetime
    
    today = datetime.date.today()
    rooms = db.query(Room).all()
    print(f"Total Rooms: {len(rooms)}")
    
    for r in rooms:
        print(f"Checking Room {r.number} (ID: {r.id}, Status: {r.status})")
        # Re-run query manually to debug
        bookings = db.query(Booking).join(BookingRoom).filter(
            BookingRoom.room_id == r.id,
            Booking.check_in <= today,
            Booking.check_out > today
        ).all()
        for b in bookings:
            print(f"  - Found Active-time Booking {b.id}: Status='{b.status}' CheckIn={b.check_in} CheckOut={b.check_out}")
            if b.status in ['booked', 'checked-in', 'checked_in', 'Booked', 'Checked-in', 'Checked-In', 'Checked_in', 'Checked_In']:
                 print("    -> MATCHES Status List!")
            else:
                 print(f"    -> Status '{b.status}' NOT in list!")
                 
    count = update_room_statuses(db)
    
    print(f"Update complete. Rooms updated/checked: {count}")
    
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
