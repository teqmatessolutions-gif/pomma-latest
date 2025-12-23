import os
from sqlalchemy.orm import Session
from app.database import SessionLocal, engine, Base
from app.models.room import Room
import random

def fix_images():
    db = SessionLocal()
    try:
        # Get list of actual files in static/rooms
        static_dir = os.path.join("static", "rooms")
        if not os.path.exists(static_dir):
            print(f"Directory {static_dir} does not exist!")
            return

        valid_files = [f for f in os.listdir(static_dir) if f.endswith('.jpg') or f.endswith('.png')]
        if not valid_files:
            print("No valid images found in static/rooms")
            return

        print(f"Found {len(valid_files)} valid images on disk.")
        
        rooms = db.query(Room).all()
        print(f"Checking {len(rooms)} rooms...")

        updated_count = 0
        for room in rooms:
            current_image = room.image_url
            needs_update = False
            
            if not current_image:
                needs_update = True
            else:
                # Check if file exists
                # current_image usually is "static/rooms/filename.jpg"
                # We need to strip "static/rooms/" to check against valid_files list 
                # OR check full path existance
                if current_image.startswith("/"):
                    current_image = current_image[1:]
                
                # Normalize path separators
                fs_path = current_image.replace("/", os.sep)
                if not os.path.exists(fs_path):
                     print(f"Room {room.number}: Image {current_image} NOT found on disk.")
                     needs_update = True
                else:
                    print(f"Room {room.number}: Image {current_image} OK.")

            if needs_update:
                # Assign a random valid image
                new_image_name = random.choice(valid_files)
                new_image_path = f"static/rooms/{new_image_name}"
                room.image_url = new_image_path
                print(f" -> Assigned new image: {new_image_path}")
                updated_count += 1
        
        if updated_count > 0:
            db.commit()
            print(f"Successfully updated back {updated_count} rooms with valid images.")
        else:
            print("No updates needed.")

    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    fix_images()
