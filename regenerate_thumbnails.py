import sys
import os

# Add ResortApp to python path to allow imports from app path
sys.path.append(os.path.join(os.getcwd(), "ResortApp"))

from app.utils.thumbnail_generator import generate_thumbnails_for_dirs

# Define directories to scan (relative to current working directory)
dirs_to_scan = [
    os.path.join("ResortApp", "uploads", "food_items"),
    os.path.join("ResortApp", "static", "food_categories"),
    os.path.join("ResortApp", "uploads", "rooms"),
    os.path.join("ResortApp", "uploads", "services"),
    os.path.join("ResortApp", "uploads", "packages")
]

print("Starting thumbnail regeneration...")
try:
    generate_thumbnails_for_dirs(dirs_to_scan)
    print("Thumbnail generation completed successfully.")
except Exception as e:
    print(f"Error generating thumbnails: {e}")
