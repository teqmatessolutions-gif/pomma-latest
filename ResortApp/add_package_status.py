from app.database import engine
from sqlalchemy import text
import sys
import os

# Ensure package root is in path
sys.path.insert(0, os.getcwd())

def add_column():
    with engine.connect() as conn:
        try:
            # Check if column exists (Postgres specific check, or just try-except)
            conn.execute(text("ALTER TABLE packages ADD COLUMN status VARCHAR DEFAULT 'Available'"))
            conn.commit()
            print("Successfully added status column.")
        except Exception as e:
            print(f"Error adding column (might already exist): {e}")

if __name__ == "__main__":
    add_column()
