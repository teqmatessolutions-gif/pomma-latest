from app.database import SessionLocal
from app.models.user import Role
from app.schemas.user import RoleCreate
from app.curd import role as crud_role

db = SessionLocal()
admin = db.query(Role).filter(Role.name == "admin").first()

if not admin:
    print("Creating Admin Role...")
    admin_role_schema = RoleCreate(name="admin", permissions='["*"]')
    admin_role = crud_role.create_role(db, admin_role_schema)
    print(f"Admin Role Created with ID: {admin_role.id}")
else:
    print(f"Admin Role already exists: ID {admin.id}")

db.close()
