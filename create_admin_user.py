import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from passlib.context import CryptContext
from sqlalchemy import create_engine, text
from datetime import datetime

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Database connection
DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

# Create password hash
password = "admin123"
hashed_password = pwd_context.hash(password)

print(f"Generated hash for password 'admin123': {hashed_password}")

# Insert user
with engine.connect() as conn:
    # Delete existing admin user if exists
    conn.execute(text("DELETE FROM users WHERE email = 'admin@resort.com'"))
    conn.commit()
    
    # Insert new admin user
    result = conn.execute(text("""
        INSERT INTO users (
            username, 
            email, 
            hashed_password, 
            full_name, 
            is_active, 
            is_superuser,
            created_at
        ) VALUES (
            :username,
            :email,
            :hashed_password,
            :full_name,
            :is_active,
            :is_superuser,
            :created_at
        )
        RETURNING id, username, email
    """), {
        "username": "admin",
        "email": "admin@resort.com",
        "hashed_password": hashed_password,
        "full_name": "Admin User",
        "is_active": True,
        "is_superuser": True,
        "created_at": datetime.now()
    })
    conn.commit()
    
    user = result.fetchone()
    print(f"\n✅ User created successfully!")
    print(f"ID: {user[0]}")
    print(f"Username: {user[1]}")
    print(f"Email: {user[2]}")
    print(f"\n🔑 Login with:")
    print(f"Email: admin@resort.com")
    print(f"Password: admin123")

