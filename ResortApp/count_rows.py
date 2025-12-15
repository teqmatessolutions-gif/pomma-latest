from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.booking import Booking
from app.models.Package import PackageBooking
from app.models.service import AssignedService
from app.models.foodorder import FoodOrder
from app.models.expense import Expense
from app.models.checkout import Checkout

def count_tables():
    db: Session = SessionLocal()
    try:
        b_count = db.query(Booking).count()
        pb_count = db.query(PackageBooking).count()
        as_count = db.query(AssignedService).count()
        fo_count = db.query(FoodOrder).count()
        e_count = db.query(Expense).count()
        c_count = db.query(Checkout).count()

        print(f"Bookings: {b_count}")
        print(f"Package Bookings: {pb_count}")
        print(f"Assigned Services: {as_count}")
        print(f"Food Orders: {fo_count}")
        print(f"Expenses: {e_count}")
        print(f"Checkouts: {c_count}")
        
    finally:
        db.close()

if __name__ == "__main__":
    count_tables()
