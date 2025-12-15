import os
import sys
from sqlalchemy import create_engine, text

# Load env safely
db_url = None
try:
    with open(".env", "r", encoding="utf-8-sig") as f:
        for line in f:
            if line.startswith("DATABASE_URL="):
                db_url = line.strip().split("=", 1)[1]
                break
except:
    pass
    
if not db_url:
    print("No DB URL")
    sys.exit(1)

engine = create_engine(db_url)

with engine.connect() as conn:
    print("Dates:")
    for pid in [3, 6]:
        row = conn.execute(text("SELECT id, check_in, check_out FROM package_bookings WHERE id=:id"), {"id": pid}).mappings().first()
        if row:
            print(f"PB{row.id}: {row.check_in} (type {type(row.check_in)}) to {row.check_out}")
