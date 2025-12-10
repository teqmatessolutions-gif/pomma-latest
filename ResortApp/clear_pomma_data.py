import sys
import os
from sqlalchemy import create_engine, text

# Using postgres superuser credentials found in .env
DB_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/pommadb"

def clear_data():
    print(f"Connecting to database: pommadb (as postgres)...")
    try:
        engine = create_engine(DB_URL, isolation_level="AUTOCOMMIT")
        connection = engine.connect()
    except Exception as e:
        print(f"❌ Could not connect to pommadb: {e}")
        return

    try:
        # Check current user
        user_result = connection.execute(text("SELECT current_user"))
        print(f"Connected as user: {user_result.scalar()}")
        
        # Get list of all tables
        result = connection.execute(text("SELECT tablename FROM pg_tables WHERE schemaname = 'public'"))
        tables = [row[0] for row in result]
        
        if not tables:
            print("No tables found in public schema in pommadb!")
            return

        print(f"Found {len(tables)} tables.")
        
        # Verify admin exist
        if 'users' in tables:
            res = connection.execute(text("SELECT email FROM users WHERE email='admin@resort.com'"))
            if res.first():
                print("✅ Found existing admin user 'admin@resort.com'.")
            else:
                 print("⚠️ Admin user 'admin@resort.com' NOT found in pommadb users.")

        # Tables to PRESERVE
        tables_to_keep = {'users', 'roles', 'permissions', 'role_permissions', 'alembic_version'}
        tables_to_clear = [t for t in tables if t not in tables_to_keep]
        
        if not tables_to_clear:
            print("No tables to clear.")
            return

        print("\nThe following tables will be CLEARED:")
        for t in tables_to_clear:
            print(f" - {t}")
        
        # Construct TRUNCATE command
        quoted_tables = [f'"{t}"' for t in tables_to_clear]
        truncate_sql = f"TRUNCATE {', '.join(quoted_tables)} RESTART IDENTITY CASCADE;"
        
        print("\nExecuting cleanup...")
        connection.execute(text(truncate_sql))
        
        print("✅ Successfully cleared all data from pommadb.")
            
    except Exception as e:
        print(f"❌ Error during operation: {e}")
    finally:
        connection.close()

if __name__ == "__main__":
    clear_data()
