import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from app.database import engine, Base
from sqlalchemy import text, inspect

print("Checking and updating database schema...")

# Import all models to register them with Base
try:
    from app.models.user import User, Role
    from app.models.room import Room
    from app.models.booking import Booking, BookingRoom
    from app.models.Package import Package, PackageBooking, PackageBookingRoom
    from app.models.checkout import Checkout
    from app.models.employee import Employee
    from app.models.expense import Expense
    from app.models.foodorder import FoodOrder
    from app.models.food_item import FoodItem, FoodCategory
    from app.models.service import Service, AssignedService
    from app.models.payment import Payment
    print("Models imported successfully")
except Exception as e:
    print(f"Some models failed to import: {e}")
    print("Continuing with available models...")

# Drop and recreate all tables to match models
print("\nUpdating tables to match current models...")
Base.metadata.drop_all(bind=engine)
print("Dropped all tables")

Base.metadata.create_all(bind=engine)
print("Created all tables with correct schema")

# Verify
inspector = inspect(engine)
tables = inspector.get_table_names()
print(f"\nTotal tables created: {len(tables)}")

# Check rooms table specifically
rooms_columns = [col['name'] for col in inspector.get_columns('rooms')]
print(f"\nRooms table columns ({len(rooms_columns)}):")
for col in rooms_columns:
    print(f"  - {col}")

print("\nSchema update complete!")
print("\nWARNING: All data was cleared. You need to:")
print("1. Re-run setup_admin.py to create admin user")
print("2. Re-run insert_resort_final.py to add resort info")

