"""
Add priority column to packages table
"""
from sqlalchemy import create_engine, text

# Database URL - update if different
DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"

# Create engine
engine = create_engine(DATABASE_URL)

# SQL to add priority column
add_column_sql = """
ALTER TABLE packages 
ADD COLUMN IF NOT EXISTS priority INTEGER;
"""

# SQL to add comment
comment_sql = """
COMMENT ON COLUMN packages.priority IS 'Display order priority (1 = first, 2 = second, etc. NULL = last)';
"""

try:
    with engine.connect() as conn:
        # Add column
        print("Adding priority column to packages table...")
        conn.execute(text(add_column_sql))
        conn.commit()
        print("✓ Priority column added successfully")
        
        # Add comment
        try:
            conn.execute(text(comment_sql))
            conn.commit()
            print("✓ Column comment added")
        except Exception as e:
            print(f"Note: Could not add comment (non-critical): {e}")
        
        # Verify column was added
        verify_sql = """
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'packages' AND column_name = 'priority';
        """
        result = conn.execute(text(verify_sql))
        row = result.fetchone()
        
        if row:
            print(f"\n✓ Verification successful:")
            print(f"  Column: {row[0]}")
            print(f"  Type: {row[1]}")
            print(f"  Nullable: {row[2]}")
        else:
            print("\n✗ Verification failed: Column not found")
            
except Exception as e:
    print(f"\n✗ Error: {e}")
    exit(1)

print("\n✓ Migration completed successfully!")
