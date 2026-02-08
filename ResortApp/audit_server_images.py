import os
import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.room import Room, RoomImage
from app.models.frontend import (
    HeaderBanner, Gallery, SignatureExperience, PlanWedding, 
    NearbyAttraction, NearbyAttractionBanner
)

# Setup database connection
sys.path.append(os.getcwd())

try:
    from app.database import SessionLocal
    print("Successfully imported SessionLocal from app.database")
except ImportError:
    print("Could not import SessionLocal. Using default connection string.")
    from dotenv import load_dotenv
    load_dotenv()
    
    db_url = os.getenv("DATABASE_URL", "postgresql://postgres:postgrespw@localhost:5432/pomma_resort_db")
    engine = create_engine(db_url)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def check_file(path, base_dirs=["", "ResortApp", "static"]):
    """Checks if a file exists in typical upload locations."""
    if not path:
        return False, "No Path"
    
    # Clean path
    clean_path = path.replace("\\", "/").strip()
    if clean_path.startswith("/"):
        clean_path = clean_path[1:]

    # Try exact match first
    if os.path.exists(clean_path):
        return True, os.path.abspath(clean_path)

    # Try combinations
    for base in base_dirs:
        candidate = os.path.join(base, clean_path)
        if os.path.exists(candidate):
            return True, os.path.abspath(candidate)
            
    return False, clean_path

def get_thumb_path(path):
    if not path: return None
    clean_path = path.replace("\\", "/").strip()
    if clean_path.lower().endswith(('.jpg', '.jpeg', '.png', '.webp')):
        parts = clean_path.rsplit('.', 1)
        return f"{parts[0]}_thumb.jpg"
    return None

def audit_images():
    print("Starting Server Image Audit (Rooms & CMS)...")
    print(f"Current Working Directory: {os.getcwd()}")
    
    db = SessionLocal()
    try:
        # --- ROOMS ---
        rooms = db.query(Room).all()
        print(f"\n--- ROOMS ({len(rooms)}) ---")
        for room in rooms:
            if room.image_url:
                exists, _ = check_file(room.image_url)
                thumb_path = get_thumb_path(room.image_url)
                thumb_exists, _ = check_file(thumb_path) if thumb_path else (False, None)
                print(f"Room #{room.number} Legacy: {'[OK]' if exists else '[MISSING]'} | Thumb: {'[OK]' if thumb_exists else '[MISSING]'}")

            if room.images:
                for img in room.images:
                    exists, _ = check_file(img.image_url)
                    thumb_path = get_thumb_path(img.image_url)
                    thumb_exists, _ = check_file(thumb_path) if thumb_path else (False, None)
                    print(f"Room #{room.number} Gallery: {'[OK]' if exists else '[MISSING]'} | Thumb: {'[OK]' if thumb_exists else '[MISSING]'}")

        # --- CMS SECTIONS ---
        cms_models = [
            (HeaderBanner, "Header Banners"),
            (Gallery, "Gallery"),
            (SignatureExperience, "Signature Experiences"),
            (PlanWedding, "Wedding Plans"),
            (NearbyAttraction, "Nearby Attractions"),
            (NearbyAttractionBanner, "Attraction Banners")
        ]

        print("\n--- CMS CONTENT ---")
        for model, label in cms_models:
            items = db.query(model).all()
            print(f"\nChecking {label} ({len(items)} items)...")
            count_ok = 0
            count_missing = 0
            count_thumb_missing = 0
            
            for item in items:
                display_name = getattr(item, 'title', getattr(item, 'name', f"ID {item.id}"))
                if not item.image_url:
                    continue
                    
                exists, path = check_file(item.image_url)
                thumb_path = get_thumb_path(item.image_url)
                thumb_exists, _ = check_file(thumb_path) if thumb_path else (False, None)
                
                status_parts = []
                if not exists:
                    status_parts.append("FILE MISSING")
                    count_missing += 1
                else:
                    count_ok += 1
                    
                if not thumb_exists:
                    status_parts.append("THUMBNAIL MISSING")
                    count_thumb_missing += 1
                    
                if status_parts:
                    print(f"  [!] {display_name}: {', '.join(status_parts)}")
                    print(f"      Path: {item.image_url}")
                
            print(f"  Summary: {count_ok} OK, {count_missing} Missing Files, {count_thumb_missing} Missing Thumbnails")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    audit_images()
