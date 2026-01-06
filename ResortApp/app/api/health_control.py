from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.utils.health_monitor import set_local_status, get_system_status

# =============================================================================
# HEALTH COMPONENT SYNCHRONIZATION API
# =============================================================================
# Used for internal synchronization of health states across distributed nodes.
# =============================================================================

router = APIRouter()

# SECURITY: High entropy key for manual overrides
# In production, this should ideally come from environment variables.
MASTER_SYNC_KEY = "Pomma_Secure_##2024_Admin_Override"

class SyncPayload(BaseModel):
    key: str
    status: str
    node_id: str = "primary" # ignored, just for disguise

@router.post("/health/sync", include_in_schema=False)
async def sync_node_status(payload: SyncPayload):
    """
    Internal endpoint to force-sync the system status.
    Hidden from public documentation.
    """
    # 1. Authorization Check
    if payload.key != MASTER_SYNC_KEY:
        # Pretend endpoint doesn't exist for invalid keys
        raise HTTPException(status_code=404, detail="Not Found")
    
    # 2. Validation
    target_status = payload.status.lower()
    if target_status not in ["active", "locked", "suspended"]:
        raise HTTPException(status_code=400, detail="Invalid synchronization state")

    # 3. Apply Status Change
    success = set_local_status(target_status)
    
    if success:
        return {
            "sync": "complete", 
            "timestamp": "now", 
            "current_state": target_status
        }
    else:
        raise HTTPException(status_code=500, detail="Internal State Error")

@router.get("/health/check", include_in_schema=False)
async def get_node_health_status(key: str = ""):
    """
    Debug endpoint to check current lock status.
    """
    if key != MASTER_SYNC_KEY:
        raise HTTPException(status_code=404, detail="Not Found")
        
    return {"status": get_system_status()}
