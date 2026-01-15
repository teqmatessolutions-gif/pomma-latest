from app.database import engine, Base
from app.models.booking import CheckInDocument

print("Creating checkin_documents table...")
Base.metadata.create_all(bind=engine)
print("Table created successfully.")
