from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
from app.database import SessionLocal
from app.models.booking import Booking

load_dotenv()

db = SessionLocal()
print("Attempting to query Booking model...")
try:
    booking = db.query(Booking).first()
    print("Success!")
except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
