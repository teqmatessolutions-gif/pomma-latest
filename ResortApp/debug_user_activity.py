import sys
from sqlalchemy import create_engine, text

# Load env safely
db_url = None
try:
    with open(".env", "r", encoding="utf-8-sig") as f:
        for line in f:
            if line.startswith("DATABASE_URL="):
                db_url = line.strip().split("=", 1)[1]
                break
except:
    pass

if not db_url:
    print("Error: DATABASE_URL not found")
    sys.exit(1)

engine = create_engine(db_url)

def check_activity_links():
    with engine.connect() as conn:
        print("--- Checking User Activity Links ---")
        
        # 1. Find User 'daion'
        user = conn.execute(text("SELECT id, name, role FROM users WHERE name ILIKE '%daion%'")).mappings().first()
        if not user:
            print("User 'daion' not found.")
            return
        
        user_id = user.id
        print(f"User: {user.name} (ID: {user_id}, Role: {user.role})")
        
        # 2. Check Bookings
        b_count = conn.execute(text("SELECT COUNT(*) FROM bookings WHERE user_id = :uid"), {"uid": user_id}).scalar()
        pb_count = conn.execute(text("SELECT COUNT(*) FROM package_bookings WHERE user_id = :uid"), {"uid": user_id}).scalar()
        print(f"Bookings created: {b_count}")
        print(f"Package Bookings created: {pb_count}")
        
        # 3. Check Food Orders (assigned_employee_id)
        # Also check if there are ANY food orders and what their employee IDs are
        fo_count = conn.execute(text("SELECT COUNT(*) FROM food_orders WHERE assigned_employee_id = :uid"), {"uid": user_id}).scalar()
        print(f"Food Orders assigned to ID {user_id}: {fo_count}")
        
        # Sample of Food Orders to see who IS assigned
        print("\nSample Food Order Assignments:")
        samples = conn.execute(text("SELECT id, assigned_employee_id FROM food_orders ORDER BY id DESC LIMIT 5")).mappings().all()
        for s in samples:
            print(f"  Order {s.id}: assigned_employee_id={s.assigned_employee_id}")

        # 4. Check Services (employee_id)
        svc_count = conn.execute(text("SELECT COUNT(*) FROM assigned_services WHERE employee_id = :uid"), {"uid": user_id}).scalar()
        print(f"\nServices assigned to ID {user_id}: {svc_count}")
        
        print("\nSample Service Assignments:")
        samples = conn.execute(text("SELECT id, employee_id FROM assigned_services ORDER BY id DESC LIMIT 5")).mappings().all()
        for s in samples:
            print(f"  Service {s.id}: employee_id={s.employee_id}")

if __name__ == "__main__":
    check_activity_links()
