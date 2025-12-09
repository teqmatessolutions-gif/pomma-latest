import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from app.database import engine, Base
from sqlalchemy import text

print("Checking database connection...")
try:
    with engine.connect() as conn:
        result = conn.execute(text("SELECT version()"))
        version = result.fetchone()[0]
        print(f"Connected to PostgreSQL: {version[:50]}...")
        
        # Check existing tables
        result = conn.execute(text("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
            ORDER BY table_name
        """))
        tables = [r[0] for r in result]
        print(f"\nExisting tables ({len(tables)}):")
        for table in tables:
            print(f"  - {table}")
        
        print("\nCreating/updating tables from models...")
        Base.metadata.create_all(bind=engine)
        print("Tables created successfully!")
        
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()

