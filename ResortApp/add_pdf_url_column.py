from sqlalchemy import create_engine, text
from app.database import SQLALCHEMY_DATABASE_URL

def add_pdf_url_column():
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    with engine.connect() as conn:
        try:
            # Check if column exists
            result = conn.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name='checkouts' AND column_name='pdf_url'"))
            if result.fetchone():
                print("Column 'pdf_url' already exists in 'checkouts' table.")
            else:
                print("Adding 'pdf_url' column to 'checkouts' table...")
                conn.execute(text("ALTER TABLE checkouts ADD COLUMN pdf_url VARCHAR"))
                conn.commit()
                print("Successfully added 'pdf_url' column.")
        except Exception as e:
            print(f"Error adding column: {e}")

if __name__ == "__main__":
    add_pdf_url_column()
