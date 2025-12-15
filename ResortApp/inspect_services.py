
from app.database import SessionLocal
from app.models.service import AssignedService
from app.models.room import Room
from app.models.booking import Booking
from sqlalchemy.orm import joinedload
import sys

def inspect_services():
    # Redirect output to file
    with open("inspect_services_output.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        
        db = SessionLocal()
        try:
            # Find Room 301
            room = db.query(Room).filter(Room.number == "301").first()
            if not room:
                print("Room 301 not found")
                return

            print(f"Room 301 ID: {room.id}")

            # Find services for this room
            services = db.query(AssignedService).options(
                joinedload(AssignedService.service)
            ).filter(AssignedService.room_id == room.id).all()

            print(f"Found {len(services)} services for Room 301:")
            for s in services:
                service_name = s.service.name if s.service else "UNKNOWN"
                print(f"  Service ID: {s.id}, Name: {service_name}")
                print(f"    Assigned At: {s.assigned_at}")
                print(f"    Booking ID: {s.booking_id}")
                
                # Check if booking exists
                if s.booking_id:
                    booking = db.query(Booking).filter(Booking.id == s.booking_id).first()
                    if booking:
                        print(f"    -> Linked to Booking ID {booking.id} (Guest: {booking.guest_name}, Status: {booking.status})")
                    else:
                        print(f"    -> Linked to INVALID Booking ID {s.booking_id}")
                else:
                    print(f"    -> NO Booking ID Linked (Orphaned?)")
                print("-" * 20)

        finally:
            db.close()

if __name__ == "__main__":
    inspect_services()
