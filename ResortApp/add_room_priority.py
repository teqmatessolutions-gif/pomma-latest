import os
import sys
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

# Load env variables
env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path)

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    print("DATABASE_URL not found in .env, checking default...")
    # Default used in database.py
    DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"

def add_column():
    print(f"Connecting to database...")
    engine = create_engine(DATABASE_URL)
    with engine.connect() as conn:
        conn.execute(text("COMMIT")) # Ensure no transaction block
        try:
             print("Attempting to add 'priority' column to 'rooms' table...")
             conn.execute(text("ALTER TABLE rooms ADD COLUMN priority INTEGER DEFAULT NULL"))
             print("Success: Added 'priority' column.")
        except Exception as e:
             if "duplicate column" in str(e):
                 print("Column 'priority' already exists.")
             else:
                 print(f"Error adding column: {e}")

if __name__ == "__main__":
    add_column()
