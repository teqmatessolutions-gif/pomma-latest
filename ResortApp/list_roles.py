from app.database import SessionLocal
from app.models.user import Role

db = SessionLocal()
roles = db.query(Role).all()
print("Available Roles:")
for r in roles:
    print(f"ID: {r.id}, Name: {r.name}")
db.close()
