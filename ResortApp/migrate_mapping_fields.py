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
        print("Starting database migration...")
        
        # 1. Update rate_plan_mappings table
        print("Updating rate_plan_mappings table...")
        try:
            # Check if columns exist before adding
            conn.execute(text("ALTER TABLE rate_plan_mappings ADD COLUMN IF NOT EXISTS package_id INTEGER REFERENCES packages(id)"))
            conn.execute(text("ALTER TABLE rate_plan_mappings ADD COLUMN IF NOT EXISTS price_offset DOUBLE PRECISION DEFAULT 0.0"))
            conn.execute(text("ALTER TABLE rate_plan_mappings ADD COLUMN IF NOT EXISTS offset_percentage DOUBLE PRECISION DEFAULT 0.0"))
            conn.execute(text("ALTER TABLE rate_plan_mappings ADD COLUMN IF NOT EXISTS fixed_offset DOUBLE PRECISION DEFAULT 0.0"))
            
            # Make room_id nullable
            conn.execute(text("ALTER TABLE rate_plan_mappings ALTER COLUMN room_id DROP NOT NULL"))
            
            print("rate_plan_mappings table updated successfully.")
        except Exception as e:
            print(f"Error updating rate_plan_mappings: {e}")

        # 2. Update packages table
        print("Updating packages table...")
        try:
            conn.execute(text("ALTER TABLE packages ADD COLUMN IF NOT EXISTS channel_manager_id VARCHAR"))
            conn.execute(text("ALTER TABLE packages ADD COLUMN IF NOT EXISTS online_inventory INTEGER"))
            conn.execute(text("ALTER TABLE packages ADD COLUMN IF NOT EXISTS min_stay INTEGER DEFAULT 1"))
            conn.execute(text("ALTER TABLE packages ADD COLUMN IF NOT EXISTS cta BOOLEAN DEFAULT FALSE"))
            conn.execute(text("ALTER TABLE packages ADD COLUMN IF NOT EXISTS ctd BOOLEAN DEFAULT FALSE"))
            
            print("packages table updated successfully.")
        except Exception as e:
            print(f"Error updating packages: {e}")

        conn.commit()
        print("Migration complete.")

if __name__ == "__main__":
    run_migration()
