import os
import json
from datetime import datetime, timedelta

# Path to the license file
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
LICENSE_FILE_PATH = os.path.join(BASE_DIR, "license.json")

def set_30_day_license():
    print(f"Checking license file at: {LICENSE_FILE_PATH}")
    
    # Calculate new expiry: 30 days from now
    new_expiry = datetime.now() + timedelta(days=30)
    new_expiry_str = new_expiry.isoformat()
    
    payload = {
        "expiry_date": new_expiry_str,
        "last_activated": datetime.now().isoformat(),
        "type": "manual_override",
        "note": "Initial 30-day period granted by support"
    }
    
    try:
        with open(LICENSE_FILE_PATH, 'w') as f:
            json.dump(payload, f, indent=4)
        print(f"SUCCESS: License updated. New expiry: {new_expiry.strftime('%Y-%m-%d %H:%M:%S')}")
        print("The system should now be unlocked.")
    except Exception as e:
        print(f"FAILED to update license file: {e}")

if __name__ == "__main__":
    set_30_day_license()
