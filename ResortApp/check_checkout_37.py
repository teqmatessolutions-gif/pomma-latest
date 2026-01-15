import sys
import os
from dotenv import load_dotenv
load_dotenv() # Load from current directory
sys.path.append(os.getcwd())
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.checkout import Checkout
from app.database import SQLALCHEMY_DATABASE_URL as DATABASE_URL

# Setup DB connection
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

def check_checkout(checkout_id):
    print(f"Checking for Checkout ID: {checkout_id}")
    checkout = db.query(Checkout).filter(Checkout.id == checkout_id).first()
    if checkout:
        print(f"FOUND: Checkout {checkout.id}")
        print(f" - Guest: {checkout.guest_name}")
        print(f" - Room: {checkout.room_number}")
        print(f" - Total: {checkout.grand_total}")
        print(f" - PDF URL: {checkout.pdf_url}")
    else:
        print(f"NOT FOUND: Checkout ID {checkout_id} does not exist.")


    # List last 10 checkouts
    print("\nLast 10 Checkouts:")
    last_10 = db.query(Checkout).order_by(Checkout.id.desc()).limit(10).all()
    for c in last_10:
        print(f"ID: {c.id} | Room: {c.room_number} | Guest: {c.guest_name}")

if __name__ == "__main__":
    check_checkout(37)
