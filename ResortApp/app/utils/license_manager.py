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
WARNING_THRESHOLD_DAYS = 5

# SHA-256 HASH of the Master Key
# Original Key: "TEQMATES-2024-ACTIVATE-NOW"
# We store ONLY the hash so the plain key is not visible in the code.
MASTER_ACTIVATION_HASH = "9e1c4d9cd46bc37c2f8399f6d3f5b81bc0abe73224f393afbcdbb4e5dacad609"


def get_license_status():
    """
    Checks the license state.
    """
    if not os.path.exists(LICENSE_FILE_PATH):
        return {
            "status": "MISSING_LICENSE",
            "days_remaining": 0,
            "expiry_date": None,
            "message": "System not activated. Please contact support."
        }

    try:
        with open(LICENSE_FILE_PATH, 'r') as f:
            data = json.load(f)
        
        expiry_str = data.get("expiry_date")
        if not expiry_str:
             return _invalid_license("Corrupt license file")

        # Try parsing as datetime (ISO) first, fallback to date for backward compatibility
        try:
            expiry = datetime.fromisoformat(expiry_str)
        except ValueError:
            # Fallback for old YYYY-MM-DD format
            expiry_date = datetime.strptime(expiry_str, "%Y-%m-%d").date()
            expiry = datetime.combine(expiry_date, datetime.min.time()) + timedelta(days=1) # End of that day basically

        now = datetime.now()
        remaining = expiry - now
        days_remaining = remaining.days
        seconds_remaining = remaining.total_seconds()

        if seconds_remaining < 0:
            return {
                "status": "EXPIRED",
                "days_remaining": 0,
                "expiry_date": expiry_str,
                "message": "License expired. Please renew."
            }
        
        # Warning threshold (e.g., 10 days)
        status = "ACTIVE"
        msg = "License Active"
        
        # Display minutes if less than a day
        if days_remaining < 1:
             minutes_left = int(seconds_remaining / 60)
             seconds_left = int(seconds_remaining % 60)
             if seconds_remaining <= 60:  # Less than 1 minute → URGENT warning
                 status = "EXPIRING_SOON"
                 msg = f"License expires in {int(seconds_remaining)} seconds!"
             elif minutes_left < 60:
                 status = "WARNING"
                 msg = f"License expires in {minutes_left} minutes {seconds_left} seconds"
        elif days_remaining <= WARNING_THRESHOLD_DAYS:
             status = "WARNING"
             msg = f"License expires in {days_remaining} days"

        return {
            "status": status,
            "days_remaining": days_remaining,
            "expiry_date": expiry_str,
            "message": msg
        }
    except Exception as e:
        logger.error(f"License check error: {e}")
        return _invalid_license(f"License error: {str(e)}")

def activate_license(key):
    """
    Activates or renews the license.
    FOR TESTING: Sets expiry to 10 minutes from now.
    """
    input_hash = hashlib.sha256(key.encode()).hexdigest()
    
    if input_hash != MASTER_ACTIVATION_HASH:
        return False, "Invalid activation key"
    
    # PRODUCTION: Using 90-day cycle as requested
    new_expiry = datetime.now() + timedelta(days=ACTIVATION_PERIOD_DAYS)
    # FOR TESTING (Commented out):
    # new_expiry = datetime.now() + timedelta(minutes=2)
    
    new_expiry_str = new_expiry.isoformat()
    
    payload = {
        "expiry_date": new_expiry_str,
        "last_activated": datetime.now().isoformat(),
        "type": "periodic_subscription"
    }
    
    try:
        with open(LICENSE_FILE_PATH, 'w') as f:
            json.dump(payload, f, indent=4)
        return True, f"Activation successful. Valid until {new_expiry.strftime('%Y-%m-%d %H:%M:%S')}"
    except Exception as e:
        return False, f"Failed to write license file: {str(e)}"

def _invalid_license(msg):
    return {
        "status": "ERROR",
        "days_remaining": 0,
        "expiry_date": None,
        "message": msg
    }
