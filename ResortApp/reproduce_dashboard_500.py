import sys
import os
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.api.dashboard import get_dashboard_full_stats
import traceback

# Setup DB session
db = SessionLocal()

try:
    print("running get_dashboard_full_stats...")
    stats = get_dashboard_full_stats(db)
    print("Success!")
    # print keys to verify
    print("Keys:", stats.keys())
    
except Exception:
    print("Failed!")
    traceback.print_exc()
finally:
    db.close()
