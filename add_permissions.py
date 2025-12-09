import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from sqlalchemy import create_engine, text
import json

DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

# All possible permissions
all_permissions = [
    "/dashboard", "/users", "/roles", "/employees", "/attendance",
    "/rooms", "/packages", "/bookings", "/checkouts",
    "/food-categories", "/food-items", "/food-orders",
    "/services", "/expenses", "/payments", "/reports"
]

with engine.connect() as conn:
    # Get Admin role
    role = conn.execute(text("SELECT id, name, permissions FROM roles WHERE name = 'Admin'")).fetchone()
    
    if role:
        print(f"Found Admin role (ID: {role[0]})")
        print(f"Current permissions: {role[2]}")
        
        # Update permissions
        conn.execute(text("""
            UPDATE roles 
            SET permissions = :permissions
            WHERE id = :role_id
        """), {
            "permissions": json.dumps(all_permissions),
            "role_id": role[0]
        })
        conn.commit()
        
        print(f"\nUPDATED! Admin now has {len(all_permissions)} permissions:")
        for perm in all_permissions:
            print(f"  - {perm}")
        
        # Verify user has this role
        user = conn.execute(text("SELECT id, name, email, role_id FROM users WHERE email = 'admin@resort.com'")).fetchone()
        if user:
            print(f"\nUser '{user[2]}' has role_id: {user[3]}")
            if user[3] == role[0]:
                print("SUCCESS! User is linked to Admin role with full permissions!")
            else:
                print("WARNING: User role_id doesn't match Admin role!")
        
    else:
        print("Admin role not found!")

