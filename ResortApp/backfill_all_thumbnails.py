import os
from PIL import Image
import io

# Define directories to scan
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DIRS_TO_SCAN = [
    {"path": os.path.join(BASE_DIR, "uploads", "cms"), "size": (200, 200)},
    {"path": os.path.join(BASE_DIR, "uploads", "rooms"), "size": (400, 400)},
    {"path": os.path.join(BASE_DIR, "uploads", "packages"), "size": (200, 200)},
]

def process_directory(directory_info):
    path = directory_info["path"]
    size = directory_info["size"]
    
    if not os.path.exists(path):
        print(f"Skipping {path}: Directory does not exist.")
        return 0, 0, 0
    
    print(f"Scanning directory: {path} (Thumbnail size: {size})")
    
    count = 0
    skipped = 0
    errors = 0
    
    for filename in os.listdir(path):
        # Process only images that are not already thumbnails
        if filename.lower().endswith(('.jpg', '.jpeg', '.png', '.webp')) and not filename.lower().endswith('_thumb.jpg'):
            file_path = os.path.join(path, filename)
            thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
            thumb_path = os.path.join(path, thumb_filename)
            
            if os.path.exists(thumb_path):
                skipped += 1
                continue
                
            try:
                with Image.open(file_path) as img:
                    img.thumbnail(size, Image.Resampling.BICUBIC)
                    if img.mode in ("RGBA", "P"):
                        img = img.convert("RGB")
                    img.save(thumb_path, "JPEG", quality=75, optimize=True)
                    print(f"  Generated thumbnail for {filename}")
                    count += 1
            except Exception as e:
                print(f"  Error processing {filename}: {e}")
                errors += 1
    
    return count, skipped, errors

if __name__ == "__main__":
    total_generated = 0
    total_skipped = 0
    total_errors = 0
    
    for dir_info in DIRS_TO_SCAN:
        gen, skip, err = process_directory(dir_info)
        total_generated += gen
        total_skipped += skip
        total_errors += err
        print("-" * 40)
        
    print(f"\nOverall Summary:")
    print(f"Total Generated: {total_generated}")
    print(f"Total Skipped: {total_skipped}")
    print(f"Total Errors: {total_errors}")
    print("\nDone.")
