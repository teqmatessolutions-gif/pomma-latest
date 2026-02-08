import os
from PIL import Image
import uuid

# Define the base directory relative to this script
# frontend.py used BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
# Since this script is in ResortApp/, BASE_DIR is current dir
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_DIR = os.path.join(BASE_DIR, "uploads", "cms")

print(f"Scanning directory: {UPLOAD_DIR}")

if not os.path.exists(UPLOAD_DIR):
    print(f"Error: Directory {UPLOAD_DIR} does not exist.")
    exit(1)

count = 0
skipped = 0
errors = 0

for filename in os.listdir(UPLOAD_DIR):
    # Process only image files that are not already thumbnails
    if filename.lower().endswith(('.jpg', '.jpeg', '.png', '.webp')) and not filename.lower().endswith('_thumb.jpg'):
        file_path = os.path.join(UPLOAD_DIR, filename)
        thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
        thumb_path = os.path.join(UPLOAD_DIR, thumb_filename)
        
        if os.path.exists(thumb_path):
            skipped += 1
            # print(f"Thumbnail already exists for {filename}, skipping.")
            continue
            
        try:
            with Image.open(file_path) as img:
                img.thumbnail((200, 200), Image.Resampling.BICUBIC)
                if img.mode in ("RGBA", "P"):
                    img = img.convert("RGB")
                img.save(thumb_path, "JPEG", quality=60)
                print(f"Generated thumbnail for {filename}")
                count += 1
        except Exception as e:
            print(f"Error processing {filename}: {e}")
            errors += 1

print(f"\nSummary:")
print(f"Generated: {count}")
print(f"Skipped (already exist): {skipped}")
print(f"Errors: {errors}")
