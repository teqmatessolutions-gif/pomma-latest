from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
from sqlalchemy.orm import joinedload
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.user import User

load_dotenv()

db = SessionLocal()
print("Attempting to query Booking model with joinedload...")
try:
    booking = db.query(Booking).options(
        joinedload(Booking.booking_rooms).joinedload(BookingRoom.room),
        joinedload(Booking.user)
    ).first()
    print("Success!")
except Exception as e:
    import traceback
    print(f"Error: {e}")
    traceback.print_exc()
finally:
    db.close()
