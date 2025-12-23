import os
from PIL import Image
import sys

def optimize_images(directory, max_size=(1200, 1200), quality=80):
    if not os.path.exists(directory):
        print(f"Directory not found: {directory}")
        return

    print(f"Scanning {directory}...")
    files = [f for f in os.listdir(directory) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    
    total_saved = 0
    
    for filename in files:
        filepath = os.path.join(directory, filename)
        try:
            original_size = os.path.getsize(filepath)
            
            with Image.open(filepath) as img:
                # Skip if image is already smallish
                if img.width <= max_size[0] and img.height <= max_size[1] and original_size < 500 * 1024:
                    print(f"Skipping {filename} (already optimized)")
                    continue

                # Resize
                img.thumbnail(max_size, Image.Resampling.LANCZOS)
                
                # Convert to RGB (remove alpha from PNGs if saving as JPG)
                if img.mode in ("RGBA", "P"):
                    img = img.convert("RGB")
                
                # Save back to the same path
                img.save(filepath, "JPEG", quality=quality, optimize=True)
                
                new_size = os.path.getsize(filepath)
                saved = original_size - new_size
                if saved > 0:
                    total_saved += saved
                    print(f"Optimized {filename}: {original_size/1024/1024:.2f}MB -> {new_size/1024/1024:.2f}MB")
                else:
                    print(f"Processed {filename} (no size reduction)")
                    
        except Exception as e:
            print(f"Error processing {filename}: {e}")

    print(f"\nTotal space saved: {total_saved/1024/1024:.2f} MB")

if __name__ == "__main__":
    target_dir = os.path.join(os.getcwd(), "static", "rooms")
    optimize_images(target_dir)
