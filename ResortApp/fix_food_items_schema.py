"""
Fix food_items table schema - change price to FLOAT and available to BOOLEAN

This script updates the food_items table to match the correct data types.
"""

from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost/pommadb")
engine = create_engine(DATABASE_URL)

def fix_food_items_schema():
    with engine.connect() as conn:
        print("Starting food_items schema fix...")
        
        # Start transaction
        trans = conn.begin()
        
        try:
            # Check if table exists
            result = conn.execute(text("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_name = 'food_items'
                );
            """))
            table_exists = result.scalar()
            
            if not table_exists:
                print("food_items table does not exist. Skipping migration.")
                trans.rollback()
                return
            
            # Alter price column from INTEGER to FLOAT
            print("Converting price column from INTEGER to FLOAT...")
            conn.execute(text("""
                ALTER TABLE food_items 
                ALTER COLUMN price TYPE DOUBLE PRECISION 
                USING price::DOUBLE PRECISION;
            """))
            
            # Alter available column from VARCHAR to BOOLEAN
            print("Converting available column from VARCHAR to BOOLEAN...")
            conn.execute(text("""
                ALTER TABLE food_items 
                ALTER COLUMN available TYPE BOOLEAN 
                USING CASE 
                    WHEN available IN ('true', 't', 'yes', 'y', '1', 'True') THEN TRUE
                    WHEN available IN ('false', 'f', 'no', 'n', '0', 'False') THEN FALSE
                    ELSE TRUE
                END;
            """))
            
            # Set default value for available column
            print("Setting default value for available column...")
            conn.execute(text("""
                ALTER TABLE food_items 
                ALTER COLUMN available SET DEFAULT TRUE;
            """))
            
            trans.commit()
            print("✅ Successfully updated food_items table schema!")
            
        except Exception as e:
            trans.rollback()
            print(f"❌ Error updating schema: {e}")
            raise

if __name__ == "__main__":
    fix_food_items_schema()
