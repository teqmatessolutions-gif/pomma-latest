import os
from PIL import Image

def generate_thumbnails(directories):
    count = 0
    for directory in directories:
        if not os.path.exists(directory):
            print(f"Skipping {directory}, not found.")
            continue
            
        print(f"Scanning {directory}...")
        files = [f for f in os.listdir(directory) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
        
        for filename in files:
            # Skip if it is already a thumbnail
            if '_thumb.' in filename:
                continue

            filepath = os.path.join(directory, filename)
            base_name, _ = os.path.splitext(filename)
            thumb_filename = f"{base_name}_thumb.jpg"
            thumb_path = os.path.join(directory, thumb_filename)
            
            # If thumbnail exists, skip
            if os.path.exists(thumb_path):
                continue
                
            try:
                with Image.open(filepath) as img:
                    img.thumbnail((200, 200), Image.Resampling.LANCZOS)
                    if img.mode in ("RGBA", "P"):
                        img = img.convert("RGB")
                    img.save(thumb_path, "JPEG", quality=60, optimize=True)
                    print(f"Created thumb: {thumb_filename}")
                    count += 1
            except Exception as e:
                print(f"Error processing {filename}: {e}")

    print(f"Generated {count} thumbnails.")

if __name__ == "__main__":
    dirs = [
        os.path.join("static", "rooms"),
        os.path.join("uploads", "rooms"),
        os.path.join("uploads", "packages"),
        os.path.join("uploads", "cms"),
        os.path.join("uploads", "services"),
        os.path.join("uploads", "food_items"),
        os.path.join("static", "food_categories")
    ]
    generate_thumbnails(dirs)
