import os
import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.room import Room, RoomImage

# Setup database connection
# Assuming to run this from the root of the project on server
sys.path.append(os.getcwd())

try:
    from app.database import SessionLocal
    print("Successfully imported SessionLocal from app.database")
except ImportError:
    print("Could not import SessionLocal. Using default connection string.")
    # You might need to adjust this connection string for your production server
    # often read from .env
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

def audit_images():
    print("Starting Server Image Audit...")
    print(f"Current Working Directory: {os.getcwd()}")
    
    db = SessionLocal()
    try:
        rooms = db.query(Room).all()
        print(f"Found {len(rooms)} rooms in database.")
        
        missing_count = 0
        total_images = 0
        
        for room in rooms:
            print(f"\nScanning Room #{room.number} (ID: {room.id}) - {room.type}")
            
            # 1. Check Primary Legacy Image
            if room.image_url:
                exists, path = check_file(room.image_url)
                status = "OK" if exists else "MISSING"
                if not exists: missing_count += 1
                print(f"  [Legacy] {status}: {room.image_url}")
                if not exists: print(f"    -> Looked for: {path}")
            else:
                print("  [Legacy] None set")

            # 2. Check Gallery Images
            images = room.images # This might be lazy loaded, accessing it triggers query
            if images:
                print(f"  Found {len(images)} gallery images:")
                for img in images:
                    total_images += 1
                    exists, path = check_file(img.image_url)
                    status = "OK" if exists else "MISSING"
                    if not exists: missing_count += 1
                    print(f"    - [ID: {img.id}] {status}: {img.image_url}")
                    if not exists: print(f"      -> Looked for: {path}")
            else:
                print("  No gallery images.")

        print("\n" + "="*30)
        print("AUDIT SUMMARY")
        print("="*30)
        print(f"Total Rooms: {len(rooms)}")
        print(f"Total Images Checked: {total_images}")
        print(f"Missing Files: {missing_count}")
        
        if missing_count > 0:
            print("\nrecommendation: Re-upload the missing images via the admin panel.")
        else:
            print("\nAll files found! If images are still not showing, check:")
            print("1. Browser Console for 403 Forbidden errors (Nginx permissions)")
            print("2. Browser Console for 404 Not Found (URL construction issues)")
            print("3. Nginx serving paths ('/uploads' alias)")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    audit_images()
