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

engine = create_engine(db_url)

with engine.connect() as conn:
    print("--- ID MAPPING CHECK ---")
    user = conn.execute(text("SELECT id, name FROM users WHERE name ILIKE '%daion%'")).mappings().first()
    if user:
        print(f"User: {user.name} (ID: {user.id})")
        emp = conn.execute(text("SELECT id, name, user_id FROM employees WHERE user_id = :uid"), {"uid": user.id}).mappings().first()
        if emp:
            print(f"Employee: {emp.name} (ID: {emp.id}) -> UserID: {emp.user_id}")
            
            # Check counts
            c1 = conn.execute(text("SELECT count(*) FROM food_orders WHERE assigned_employee_id = :eid"), {"eid": emp.id}).scalar()
            c2 = conn.execute(text("SELECT count(*) FROM food_orders WHERE assigned_employee_id = :uid"), {"uid": user.id}).scalar()
            
            print(f"Orders for EmpID {emp.id}: {c1}")
            print(f"Orders for UserID {user.id}: {c2}")
        else:
            print("No linked employee found")
