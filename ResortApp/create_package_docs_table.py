from app.database import engine, Base
from app.models.Package import PackageCheckInDocument, PackageBooking
import sqlalchemy

try:
    # Create the table
    print("Creating package_checkin_documents table...")
    PackageCheckInDocument.__table__.create(engine)
    print("Table created successfully!")
except sqlalchemy.exc.ProgrammingError as e:
    if "already exists" in str(e):
        print("Table 'package_checkin_documents' already exists.")
    else:
        print(f"Error creating table: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
