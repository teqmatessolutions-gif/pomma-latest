import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from pathlib import Path

env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path)
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:qwerty123@localhost:5432/pommadb")

engine = create_engine(DATABASE_URL)

def run_migration():
    with engine.connect() as conn:
        print("Starting database migration for bookings table...")
        
        try:
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS source VARCHAR"))
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS external_id VARCHAR"))
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS external_status VARCHAR"))
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS num_rooms INTEGER"))
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS package_name VARCHAR"))
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS is_confirmed BOOLEAN DEFAULT FALSE"))
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS confirmed_at TIMESTAMP"))
            
            print("bookings table updated successfully.")
        except Exception as e:
            print(f"Error updating table: {e}")

        conn.commit()
        print("Migration complete.")

if __name__ == "__main__":
    run_migration()
