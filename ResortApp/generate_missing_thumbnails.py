"""
Generate missing thumbnails for all uploaded images
Scans all upload directories and creates _thumb.jpg for images that don't have one
"""
import os
from PIL import Image
import sys

def generate_thumbnail(image_path, thumb_path, size=(400, 400)):
    """Generate a thumbnail from an image"""
    try:
        with Image.open(image_path) as img:
            # Convert to RGB if necessary (handles RGBA, AVIF, etc.)
            if img.mode in ('RGBA', 'LA', 'P'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Create thumbnail
            img.thumbnail(size, Image.Resampling.LANCZOS)
            img.save(thumb_path, 'JPEG', quality=85, optimize=True)
            return True
    except Exception as e:
        print(f"  ERROR creating thumbnail: {e}")
        return False

def process_directory(directory):
    """Process all images in a directory and generate missing thumbnails"""
    if not os.path.exists(directory):
        print(f"Directory not found: {directory}")
        return 0
    
    count = 0
    errors = 0
    
    for filename in os.listdir(directory):
        # Skip if it's already a thumbnail
        if '_thumb.jpg' in filename or '_thumb.jpeg' in filename:
            continue
        
        # Check if it's an image file
        if not any(filename.lower().endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.webp', '.avif', '.jfif']):
            continue
        
        # Generate thumbnail name
        name_without_ext = os.path.splitext(filename)[0]
        thumb_filename = f"{name_without_ext}_thumb.jpg"
        
        image_path = os.path.join(directory, filename)
        thumb_path = os.path.join(directory, thumb_filename)
        
        # Check if thumbnail already exists
        if os.path.exists(thumb_path):
            continue
        
        print(f"  Creating thumbnail: {thumb_filename}")
        if generate_thumbnail(image_path, thumb_path):
            count += 1
        else:
            errors += 1
    
    return count, errors

def main():
    print("\n=== GENERATING MISSING THUMBNAILS ===\n")
    
    # Process all upload directories
    upload_dirs = [
        'uploads/packages',
        'uploads/rooms',
        'uploads/cms',
        'uploads/food_items',
        'uploads/services'
    ]
    
    total_created = 0
    total_errors = 0
    
    for directory in upload_dirs:
        print(f"\nProcessing: {directory}")
        created, errors = process_directory(directory)
        total_created += created
        total_errors += errors
        if created > 0:
            print(f"  ✓ Created {created} thumbnails")
        if errors > 0:
            print(f"  ✗ {errors} errors")
    
    print(f"\n=== SUMMARY ===")
    print(f"Total thumbnails created: {total_created}")
    if total_errors > 0:
        print(f"Total errors: {total_errors}")
    print("\n✓ Done!")

if __name__ == "__main__":
    main()
