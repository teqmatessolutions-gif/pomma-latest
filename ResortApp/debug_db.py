from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv

load_dotenv()
db_url = os.getenv("DATABASE_URL")
engine = create_engine(db_url)

print(f"Testing connection to: {db_url}")
try:
    with engine.connect() as conn:
        result = conn.execute(text("SELECT * FROM bookings LIMIT 1"))
        print("Success! Columns in bookings table:")
        print(result.keys())
except Exception as e:
    print(f"Error: {e}")
