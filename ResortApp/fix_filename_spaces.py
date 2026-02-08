"""
Fix filename spaces in all upload directories
Renames files with spaces to use underscores and updates database references
"""
import os
import sys
sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.Package import PackageImage
from app.models.room import Room, RoomImage
from app.models.frontend import NearbyAttraction
from app.models.service import ServiceImage
from app.models.food_item import FoodItemImage
from sqlalchemy.orm import Session

def rename_file_safe(old_path, new_path):
    """Safely rename a file, checking if target doesn't already exist"""
    if os.path.exists(old_path):
        if os.path.exists(new_path):
            print(f"  WARNING: Target already exists: {new_path}")
            return False
        os.rename(old_path, new_path)
        return True
    return False

def fix_spaces_in_path(url_path):
    """Replace spaces with underscores in the filename part of a path"""
    if not url_path or ' ' not in url_path:
        return url_path
    
    # Split path into directory and filename
    parts = url_path.rsplit('/', 1)
    if len(parts) == 2:
        directory, filename = parts
        new_filename = filename.replace(' ', '_')
        return f"{directory}/{new_filename}"
    else:
        # No directory, just filename
        return url_path.replace(' ', '_')

def process_directory(directory_path):
    """Process all files in a directory, renaming those with spaces"""
    if not os.path.exists(directory_path):
        print(f"Directory not found: {directory_path}")
        return []
    
    changes = []
    for filename in os.listdir(directory_path):
        if ' ' in filename:
            old_path = os.path.join(directory_path, filename)
            new_filename = filename.replace(' ', '_')
            new_path = os.path.join(directory_path, new_filename)
            
            if rename_file_safe(old_path, new_path):
                changes.append((filename, new_filename))
                print(f"  Renamed: {filename} -> {new_filename}")
    
    return changes

def main():
    db = SessionLocal()
    
    try:
        print("\n=== FIXING FILENAME SPACES ===\n")
        
        # Process all upload directories
        upload_dirs = [
            'uploads/packages',
            'uploads/rooms',
            'uploads/cms',
            'uploads/food_items',
            'uploads/services'
        ]
        
        all_file_changes = {}
        
        for directory in upload_dirs:
            print(f"\nProcessing directory: {directory}")
            changes = process_directory(directory)
            if changes:
                for old_name, new_name in changes:
                    all_file_changes[old_name] = new_name
        
        if not all_file_changes:
            print("\n✓ No files with spaces found!")
            return
        
        print(f"\n\nTotal files renamed: {len(all_file_changes)}")
        
        # Update database references
        print("\n=== UPDATING DATABASE ===\n")
        
        # 1. Fix PackageImage records
        package_images = db.query(PackageImage).all()
        pkg_img_updated = 0
        for img in package_images:
            if img.image_url and ' ' in img.image_url:
                old_url = img.image_url
                img.image_url = fix_spaces_in_path(old_url)
                pkg_img_updated += 1
                print(f"PackageImage {img.id}: {old_url} -> {img.image_url}")
        
        # 2. Fix Room main images
        rooms = db.query(Room).all()
        room_updated = 0
        for room in rooms:
            if room.image_url and ' ' in room.image_url:
                old_url = room.image_url
                room.image_url = fix_spaces_in_path(old_url)
                room_updated += 1
                print(f"Room {room.id} main image: {old_url} -> {room.image_url}")
        
        # 3. Fix RoomImage gallery images
        room_images = db.query(RoomImage).all()
        room_img_updated = 0
        for img in room_images:
            if img.image_url and ' ' in img.image_url:
                old_url = img.image_url
                img.image_url = fix_spaces_in_path(old_url)
                room_img_updated += 1
                print(f"RoomImage {img.id}: {old_url} -> {img.image_url}")
        
        # 4. Fix NearbyAttraction images
        attractions = db.query(NearbyAttraction).all()
        attraction_updated = 0
        for attr in attractions:
            if attr.image_url and ' ' in attr.image_url:
                old_url = attr.image_url
                attr.image_url = fix_spaces_in_path(old_url)
                attraction_updated += 1
                print(f"Attraction {attr.id}: {old_url} -> {attr.image_url}")
        
        # 5. Fix ServiceImage records
        service_images = db.query(ServiceImage).all()
        svc_img_updated = 0
        for img in service_images:
            if img.image_url and ' ' in img.image_url:
                old_url = img.image_url
                img.image_url = fix_spaces_in_path(old_url)
                svc_img_updated += 1
                print(f"ServiceImage {img.id}: {old_url} -> {img.image_url}")
        
        # 6. Fix FoodItemImage records
        food_images = db.query(FoodItemImage).all()
        food_img_updated = 0
        for img in food_images:
            if img.image_url and ' ' in img.image_url:
                old_url = img.image_url
                img.image_url = fix_spaces_in_path(old_url)
                food_img_updated += 1
                print(f"FoodItemImage {img.id}: {old_url} -> {img.image_url}")
        
        # Commit all changes
        db.commit()
        
        print("\n=== SUMMARY ===")
        print(f"Files renamed: {len(all_file_changes)}")
        print(f"PackageImages updated: {pkg_img_updated}")
        print(f"Room main images updated: {room_updated}")
        print(f"RoomImages updated: {room_img_updated}")
        print(f"Attractions updated: {attraction_updated}")
        print(f"ServiceImages updated: {svc_img_updated}")
        print(f"FoodItemImages updated: {food_img_updated}")
        print(f"\nTotal DB records updated: {pkg_img_updated + room_updated + room_img_updated + attraction_updated + svc_img_updated + food_img_updated}")
        print("\n✓ All changes committed successfully!")
        
    except Exception as e:
        db.rollback()
        print(f"\n✗ Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    main()
