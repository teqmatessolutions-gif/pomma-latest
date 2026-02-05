
import sys
from app.database import SessionLocal
from app.models.room import Room

def verify_rooms():
    db = SessionLocal()
    try:
        rooms = db.query(Room).all()
        print(f"Total rooms: {len(rooms)}")
        print(f"Room numbers: {[r.number for r in rooms]}")
    finally:
        db.close()

if __name__ == "__main__":
    verify_rooms()
