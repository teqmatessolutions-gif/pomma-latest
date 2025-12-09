#!/usr/bin/env python3
"""
Fix admin user permissions in local database
"""
import sys
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Database connection
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:qwerty123@localhost:5432/pommadb")

print(f"Connecting to database: {DATABASE_URL}")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

try:
    # Check current admin role permissions
    print("\n=== Checking Admin Role Permissions ===")
    result = db.execute(text("""
        SELECT id, name, permissions 
        FROM roles 
        WHERE LOWER(name) = 'admin'
    """))
    admin_role = result.fetchone()
    
    if admin_role:
        print(f"Admin Role ID: {admin_role[0]}")
        print(f"Admin Role Name: {admin_role[1]}")
        print(f"Current Permissions: {admin_role[2]}")
        
        # Update admin permissions to have ALL permissions (wildcard)
        print("\n=== Updating Admin Permissions to '*' (all permissions) ===")
        db.execute(text("""
            UPDATE roles 
            SET permissions = '["*"]'
            WHERE LOWER(name) = 'admin'
        """))
        db.commit()
        print("✓ Admin permissions updated to ['*']")
        
        # Verify the update
        result = db.execute(text("""
            SELECT permissions 
            FROM roles 
            WHERE LOWER(name) = 'admin'
        """))
        new_permissions = result.fetchone()[0]
        print(f"✓ New permissions: {new_permissions}")
        
    else:
        print("❌ Admin role not found!")
        print("Creating Admin role with all permissions...")
        db.execute(text("""
            INSERT INTO roles (name, permissions, created_at, updated_at)
            VALUES ('Admin', '["*"]', NOW(), NOW())
        """))
        db.commit()
        print("✓ Admin role created with ['*'] permissions")
    
    # Check admin user
    print("\n=== Checking Admin User ===")
    result = db.execute(text("""
        SELECT u.id, u.email, u.role_id, r.name as role_name, r.permissions
        FROM users u
        LEFT JOIN roles r ON u.role_id = r.id
        WHERE u.email = 'admin@resort.com'
    """))
    admin_user = result.fetchone()
    
    if admin_user:
        print(f"User ID: {admin_user[0]}")
        print(f"Email: {admin_user[1]}")
        print(f"Role ID: {admin_user[2]}")
        print(f"Role Name: {admin_user[3]}")
        print(f"Permissions: {admin_user[4]}")
        
        if admin_user[4] != '["*"]':
            print("\n⚠️ Admin user doesn't have wildcard permissions!")
            print("This should be fixed now.")
    else:
        print("❌ Admin user not found!")
        print("Run setup_admin.py to create admin user")
    
    print("\n" + "="*50)
    print("✅ Admin permissions fixed!")
    print("="*50)
    print("\nNext steps:")
    print("1. Logout from the admin dashboard")
    print("2. Login again with: admin@resort.com / admin123")
    print("3. Try creating a role again")
    print("\nThe token needs to be refreshed to include new permissions.")
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
    db.rollback()
finally:
    db.close()

