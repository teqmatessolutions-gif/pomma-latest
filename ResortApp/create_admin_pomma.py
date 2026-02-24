from app.database import SessionLocal
from app.models.user import User, Role
from app.utils.auth import get_password_hash
import json

def create_admin():
    db = SessionLocal()
    try:
        # 1. Ensure Admin Role exists
        admin_role = db.query(Role).filter(Role.name == "admin").first()
        if not admin_role:
            print("Creating 'admin' role...")
            admin_role = Role(
                name="admin",
                permissions=json.dumps(["*"])
            )
            db.add(admin_role)
            db.commit()
            db.refresh(admin_role)
            print(f"Created admin role with ID: {admin_role.id}")
        else:
            print(f"Admin role already exists (ID: {admin_role.id})")

        # 2. Find or Create Admin User
        target_email = "admin@pomma.com"
        admin_user = db.query(User).filter(User.email == target_email).first()

        if not admin_user:
            print(f"Creating new admin user: {target_email}")
            admin_user = User(
                name="System Administrator",
                email=target_email,
                hashed_password=get_password_hash("sooraj@123"),
                role_id=admin_role.id,
                is_active=True
            )
            db.add(admin_user)
            db.commit()
            db.refresh(admin_user)
            print(f"SUCCESS: Created admin user with ID: {admin_user.id}")
            print(f"Login: {target_email}")
            print("Password: sooraj@123")
        else:
            print(f"User {target_email} already exists.")
            # Ensure they have admin role
            admin_user.role_id = admin_role.id
            # Reset password to desired one
            admin_user.hashed_password = get_password_hash("sooraj@123")
            db.commit()
            print(f"SUCCESS: Reset password for {target_email} to 'sooraj@123'")

    except Exception as e:
        print(f"Error creating admin: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    create_admin()
