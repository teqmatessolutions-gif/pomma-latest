from app.database import SessionLocal
from app.models.user import User, Role
import json

def check_system_state():
    db = SessionLocal()
    try:
        users_count = db.query(User).count()
        roles_count = db.query(Role).count()
        
        print(f"Total Users: {users_count}")
        print(f"Total Roles: {roles_count}")
        
        if roles_count > 0:
            print("\nExisting Roles:")
            for role in db.query(Role).all():
                print(f"- ID: {role.id}, Name: {role.name}")
        
        if users_count > 0:
            print("\nExisting Users (Top 5):")
            for user in db.query(User).limit(5).all():
                role_name = user.role.name if user.role else "No Role"
                print(f"- Email: {user.email}, Role: {role_name}")
        else:
            print("\nNo users found. setup-admin should be available.")

    except Exception as e:
        print(f"Error checking state: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    check_system_state()
