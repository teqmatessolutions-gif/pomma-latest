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

def check_schema_and_ids():
    with engine.connect() as conn:
        print("--- Checking DB Schema ---")
        
        # 1. Check FoodOrders Columns
        print("Food Orders Columns:")
        cols = conn.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name = 'food_orders'")).fetchall()
        print([c[0] for c in cols])
        
        # 2. Check Employee Table
        print("\n--- Checking Employee Mapping ---")
        # Find User 'daion'
        user = conn.execute(text("SELECT id, name FROM users WHERE name ILIKE '%daion%'")).mappings().first()
        if user:
            print(f"User found: {user.name} (ID: {user.id})")
            
            # Find Employee linked to this User
            emp = conn.execute(text("SELECT id, name, user_id FROM employees WHERE user_id = :uid"), {"uid": user.id}).mappings().first()
            if emp:
                print(f"Linked Employee: {emp.name} (ID: {emp.id}) -> User ID: {emp.user_id}")
                
                # Check Food Orders for THIS Employee ID
                count = conn.execute(text("SELECT COUNT(*) FROM food_orders WHERE assigned_employee_id = :eid"), {"eid": emp.id}).scalar()
                print(f"Food Orders for Employee ID {emp.id}: {count}")
                
                # Check using User ID (The BUG assumption)
                count_bug = conn.execute(text("SELECT COUNT(*) FROM food_orders WHERE assigned_employee_id = :uid"), {"uid": user.id}).scalar()
                print(f"Food Orders for User ID {user.id} (Old Logic): {count_bug}")
                
            else:
                 print("No Employee record found linked to this User ID!")
                 
                 # Maybe name match?
                 emp_name = conn.execute(text("SELECT id, name, user_id FROM employees WHERE name ILIKE '%daion%'")).mappings().first()
                 if emp_name:
                     print(f"Employee found by name 'daion': ID {emp_name.id}, UserID: {emp_name.user_id}")
        else:
            print("User 'daion' not found")

if __name__ == "__main__":
    check_schema_and_ids()
