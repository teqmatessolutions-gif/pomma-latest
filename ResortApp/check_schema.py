import os
import sys

# Add the current directory to sys.path so we can import app
sys.path.append(os.getcwd())

from app.database import SessionLocal, engine
from sqlalchemy import inspect

def check_schema():
    try:
        inspector = inspect(engine)
        columns = [c['name'] for c in inspector.get_columns('checkouts')]
        print(f"Columns in 'checkouts' table: {columns}")
        
        required = ['room_total', 'food_total', 'service_total', 'package_total', 'tax_amount', 'grand_total', 'guest_name', 'room_number']
        missing = [c for c in required if c not in columns]
        if missing:
            print(f"MISSING COLUMNS: {missing}")
        else:
            print("All required columns are present.")
            
    except Exception as e:
        print(f"Error checking schema: {e}")

if __name__ == "__main__":
    check_schema()
