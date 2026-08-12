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
        print("Starting database migration for bookings and package_bookings...")
        
        try:
            # Add display_id to bookings
            conn.execute(text("ALTER TABLE bookings ADD COLUMN IF NOT EXISTS display_id VARCHAR"))
            # Add display_id to package_bookings
            conn.execute(text("ALTER TABLE package_bookings ADD COLUMN IF NOT EXISTS display_id VARCHAR"))
            
            print("tables updated successfully.")
        except Exception as e:
            print(f"Error updating tables: {e}")

        conn.commit()
        print("Migration complete.")

if __name__ == "__main__":
    run_migration()
