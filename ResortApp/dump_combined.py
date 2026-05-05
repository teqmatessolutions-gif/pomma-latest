import sys
import os
import json
import asyncio

# Add ResortApp to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.database import SessionLocal
from app.utils.aiosell_sync import sync_all
import app.utils.aiosell_sync as sync_module

# Mock push_to_aiosell
async def mock_push(endpoint, payload):
    print("=== FINAL COMBINED PAYLOAD ===")
    print(json.dumps(payload, indent=4))
    return True

sync_module.push_to_aiosell = mock_push

async def run():
    db = SessionLocal()
    await sync_all(db, days=1) # just 1 day to keep output small
    db.close()

if __name__ == "__main__":
    asyncio.run(run())
