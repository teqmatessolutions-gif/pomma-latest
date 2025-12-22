from app.database import SessionLocal
from app.models.user import Role

db = SessionLocal()
admin = db.query(Role).filter(Role.name == "admin").first()
if admin:
    print(f"Admin Role Found: ID {admin.id}")
else:
    print("Admin Role NOT Found")
db.close()
