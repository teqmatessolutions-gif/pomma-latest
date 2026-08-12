import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from pathlib import Path

# Load database URL
env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path)
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:qwerty123@localhost:5432/pommadb")

engine = create_engine(DATABASE_URL)

def run_migration():
    with engine.connect() as conn:
        print("Starting database migration for rooms table...")
        
        try:
            conn.execute(text("ALTER TABLE rooms ADD COLUMN IF NOT EXISTS channel_manager_id VARCHAR"))
            conn.execute(text("ALTER TABLE rooms ADD COLUMN IF NOT EXISTS online_inventory INTEGER"))
            conn.execute(text("ALTER TABLE rooms ADD COLUMN IF NOT EXISTS min_stay INTEGER DEFAULT 1"))
            conn.execute(text("ALTER TABLE rooms ADD COLUMN IF NOT EXISTS cta BOOLEAN DEFAULT FALSE"))
            conn.execute(text("ALTER TABLE rooms ADD COLUMN IF NOT EXISTS ctd BOOLEAN DEFAULT FALSE"))
            
            print("rooms table updated successfully.")
        except Exception as e:
            print(f"Error updating rooms table: {e}")

        conn.commit()
        print("Migration complete.")

if __name__ == "__main__":
    run_migration()
