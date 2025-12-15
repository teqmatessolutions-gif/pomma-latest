import sys
import os
sys.path.append(os.getcwd())

try:
    from app.api import report
    print("Import successful")
except Exception as e:
    import traceback
    traceback.print_exc()
    print(f"Import failed: {e}")
