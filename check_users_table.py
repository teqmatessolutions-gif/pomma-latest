import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from sqlalchemy import create_engine, text

DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

with engine.connect() as conn:
    # Get table structure
    result = conn.execute(text("""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'users'
        ORDER BY ordinal_position
    """))
    
    print("Users table structure:")
    print("-" * 50)
    for row in result:
        print(f"{row[0]}: {row[1]}")

