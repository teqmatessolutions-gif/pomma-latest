from app.database import engine
from sqlalchemy import text

def run_migration():
    with engine.connect() as conn:
        print("Starting migration for resort_info table...")
        try:
            # Using Postgres IF NOT EXISTS syntax for safety
            queries = [
                "ALTER TABLE resort_info ADD COLUMN IF NOT EXISTS gst_no VARCHAR(50);",
                "ALTER TABLE resort_info ADD COLUMN IF NOT EXISTS email VARCHAR(100);",
                "ALTER TABLE resort_info ADD COLUMN IF NOT EXISTS support_email VARCHAR(100);",
                "ALTER TABLE resort_info ADD COLUMN IF NOT EXISTS contact_no VARCHAR(20);",
                "ALTER TABLE resort_info ADD COLUMN IF NOT EXISTS property_location VARCHAR(255);"
            ]
            
            for q in queries:
                print(f"Executing: {q}")
                conn.execute(text(q))
                
            conn.commit()
            print("Migration completed successfully.")
        except Exception as e:
            print(f"Migration failed or columns already exist: {e}")
            # If it failed, it might be SQLite or older Postgres?
            # But we expect Postgres.
            # If it's SQLite, syntax is slightly different (no IF NOT EXISTS for ADD COLUMN in older versions usually).
            # But let's assume Postgres as per config.

if __name__ == "__main__":
    run_migration()
