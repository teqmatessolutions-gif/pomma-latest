import os
import sys

sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.room import Room, RoomImage
from app.models.frontend import NearbyAttraction

db = SessionLocal()

try:
    print("\n=== ROOMS IN DATABASE ===")
    rooms = db.query(Room).all()
    print(f"Total rooms: {len(rooms)}")
    
    for room in rooms[:5]:  # Show first 5
        print(f"\nRoom #{room.number} - {room.type}")
        print(f"  Main image_url: {room.image_url or 'NULL'}")
        print(f"  Gallery images: {len(room.images)}")
        for idx, img in enumerate(room.images[:3]):  # Show first 3 gallery images
            print(f"    [{idx+1}] {img.image_url}")
    
    if len(rooms) > 5:
        print(f"\n... and {len(rooms) - 5} more rooms")
    
    print("\n=== NEARBY ATTRACTIONS IN DATABASE ===")
    attractions = db.query(NearbyAttraction).all()
    print(f"Total attractions: {len(attractions)}")
    
    for att in attractions[:5]:
        print(f"\nAttraction: {att.title}")
        print(f"  image_url: {att.image_url or 'NULL'}")
        print(f"  is_active: {att.is_active}")
    
    if len(attractions) > 5:
        print(f"\n... and {len(attractions) - 5} more attractions")

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
