
import urllib.request
import json
import ssl
from app.database import SessionLocal
from app.models.checkout import Checkout
from app.models.service import AssignedService
from app.models.booking import Booking

def debug_checkout_15():
    print("--- Debugging Checkout 15 ---")
    
    # 1. Check DB directly
    db = SessionLocal()
    try:
        checkout = db.query(Checkout).filter(Checkout.id == 15).first()
        if not checkout:
            print("Checkout 15 not found in DB.")
            return
            
        print(f"Checkout 15 Found: Guest={checkout.guest_name}, Total={checkout.grand_total}")
        print(f"Service Total (Stored): {checkout.service_total}")
        print(f"Checkout Date (Raw): {checkout.checkout_date}")
        print(f"Booking ID: {checkout.booking_id}")
        
        if checkout.booking:
            print(f"Booking: Check-in={checkout.booking.check_in}, Check-out={checkout.booking.check_out}")
        
        # 2. Check Services for this room/booking
        print("\n--- Searching for Linked Services ---")
        query = db.query(AssignedService).filter(
            AssignedService.booking_id == checkout.booking_id if checkout.booking_id else False
        )
        services = query.all()
        print(f"Found {len(services)} services linked to Booking ID {checkout.booking_id}:")
        for s in services:
            print(f" - ID {s.id}: {s.service.name if s.service else 'Unk'} ({s.assigned_at}) Status:{s.status}")
            
        # 3. Check Potential Orphans (Room 101?)
        if checkout.room_number:
            print(f"\n--- Searching for Orphans in Room {checkout.room_number} ---")
            # Assuming room 101 is ID 1
            query = db.query(AssignedService).filter(
                AssignedService.room_id == 1,
                AssignedService.booking_id == None
            )
            orphans = query.all()
            for o in orphans:
                print(f" - ID {o.id}: {o.assigned_at} (Billed:{o.billing_status})")

    except Exception as e:
         print(f"DB Error: {e}")
    finally:
         db.close()

if __name__ == "__main__":
    import sys
    # Redirect stdout to a file with UTF-8 encoding
    with open("debug_out.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        debug_checkout_15()
        sys.stdout = sys.__stdout__
    
    # Print a tiny confirmation to console so command_status doesn't look empty
    print("Debug completed. Check debug_out.txt")
