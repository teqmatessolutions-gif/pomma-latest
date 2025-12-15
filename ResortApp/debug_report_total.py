
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.room import Room
from sqlalchemy.orm import joinedload
import sys

def debug_report_totals():
    with open("debug_report_output.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        db = SessionLocal()
        try:
            # Emulate get_all_room_bookings logic
            # Original code does NOT have joinedload
            bookings = db.query(Booking).order_by(Booking.id.desc()).limit(5).all()
            
            print(f"Fetched {len(bookings)} bookings.")
            
            for b in bookings:
                print(f"Booking ID: {b.id}, Guest: {b.guest_name}")
                
                # Check date difference
                stay_days = max(1, (b.check_out - b.check_in).days)
                print(f"  Dates: {b.check_in} to {b.check_out} ({stay_days} days)")
                
                # Inspect rooms
                total_price = 0
                room_count = 0
                
                if not b.booking_rooms:
                    print("  NO BookingRooms found linked to this booking!")

                # Accessing booking_rooms (lazy load if not eager loaded)
                for br in b.booking_rooms:
                    if br.room:
                        print(f"    Room {br.room.number} (ID: {br.room.id}), Price: {br.room.price}")
                        total_price += (br.room.price or 0)
                        room_count += 1
                    else:
                        print(f"    BookingRoom {br.id} has NO Room linked! (room_id: {br.room_id})")
                
                calculated_total = total_price * stay_days
                print(f"  Calculated Total: {calculated_total}")
                print(f"  DB Stored Total (if any): {b.total_amount}")
                print("-" * 20)
                
        finally:
            db.close()

if __name__ == "__main__":
    debug_report_totals()
