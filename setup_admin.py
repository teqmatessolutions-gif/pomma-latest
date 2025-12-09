import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from passlib.context import CryptContext
from sqlalchemy import create_engine, text

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

with engine.connect() as conn:
    # Check roles table columns
    cols = conn.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name = 'roles'")).fetchall()
    print("Roles table columns:", [c[0] for c in cols])
    
    # Create Admin role
    role = conn.execute(text("INSERT INTO roles (name) VALUES ('Admin') RETURNING id, name"))
    conn.commit()
    role_data = role.fetchone()
    print(f"Created role: ID={role_data[0]}, Name={role_data[1]}")
    
    # Create password hash
    hashed_password = pwd_context.hash("admin123")
    
    # Create admin user
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
        "role_id": role_data[0]
    })
    conn.commit()
    
    user = result.fetchone()
    print("\n" + "="*50)
    print("SUCCESS! ADMIN USER CREATED")
    print("="*50)
    print(f"User ID: {user[0]}")
    print(f"Name: {user[1]}")
    print(f"Email: {user[2]}")
    print(f"\nLOGIN CREDENTIALS:")
    print(f"  Email: admin@resort.com")
    print(f"  Password: admin123")
    print("="*50)
    print("\nNow you can login at:")
    print("  http://localhost:3000/pommaadmin")

