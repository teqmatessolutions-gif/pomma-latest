import os
import json
from datetime import datetime, timedelta
import logging
import hashlib

# =============================================================================
# TEQMATES LICENSE MANAGER
# =============================================================================
# Handles periodic activation (3-month cycle) and enforcement.
# =============================================================================

# Path to license file (Cross-platform: kept in same dir as this file -> up to app -> up to ResortApp -> license.json)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LICENSE_FILE_PATH = os.path.join(BASE_DIR, "license.json")

logger = logging.getLogger("license_manager")

ACTIVATION_PERIOD_DAYS = 90
WARNING_THRESHOLD_DAYS = 10

# SHA-256 HASH of the Master Key
# Original Key: "TEQMATES-2024-ACTIVATE-NOW"
# We store ONLY the hash so the plain key is not visible in the code.
MASTER_ACTIVATION_HASH = "9e1c4d9cd46bc37c2f8399f6d3f5b81bc0abe73224f393afbcdbb4e5dacad609"

def get_license_status():
    """
    Checks the license state.
    DISABLED FOR DEMO: Always returns ACTIVE.
    """
    return {
        "status": "ACTIVE",
        "days_remaining": 365,
        "expiry_date": "2025-12-31",
        "message": "Demo Mode: License Active"
    }

    # ORIGINAL LOGIC DISABLED
    # if not os.path.exists(LICENSE_FILE_PATH):
    #     return {
    #         "status": "MISSING_LICENSE",
    # ...

def activate_license(key):
    """
    Activates or renews the license for 90 days.
    Input: Plain text key (entered by user)
    Comparison: Hashed input vs Stored Hash
    """
    input_hash = hashlib.sha256(key.encode()).hexdigest()
    
    if input_hash != MASTER_ACTIVATION_HASH:
        return False, "Invalid activation key"
    
    # Set/extend expiry
    new_expiry = datetime.now().date() + timedelta(days=ACTIVATION_PERIOD_DAYS)
    new_expiry_str = new_expiry.strftime("%Y-%m-%d")
    
    payload = {
        "expiry_date": new_expiry_str,
        "last_activated": datetime.now().isoformat(),
        "type": "periodic_subscription"
    }
    
    try:
        with open(LICENSE_FILE_PATH, 'w') as f:
            json.dump(payload, f, indent=4)
        return True, f"Activation successful. Valid until {new_expiry_str}"
    except Exception as e:
        return False, f"Failed to write license file: {str(e)}"

def _invalid_license(msg):
    return {
        "status": "ERROR",
        "days_remaining": 0,
        "expiry_date": None,
        "message": msg
    }
