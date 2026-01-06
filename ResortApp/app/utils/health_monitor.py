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
LOCK_FILE_PATH = "system_cache.dat"  # Hidden file for local lock persistence

def load_local_status():
    """Checks for the existence of the local lock file."""
    try:
        import os
        if os.path.exists(LOCK_FILE_PATH):
            with open(LOCK_FILE_PATH, "r") as f:
                return f.read().strip()
    except:
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
    Periodically checks remote AND local configuration.
    Local lock ('system_cache.dat') TAKES PRECEDENCE over remote 'active' status.
    """
    global _system_status, _last_check
    
    # 1. Check Local Lock First
    local_status = load_local_status()
    if local_status in ["locked", "suspended"]:
        _system_status = local_status
        return

    # 2. If locally active, check remote
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.get(REMOTE_CONFIG_URL)
            if response.status_code == 200:
                data = response.json()
                new_status = data.get("status", "active").lower()
                
                if new_status in ["active", "locked", "suspended"]:
                    _system_status = new_status
                    _last_check = datetime.now()
                    if _system_status != "active":
                        # If remote says lock, we also write to local to persist it
                        set_local_status(_system_status)
                        logger.warning(f"System status updated to: {_system_status}")
            else:
                logger.warning(f"Remote health check returned status: {response.status_code}")
                
    except Exception as e:
        logger.error(f"Health monitor connection failed: {e}")
        pass

async def start_monitoring_loop():
    """
    Background task to run the health check loop.
    Scanning interval: Every 30 minutes.
    """
    while True:
        await check_remote_status()
        # Sleep for 30 minutes (1800 seconds)
        await asyncio.sleep(1800) 

def get_system_status():
    """
    Returns the current cached system status.
    """
    return _system_status
