import sys
from app.database import engine
from sqlalchemy import text

def add_column():
    with engine.begin() as conn:
        try:
            conn.execute(text("ALTER TABLE bookings ADD COLUMN advance_amount FLOAT DEFAULT 0.0;"))
            print("Column advance_amount added to bookings table.")
        except Exception as e:
            print(f"Error adding column: {e}")

if __name__ == "__main__":
    add_column()
