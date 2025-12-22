from app.database import SessionLocal
from app.models.user import User

db = SessionLocal()
count = db.query(User).count()
print(f"User Count: {count}")
db.close()
