import os
import sys
sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.Package import Package, PackageImage

db = SessionLocal()

try:
    print("\n=== PACKAGE IMAGES ANALYSIS ===\n")
    
    # Get all package images
    package_images = db.query(PackageImage).all()
    
    print(f"Total PackageImage records: {len(package_images)}\n")
    
    for img in package_images:
        print(f"PackageImage ID: {img.id}")
        print(f"  Package ID: {img.package_id}")
        print(f"  Image URL: {repr(img.image_url)}")
        
        # Check if file exists
        if img.image_url:
            # Clean the URL
            url = img.image_url
            if url.startswith('/'):
                url = url[1:]
            
            file_path = os.path.join(os.getcwd(), url)
            exists = os.path.exists(file_path)
            
            if exists:
                size = os.path.getsize(file_path)
                print(f"  File: EXISTS ({size} bytes)")
            else:
                print(f"  File: MISSING")
                print(f"  Expected path: {file_path}")
                
                # Try to find similar files
                if 'uploads/packages/' in url:
                    basename = os.path.basename(url)
                    pkg_dir = "uploads/packages/"
                    if os.path.exists(pkg_dir):
                        similar = [f for f in os.listdir(pkg_dir) if basename.replace('%20', ' ') in f or basename in f]
                        if similar:
                            print(f"  Similar files found: {similar[:3]}")
        print()

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
