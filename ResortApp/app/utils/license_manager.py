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
    Returns dict: {
        "status": "MISSING" | "ACTIVE" | "WARNING" | "EXPIRED",
        "days_remaining": int (or None),
        "expiry_date": str (or None),
        "message": str
    }
    """
    if not os.path.exists(LICENSE_FILE_PATH):
        return {
            "status": "MISSING_LICENSE",
            "days_remaining": 0,
            "expiry_date": None,
            "message": "Application requires activation."
        }
    
    try:
        with open(LICENSE_FILE_PATH, 'r') as f:
            data = json.load(f)
            
        expiry_str = data.get("expiry_date")
        if not expiry_str:
            return _invalid_license("Corrupted license file")

        expiry_date = datetime.strptime(expiry_str, "%Y-%m-%d").date()
        today = datetime.now().date()
        
        days_remaining = (expiry_date - today).days
        
        if days_remaining < 0:
            return {
                "status": "EXPIRED",
                "days_remaining": days_remaining,
                "expiry_date": expiry_str,
                "message": "License expired. Contact Teqmates for assistance."
            }
        
        if days_remaining <= WARNING_THRESHOLD_DAYS:
            return {
                "status": "WARNING",
                "days_remaining": days_remaining,
                "expiry_date": expiry_str,
                "message": f"License expires in {days_remaining} days. Contact Teqmates."
            }
            
        return {
            "status": "ACTIVE",
            "days_remaining": days_remaining,
            "expiry_date": expiry_str,
            "message": "License active."
        }
        
    except Exception as e:
        logger.error(f"License check error: {e}")
        return _invalid_license("License check failed")

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
