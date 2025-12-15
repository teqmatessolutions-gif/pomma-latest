from sqlalchemy.orm import Session
import sys
import os
sys.path.append(os.getcwd())
from app.utils.db import SessionLocal
from app.models.booking import Booking
from app.models.room import Room
import datetime

db = SessionLocal()

today = datetime.date.today()
print(f"Server Today: {today}")

bookings = db.query(Booking).all()
print(f"\nTotal Bookings: {len(bookings)}")

for b in bookings:
    print(f"ID: {b.id}, Guest: {b.guest_name}, Status: '{b.status}', In: {b.check_in}, Out: {b.check_out}")
    is_active_status = b.status in ['booked', 'checked-in', 'checked_in']
    is_date_valid = b.check_in <= today and b.check_out > today
    print(f"  -> Active Status? {is_active_status} | Date Valid? {is_date_valid}")

