
from app.database import SessionLocal
from app.models.booking import Booking
from sqlalchemy import text

def verify_query():
    db = SessionLocal()
    try:
        print("Testing basic Booking query...")
        bookings = db.query(Booking).limit(5).all()
        print(f"Successfully fetched {len(bookings)} bookings.")
        for b in bookings:
            print(f"ID: {b.id}, Guest: {b.guest_name}")
    except Exception as e:
        print(f"Query failed: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    verify_query()
