import os
import sys
sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.Package import Package

db = SessionLocal()

try:
    # Query all packages to see the structure
    packages = db.query(Package).all()
    
    print(f"\n=== Found {len(packages)} packages ===\n")
    
    for pkg in packages:
        # Print all attributes
        has_match = False
        attrs_dict = {}
        
        for attr in dir(pkg):
            if not attr.startswith('_') and not callable(getattr(pkg, attr)):
                try:
                    val = getattr(pkg, attr)
                    if val and 'ed2fae49d15d497bbcf2cfb25efd3084' in str(val):
                        attrs_dict[attr] = val
                        has_match = True
                except:
                    pass
        
        if has_match:
            print(f"Package ID: {pkg.id}")
            for attr, val in attrs_dict.items():
                print(f"  {attr}: {repr(val)}")
            print("\n  ^^ THIS IS THE PROBLEMATIC PACKAGE ^^")
            print()

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
