import sys
import os
from dotenv import load_dotenv
load_dotenv()
sys.path.append(os.getcwd())
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.checkout import Checkout
from app.database import SQLALCHEMY_DATABASE_URL as DATABASE_URL
from datetime import datetime

# Setup DB connection
try:
    engine = create_engine(DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
except Exception as e:
    # Fallback if dotenv fails
    print(f"Connection failed: {e}")
    DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
    engine = create_engine(DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()

def create_checkout_37():
    print("Attempting to create Checkout ID 37...")
    existing = db.query(Checkout).filter(Checkout.id == 37).first()
    if existing:
        print("Checkout 37 ALREADY EXISTS!")
        print(f" - Room: {existing.room_number}")
        print(f" - PDF: {existing.pdf_url}")
    else:
        print("Creating Checkout 37...")
        # Create a dummy checkout
        new_c = Checkout(
            id=37,
            room_number="101",
            guest_name="Restored Guest",
            grand_total=1000.0,
            payment_status="Paid",
            created_at=datetime.utcnow(),
            checkout_date=datetime.utcnow()
        )
        try:
            db.add(new_c)
            db.commit()
            print("SUCCESS: Checkout 37 created.")
        except Exception as e:
            print(f"FAILED to create: {e}")
            db.rollback()

if __name__ == "__main__":
    create_checkout_37()
