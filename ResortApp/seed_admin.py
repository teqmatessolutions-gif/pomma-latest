from app.database import SessionLocal, engine, Base
from app.models.user import User, Role
from app.utils.auth import get_password_hash
from sqlalchemy import text
import sys

def seed_admin():
    db = SessionLocal()
    try:
        print("Checking for existing tables...")
        # Ensure tables exist (idempotent)
        Base.metadata.create_all(bind=engine)
        
        print("Checking roles...")
        # check/create admin role
        admin_role = db.query(Role).filter(Role.name == "admin").first()
        if not admin_role:
            print("Creating 'admin' role...")
            admin_role = Role(name="admin", permissions='["*"]')
            db.add(admin_role)
            db.commit()
            db.refresh(admin_role)
            print("✅ Created 'admin' role.")
        else:
            print("✅ 'admin' role already exists.")

        print("Checking users...")
        # Check/create admin user
        admin_user = db.query(User).filter(User.email == "admin@resort.com").first()
        if not admin_user:
            print("Creating 'admin' user...")
            hashed_pwd = get_password_hash("admin123")
            admin_user = User(
                email="admin@resort.com",
                hashed_password=hashed_pwd,
                name="Resort Administrator",
                is_active=True,
                role_id=admin_role.id
            )
            db.add(admin_user)
            db.commit()
            print("✅ Created admin user: admin@resort.com / admin123")
        else:
            print("✅ Admin user already exists.")

    except Exception as e:
        print(f"❌ Error seeding data: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_admin()
