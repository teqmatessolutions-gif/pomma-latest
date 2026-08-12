import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from pathlib import Path

env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path)
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:qwerty123@localhost:5432/pommadb")

engine = create_engine(DATABASE_URL)

def fix_rate_plan_mappings():
    with engine.connect() as conn:
        print("Fixing rate_plan_mappings table...")
        try:
            # Drop the old aiosell_id column if it still exists
            conn.execute(text("ALTER TABLE rate_plan_mappings DROP COLUMN IF EXISTS aiosell_id"))
            # Add the new channel_manager_id column
            conn.execute(text("ALTER TABLE rate_plan_mappings ADD COLUMN IF NOT EXISTS channel_manager_id VARCHAR"))
            print("Successfully added channel_manager_id")
        except Exception as e:
            print(f"Error: {e}")
        conn.commit()

if __name__ == "__main__":
    fix_rate_plan_mappings()
