import os
import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add current dir to path to find app module
sys.path.append(os.getcwd())

from app.database import Base, SQLALCHEMY_DATABASE_URL as DATABASE_URL
from app.models.room import Room, RoomImage
from app.models.frontend import NearbyAttraction

# Setup DB
# Ensure we use psycopg2 or postgresql driver
print(f"Connecting to DB: {DATABASE_URL}")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

def check_file(url, context):
    if not url:
        print(f"[MISSING URL] {context}: Field is empty")
        return

    # Clean URL to get file path
    # URLs in DB are likely "uploads/..." or "/uploads/..." or full URLs
    
    clean_url = url
    if "://" in clean_url:
        # Strip domain
        clean_url = clean_url.split("/", 3)[-1] # Remove http://domain/
    
    # Remove leading slash
    if clean_url.startswith("/"):
        clean_url = clean_url[1:]
    
    # Remove 'pomma/' prefix if present (from reverse proxy url)
    if clean_url.startswith("pomma/"):
        clean_url = clean_url.replace("pomma/", "", 1)
        
    # Handle legacy 'static/uploads' vs 'uploads'
    if clean_url.startswith("static/uploads/"):
        clean_url = clean_url.replace("static/uploads/", "uploads/")

    # If it doesn't start with uploads, basic sanity check
    if not clean_url.startswith("uploads"):
        # verify if it maps to a mapped static dir
        if not clean_url.startswith("static"):
             # External or weird path
             pass

    file_path = os.path.join(os.getcwd(), clean_url)
    file_path = os.path.abspath(file_path)

    # print(f"[DEBUG] Checking {url} -> {file_path}") 

    if not os.path.exists(file_path):
        # Try finding it in known subdirs if not found directly
        found = False
        for subdir in ["cms", "rooms", "packages", "food_items", "services"]:
            possible_path = os.path.join(os.getcwd(), "uploads", subdir, os.path.basename(clean_url))
            if os.path.exists(possible_path):
                print(f"[PATH MISMATCH] {context}")
                print(f"  Db Url: {url}")
                print(f"  Actual: {possible_path}")
                file_path = possible_path # Update to check size
                found = True
                break
        
        if not found:
            print(f"[FILE NOT FOUND] {context}")
            print(f"  Url: {url}")
            print(f"  Path: {file_path}")
            return

    size = os.path.getsize(file_path)
    if size < 2048:
        print(f"[CORRUPT FILE < 2KB] {context}")
        print(f"  Url: {url}")
        print(f"  Path: {file_path}")
        print(f"  Size: {size} bytes")
    else:
        # print(f"[OK] {context}")
        pass

try:
    print("\n--- Checking Rooms ---")
    rooms = db.query(Room).all()
    for room in rooms:
        if room.image_url:
            check_file(room.image_url, f"Room {room.number} (Main)")
        
        # Check gallery
        for img in room.images:
            check_file(img.image_url, f"Room {room.number} (Gallery ID: {img.id})")

    print("\n--- Checking Nearby Attractions ---")
    attractions = db.query(NearbyAttraction).all()
    for att in attractions:
        check_file(att.image_url, f"Attraction: {att.title}")

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
