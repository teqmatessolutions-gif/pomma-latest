import os
import sys

sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.room import Room, RoomImage
from app.models.frontend import NearbyAttraction

db = SessionLocal()

def normalize_path(url):
    """Normalize image URL to /uploads/... format"""
    if not url:
        return url
    
    # Remove leading/trailing whitespace
    url = url.strip()
    
    # If it starts with /static/uploads/, replace with /uploads/cms/
    if url.startswith('/static/uploads/'):
        # Assume these are CMS images (attractions, banners, etc.)
        filename = os.path.basename(url)
        return f'/uploads/cms/{filename}'
    
    # If it already starts with /uploads/, keep it
    if url.startswith('/uploads/'):
        return url
    
    # If it starts with uploads/ (no leading slash), add the slash
    if url.startswith('uploads/'):
        return f'/{url}'
    
    # If it's just a filename, assume it's in cms
    if '/' not in url:
        return f'/uploads/cms/{url}'
    
    # Otherwise, add /uploads/ prefix if not present
    if not url.startswith('/'):
        return f'/{url}'
    
    return url

try:
    print("\n=== FIXING ROOM IMAGE URLS ===")
    rooms = db.query(Room).all()
    room_count = 0
    
    for room in rooms:
        changed = False
        
        # Fix main image_url
        if room.image_url:
            old_url = room.image_url
            new_url = normalize_path(old_url)
            if old_url != new_url:
                print(f"Room {room.number}: {old_url} -> {new_url}")
                room.image_url = new_url
                changed = True
        
        # Fix gallery images
        for img in room.images:
            old_url = img.image_url
            new_url = normalize_path(old_url)
            if old_url != new_url:
                print(f"  Gallery: {old_url} -> {new_url}")
                img.image_url = new_url
                changed = True
        
        if changed:
            room_count += 1
    
    print(f"\nFixed {room_count} rooms")
    
    print("\n=== FIXING NEARBY ATTRACTION URLS ===")
    attractions = db.query(NearbyAttraction).all()
    att_count = 0
    
    for att in attractions:
        if att.image_url:
            old_url = att.image_url
            new_url = normalize_path(old_url)
            if old_url != new_url:
                print(f"{att.title}: {old_url} -> {new_url}")
                att.image_url = new_url
                att_count += 1
    
    print(f"\nFixed {att_count} attractions")
    
    # Commit changes
    print("\n=== COMMITTING CHANGES ===")
    db.commit()
    print("✓ All changes committed successfully")

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
    db.rollback()
finally:
    db.close()
