
import sys
import os

# Add current directory to path so we can import app modules
sys.path.append(os.getcwd())

from sqlalchemy import text
from app.database import SessionLocal


def debug_services():
    db = SessionLocal()
    try:
        # Check for services linked to Booking ID 21
        print("--- Services with booking_id = 21 ---")
        services = db.execute(text("SELECT * FROM assigned_services WHERE booking_id = 21")).fetchall()
        for s in services:
            print(s)
        
        if not services:
            print("No services found for booking_id 21.")

        # Check for services for Room 101 (assuming ID 1, need to verify room ID first)
        # Let's get room ID for '101'
        room = db.execute(text("SELECT id FROM rooms WHERE number = '101'")).fetchone()
        if room:
            room_id = room[0]
            print(f"\n--- Services for Room 101 (ID: {room_id}) ---")
            services_room = db.execute(text(f"SELECT * FROM assigned_services WHERE room_id = {room_id}")).fetchall()
            for s in services_room:
                 print(s)
        else:
            print("Room 101 not found.")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    debug_services()
