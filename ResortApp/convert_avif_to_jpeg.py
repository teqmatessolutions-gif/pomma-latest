"""
Convert AVIF images to JPEG format
Uses ffmpeg to handle AVIF files that Pillow can't process
"""
import os
import subprocess
import sys

def convert_avif_to_jpeg(avif_path):
    """Convert AVIF to JPEG using ffmpeg"""
    if not avif_path.endswith('.avif'):
        return False
    
    jpeg_path = avif_path.replace('.avif', '.jpg')
    
    # Check if JPEG already exists
    if os.path.exists(jpeg_path):
        print(f"  JPEG already exists: {jpeg_path}")
        return True
    
    try:
        # Use ffmpeg to convert
        result = subprocess.run(
            ['ffmpeg', '-i', avif_path, '-q:v', '2', jpeg_path],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode == 0 and os.path.exists(jpeg_path):
            print(f"  ✓ Converted: {os.path.basename(avif_path)} -> {os.path.basename(jpeg_path)}")
            return True
        else:
            print(f"  ✗ Failed to convert: {avif_path}")
            print(f"     ffmpeg stderr: {result.stderr[:200]}")
            print(f"     Return code: {result.returncode}")
            return False
    except FileNotFoundError:
        print(f"  ✗ ffmpeg not found. Install with: sudo apt install ffmpeg")
        return False
    except Exception as e:
        print(f"  ✗ Error: {e}")
        return False

def find_and_convert_avif_files():
    """Find all AVIF files and convert them"""
    upload_dirs = [
        'uploads/packages',
        'uploads/rooms',
        'uploads/cms',
        'uploads/food_items',
        'uploads/services'
    ]
    
    avif_files = []
    
    for directory in upload_dirs:
        if not os.path.exists(directory):
            continue
        
        for filename in os.listdir(directory):
            if filename.endswith('.avif'):
                avif_files.append(os.path.join(directory, filename))
    
    return avif_files

def main():
    print("\n=== CONVERTING AVIF FILES TO JPEG ===\n")
    
    avif_files = find_and_convert_avif_files()
    
    if not avif_files:
        print("No AVIF files found!")
        return
    
    print(f"Found {len(avif_files)} AVIF files:\n")
    for f in avif_files:
        print(f"  {f}")
    
    print("\nConverting...\n")
    
    converted = 0
    failed = 0
    
    for avif_file in avif_files:
        if convert_avif_to_jpeg(avif_file):
            converted += 1
        else:
            failed += 1
    
    print(f"\n=== SUMMARY ===")
    print(f"Converted: {converted}")
    print(f"Failed: {failed}")
    
    if converted > 0:
        print(f"\n✓ Now run: python generate_missing_thumbnails.py")
        print(f"  This will create thumbnails for the new JPEG files")

if __name__ == "__main__":
    main()
