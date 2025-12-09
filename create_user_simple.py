import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from passlib.context import CryptContext
from sqlalchemy import create_engine, text

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

password = "admin123"
hashed_password = pwd_context.hash(password)

print(f"Password hash generated\n")

with engine.connect() as conn:
    # Check existing roles
    roles = conn.execute(text("SELECT id, name FROM roles")).fetchall()
    print(f"Existing roles in database:")
    for role in roles:
        print(f"  ID: {role[0]}, Name: {role[1]}")
    
    # Use first role or default to 1
    role_id = roles[0][0] if roles else 1
    print(f"\nUsing role_id: {role_id}\n")
    
    # Delete existing admin
    conn.execute(text("DELETE FROM users WHERE email = 'admin@resort.com'"))
    conn.commit()
    
    # Insert admin user
    result = conn.execute(text("""
        INSERT INTO users (name, email, hashed_password, phone, is_active, role_id)
        VALUES (:name, :email, :hashed_password, :phone, :is_active, :role_id)
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

