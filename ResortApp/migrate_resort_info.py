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
        print("Starting database migration for resort_info...")
        
        try:
            conn.execute(text("ALTER TABLE resort_info ADD COLUMN IF NOT EXISTS hotel_code VARCHAR"))
            print("resort_info table updated successfully.")
        except Exception as e:
            print(f"Error updating table: {e}")

        conn.commit()
        print("Migration complete.")

if __name__ == "__main__":
    run_migration()
