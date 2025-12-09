import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from passlib.context import CryptContext
from sqlalchemy import create_engine, text

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Database connection
DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

# Create password hash
password = "admin123"
hashed_password = pwd_context.hash(password)

print(f"Generated hash for password 'admin123'")
print(f"Hash: {hashed_password}\n")

with engine.connect() as conn:
    # Delete existing admin user if exists
    conn.execute(text("DELETE FROM users WHERE email = 'admin@resort.com'"))
    conn.commit()
    print("[OK] Deleted existing admin user (if any)\n")
    
    # Get Admin role_id (or create if not exists)
    role_result = conn.execute(text("""
        SELECT id FROM roles WHERE LOWER(name) = 'admin' LIMIT 1
    """))
    role_row = role_result.fetchone()
    
    if not role_row:
        # Create Admin role
        role_result = conn.execute(text("""
            INSERT INTO roles (name, description)
            VALUES ('Admin', 'Administrator role')
            RETURNING id
        """))
        conn.commit()
        role_id = role_result.fetchone()[0]
        print(f"[OK] Created Admin role with ID: {role_id}\n")
    else:
        role_id = role_row[0]
        print(f"[OK] Found Admin role with ID: {role_id}\n")
    
    # Insert new admin user
    result = conn.execute(text("""
        INSERT INTO users (
            name, 
            email, 
            hashed_password, 
            phone, 
            is_active, 
            role_id
        ) VALUES (
            :name,
            :email,
            :hashed_password,
            :phone,
            :is_active,
            :role_id
        )
        RETURNING id, name, email
    """), {
        "name": "Admin User",
        "email": "admin@resort.com",
        "hashed_password": hashed_password,
        "phone": "1234567890",
        "is_active": True,
        "role_id": role_id
    })
    conn.commit()
    
    user = result.fetchone()
    print("="*50)
    print("SUCCESS! ADMIN USER CREATED")
    print("="*50)
    print(f"ID: {user[0]}")
    print(f"Name: {user[1]}")
    print(f"Email: {user[2]}")
    print(f"\nLOGIN CREDENTIALS:")
    print(f"Email: admin@resort.com")
    print(f"Password: admin123")
    print("="*50)

