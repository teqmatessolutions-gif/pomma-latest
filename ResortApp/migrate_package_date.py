from sqlalchemy import create_engine, text
from app.database import SQLALCHEMY_DATABASE_URL
import os

def migrate():
    print(f"Connecting to database...")
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    
    with engine.connect() as connection:
        # Check if column exists
        try:
            # Postgres syntax to add column if not exists
            # Note: 'IF NOT EXISTS' for ADD COLUMN is only supported in newer Postgres versions (9.6+)
            # But standard SQL usually requires checking first or just catching the error.
            # We will use a safe approach: try adding it, ignore if it complains it exists.
            
            stmt = text("ALTER TABLE packages ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();")
            connection.execute(stmt)
            connection.commit()
            print("Successfully added 'created_at' column to 'packages' table.")
            
            # Backfill nulls if any (though DEFAULT NOW() handles new rows, existing rows get the default value with ADD COLUMN)
            # In Postgres, adding a column with a default fills it for existing rows.
            
        except Exception as e:
            print(f"Error during migration: {e}")

if __name__ == "__main__":
    migrate()
