from sqlalchemy.orm import Session
from sqlalchemy import text
from dotenv import load_dotenv
import os
import sys

# Add parent directory to path to allow imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

load_dotenv()

from app.database import SessionLocal, engine
from app.models.room import Room
from app.models.service import AssignedService
from app.models.booking import BookingRoom
from app.models.Package import PackageBookingRoom

def delete_specific_rooms():
    print(f"Connecting to DB...")
    db: Session = SessionLocal()
    
    rooms_to_delete = ['192', '1921', '10000', '191', '301', '106']
    
    print(f"Targeting rooms for deletion: {rooms_to_delete}")
    
    try:
        for room_number in rooms_to_delete:
            room = db.query(Room).filter(Room.number == room_number).first()
            if room:
                print(f"Found Room {room_number} (ID: {room.id}). Deleting...")
                try:
                    # Cascade delete dependencies manually if not set in DB
                    print(f"  - Deleting associated assigned_services...")
                    db.query(AssignedService).filter(AssignedService.room_id == room.id).delete()
                    
                    print(f"  - Deleting associated booking_rooms...")
                    db.query(BookingRoom).filter(BookingRoom.room_id == room.id).delete()

                    print(f"  - Deleting associated package_booking_rooms...")
                    db.query(PackageBookingRoom).filter(PackageBookingRoom.room_id == room.id).delete()
                    
                    db.delete(room)
                    db.commit()
                    print(f"Successfully deleted Room {room_number}")
                except Exception as e:
                    db.rollback()
                    print(f"Failed to delete Room {room_number}. Error: {e}")
            else:
                print(f"Room {room_number} not found.")
                
    except Exception as e:
        print(f"General Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    delete_specific_rooms()
