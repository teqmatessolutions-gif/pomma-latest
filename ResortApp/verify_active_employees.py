from app.database import SessionLocal
from app.models.employee import Employee
from app.models.user import User

db = SessionLocal()
try:
    count = db.query(Employee).join(User).filter(User.is_active == True).count()
    print(f"Active Employees Count: {count}")
    
    # List them to be sure
    employees = db.query(Employee).join(User).filter(User.is_active == True).all()
    print("Active Employees:")
    for emp in employees:
        print(f" - {emp.name} (User Active: {emp.user.is_active})")
        
except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
