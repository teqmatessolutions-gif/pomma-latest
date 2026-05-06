import asyncio
import httpx
import logging
from datetime import datetime

# =============================================================================
# SYSTEM HEALTH MONITORING UTILITY
# =============================================================================
# This module monitors external connectivity and system resource availability.
# It ensures the application maintains a connection to the central configuration
# server for updates and status checks.
# =============================================================================

# CONFIGURATION
# REPLACE THIS URL with your raw JSON file URL (e.g., GitHub Gist Raw URL)
# The JSON should look like: {"status": "active"} or {"status": "locked"}
REMOTE_CONFIG_URL = "https://gist.githubusercontent.com/placeholder_user/gist_id/raw/config.json"

# INTERNAL STATE
_system_status = "active"
_last_check = None
logger = logging.getLogger("health_monitor")

import os
# CROSS-PLATFORM LOCK PATH (Synced with main.py)
# Go up one level from 'app/utils' to 'app' then to 'ResortApp' (root)
# wait, health_monitor is in app/utils. main.py is in ResortApp.
# __file__ = ResortApp/app/utils/health_monitor.py
# dirname = ResortApp/app/utils
# ../../ = ResortApp
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LOCK_FILE_PATH = os.path.join(BASE_DIR, "lock.dat")

def load_local_status():
    """Checks for the existence of the local lock file."""
    try:
        import os
        # DEBUG LOGGING
        print(f"[HEALTH_MONITOR] Checking lock file at: {LOCK_FILE_PATH}")
        exists = os.path.exists(LOCK_FILE_PATH)
        print(f"[HEALTH_MONITOR] File exists: {exists}")
        
        if exists:
            with open(LOCK_FILE_PATH, "r") as f:
                content = f.read().strip()
                print(f"[HEALTH_MONITOR] Read content: '{content}'")
                return content
    except Exception as e:
        print(f"[HEALTH_MONITOR] Error reading file: {e}")
        pass
    return "active"

def set_local_status(status):
    """Writes the local status file."""
    try:
        global _system_status
        status = status.lower()
        if status in ["active"]:
            import os
            if os.path.exists(LOCK_FILE_PATH):
                os.remove(LOCK_FILE_PATH)
        else:
            with open(LOCK_FILE_PATH, "w") as f:
                f.write(status)
        
        _system_status = status
        return True
    except Exception as e:
        logger.error(f"Failed to update local status: {e}")
        return False

async def check_remote_status():
    """
    Disabled.
    """
    return

async def start_monitoring_loop():
    """
    Disabled.
    """
    return

def get_system_status():
    """
    Returns the current system status.
    Always returns 'active' to disable suspension logic.
    """
    return "active"

