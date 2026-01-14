from app.database import SessionLocal
from app.models.user import User, Role

db = SessionLocal()

# Find Admin Role
admin_role = db.query(Role).filter(Role.name == "admin").first()
print(f"Admin Role ID: {admin_role.id if admin_role else 'NOT FOUND'}")

if admin_role:
    admins = db.query(User).filter(User.role_id == admin_role.id).all()
    print("--- Admin Users ---")
    for user in admins:
        print(f"Email: {user.email}")
else:
    print("No admin role found!")

# Also check for specific email
target_email = "admin@orchid.com"
user = db.query(User).filter(User.email == target_email).first()
print(f"\nUser {target_email}: {'FOUND' if user else 'NOT FOUND'}")

db.close()
