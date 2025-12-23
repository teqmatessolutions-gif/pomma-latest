import os
from PIL import Image
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def generate_thumbnails_for_dirs(directories):
    """
    Scans specified directories for images and generates thumbnails if they don't exist.
    """
    count = 0
    logger.info("Starting thumbnail generation check...")
    
    for directory in directories:
        if not os.path.exists(directory):
            # Try absolute path based on CWD if relative fails
            # But usually we pass relative paths "uploads/rooms"
            logger.info(f"Directory not found (skipping): {directory}")
            continue
            
        logger.info(f"Scanning directory: {directory}")
        try:
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
                        logger.info(f"Created missing thumb: {thumb_filename}")
                        count += 1
                except Exception as e:
                    logger.error(f"Error processing {filename}: {e}")
        except Exception as dir_error:
            logger.error(f"Error scanning directory {directory}: {dir_error}")

    logger.info(f"Thumbnail check complete. Generated {count} new thumbnails.")
