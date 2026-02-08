import os
import sys
sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.Package import Package

db = SessionLocal()

try:
    # Query all packages
    packages = db.query(Package).limit(3).all()
    
    print(f"\n=== Showing first 3 packages ===\n")
    
    for pkg in packages:
        print(f"Package ID: {pkg.id}")
        
        # Get all non-private attributes
        for attr in dir(pkg):
            if not attr.startswith('_') and not callable(getattr(pkg, attr)):
                try:
                    val = getattr(pkg, attr)
                    # Only show attributes that have values and might be image-related
                    if val is not None:
                        val_str = str(val)[:100]  # Limit to 100 chars
                        print(f"  {attr}: {repr(val_str)}")
                except Exception as e:
                    pass
        
        print()
    
    # Also check what files exist on disk
    print("\n=== Package files on disk (first 5) ===")
    upload_dir = "uploads/packages/"
    files = sorted(os.listdir(upload_dir))[:5]
    for f in files:
        print(f"  {f}")

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
