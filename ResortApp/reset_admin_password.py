"""
Reset Admin Password Script
This script will reset the admin user's password to 'admin123'
"""
import sys
sys.path.insert(0, '.')

from app.database import SessionLocal
from app.models.user import User
from app.utils.auth import get_password_hash

def reset_admin_password():
    db = SessionLocal()
    try:
        # Find admin user by email
        admin_user = db.query(User).filter(User.email == "admin@teqmates.com").first()
        
        if not admin_user:
            print("❌ Admin user not found with email: admin@teqmates.com")
            print("\nLet me check all users in the database:")
            all_users = db.query(User).all()
            if not all_users:
                print("No users found in database!")
            else:
                print(f"\nFound {len(all_users)} user(s):")
                for user in all_users:
                    print(f"  - Email: {user.email}, Name: {user.name}, Active: {user.is_active}, Role ID: {user.role_id}")
            return False
        
        # Reset password
        new_password = "admin123"
        admin_user.hashed_password = get_password_hash(new_password)
        admin_user.is_active = True  # Ensure user is active
        
        db.commit()
        print(f"✅ Password reset successfully for: {admin_user.email}")
        print(f"   Name: {admin_user.name}")
        print(f"   Active: {admin_user.is_active}")
        print(f"   Role ID: {admin_user.role_id}")
        print(f"\n   New password: {new_password}")
        return True
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        db.rollback()
        return False
    finally:
        db.close()

if __name__ == "__main__":
    print("=" * 50)
    print("Admin Password Reset Tool")
    print("=" * 50)
    print()
    
    success = reset_admin_password()
    
    if success:
        print("\n" + "=" * 50)
        print("✅ You can now login with:")
        print("   Email: admin@teqmates.com")
        print("   Password: admin123")
        print("=" * 50)
    else:
        print("\n" + "=" * 50)
        print("❌ Password reset failed!")
        print("=" * 50)
