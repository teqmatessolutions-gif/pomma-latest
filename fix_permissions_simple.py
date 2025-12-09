import sys
import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:qwerty123@localhost:5432/pommadb")
engine = create_engine(DATABASE_URL)
conn = engine.connect()

try:
    # Update admin permissions to wildcard
    conn.execute(text("UPDATE roles SET permissions = '[\"*\"]' WHERE LOWER(name) = 'admin'"))
    conn.commit()
    print("SUCCESS: Admin permissions updated to wildcard [*]")
    
    # Verify
    result = conn.execute(text("SELECT name, permissions FROM roles WHERE LOWER(name) = 'admin'"))
    row = result.fetchone()
    print(f"Role: {row[0]}")
    print(f"Permissions: {row[1]}")
    print("")
    print("IMPORTANT: You must LOGOUT and LOGIN again for changes to take effect!")
    print("The JWT token needs to be refreshed with new permissions.")
    
except Exception as e:
    print(f"ERROR: {e}")
    conn.rollback()
finally:
    conn.close()

