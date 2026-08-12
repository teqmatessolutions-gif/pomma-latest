import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from pathlib import Path

env_path = Path(__file__).parent / ".env"
load_dotenv(dotenv_path=env_path)
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:qwerty123@localhost:5432/pommadb")

engine = create_engine(DATABASE_URL)

def run_sanitize():
    with engine.connect() as conn:
        print("Starting data sanitization for rate_plan_mappings...")
        
        try:
            # Update all NULL channel_manager_id values to empty strings
            result = conn.execute(text("UPDATE rate_plan_mappings SET channel_manager_id = '' WHERE channel_manager_id IS NULL"))
            print(f"Updated {result.rowcount} rows in rate_plan_mappings.")
        except Exception as e:
            print(f"Error updating table: {e}")

        conn.commit()
        print("Sanitization complete.")

if __name__ == "__main__":
    run_sanitize()
