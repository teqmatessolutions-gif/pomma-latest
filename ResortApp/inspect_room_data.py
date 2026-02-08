from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from app.models.room import Room, RoomImage
from app.database import Base
import os

# Setup database connection
# Assuming the same logic as before to get the session
import sys
sys.path.append(os.getcwd())

try:
    from app.database import SessionLocal
except Exception as e:
    print(f"Error importing SessionLocal: {e}")
    # Fallback
    engine = create_engine("postgresql://postgres:postgrespw@localhost:5432/pomma_resort_db")
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def check_file_exists(path):
    # Normalize path for check
    if path.startswith("/"):
        path = path[1:]
    
    # Try multiple base locations if relative
    candidates = [
        path,
        os.path.join("ResortApp", path),
        os.path.join("ResortApp", "uploads", "rooms", os.path.basename(path))
    ]
    
    for c in candidates:
        if os.path.exists(c):
            return True, c
    return False, None

def inspect_rooms():
    db = SessionLocal()
    try:
        target_rooms = ["101", "102", "104"]
        rooms = db.query(Room).filter(Room.number.in_(target_rooms)).all()
        
        print(f"Found {len(rooms)} rooms.")
        for room in rooms:
            print(f"\n--- Room #{room.number} ({room.type}) ---")
            print(f"ID: {room.id}")
            print(f"Legacy image_url: '{room.image_url}'")
            
            # Check legacy file
            if room.image_url:
                exists, loc = check_file_exists(room.image_url)
                print(f"  Legacy File Exists: {exists} ({loc})")
            
            # Check relation
            try:
                images = room.images
                print(f"Gallery Images Count: {len(images)}")
                for img in images:
                    print(f"  - [ID: {img.id}] '{img.image_url}'")
                    exists, loc = check_file_exists(img.image_url)
                    print(f"    File Exists: {exists} ({loc})")
            except Exception as e:
                print(f"  Error accessing images: {e}")

    except Exception as e:
        print(f"Database error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    inspect_rooms()
