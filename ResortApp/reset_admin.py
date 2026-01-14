from app.database import SessionLocal
from app.models.user import User, Role
from app.utils.auth import get_password_hash

db = SessionLocal()

# 1. Find Admin Role
admin_role = db.query(Role).filter(Role.name == "admin").first()
if not admin_role:
    print("Creating admin role...")
    from app.schemas.user import RoleCreate
    from app.curd import role as crud_role
    admin_role = crud_role.create_role(db, RoleCreate(name="admin", permissions='["*"]'))

print(f"Admin Role ID: {admin_role.id}")

# 2. Find or Create Admin User
target_email = "admin@orchid.com"
admin_user = db.query(User).filter(User.email == target_email).first()

if not admin_user:
    # Check if there is ANY admin user
    any_admin = db.query(User).filter(User.role_id == admin_role.id).first()
    if any_admin:
        admin_user = any_admin
        print(f"Found existing admin user: {admin_user.email}")
    else:
        print(f"Creating new admin user: {target_email}")
        admin_user = User(
            name="Admin User",
            email=target_email,
            hashed_password=get_password_hash("admin123"),
            role_id=admin_role.id,
            is_active=True
        )
        db.add(admin_user)
        db.commit()
        db.refresh(admin_user)
        print(f"Created admin user with ID: {admin_user.id}")

# 3. Reset Password
print(f"Resetting password for {admin_user.email} to 'admin123'...")
admin_user.hashed_password = get_password_hash("admin123")
db.commit()
print("Password reset successful.")

db.close()
