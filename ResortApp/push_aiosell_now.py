import asyncio
import os
import sys
from sqlalchemy.orm import Session

# Add the project root to sys.path to allow imports from app
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import SessionLocal
from app.utils.aiosell_sync import sync_all

async def manual_push():
    print("--- STARTING MANUAL AIOSELL PUSH ---")
    db = SessionLocal()
    try:
        print("Pushing all Inventory and Rates (180 days)...")
        await sync_all(db, days=180)
        print("--- PUSH COMPLETED SUCCESSFULLY ---")
    except Exception as e:
        print(f"--- PUSH FAILED: {str(e)} ---")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    asyncio.run(manual_push())
