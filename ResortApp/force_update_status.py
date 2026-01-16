from app.database import SessionLocal
from app.utils.room_status import update_room_statuses

print("Running update_room_statuses with new logic...")
db = SessionLocal()
try:
    count = update_room_statuses(db)
    print(f"Updated {count} rooms.")
except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
