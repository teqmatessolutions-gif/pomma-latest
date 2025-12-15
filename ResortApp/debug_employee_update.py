import sys
import os
sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.employee import Employee
from app.models.user import User, Role

def check_employee_update_issues(employee_id, role_name):
    db = SessionLocal()
    try:
        print(f"Checking Employee ID: {employee_id}")
        employee = db.query(Employee).filter(Employee.id == employee_id).first()
        if not employee:
            print(f"❌ Employee {employee_id} NOT FOUND in database.")
            # List all employees
            all_emps = db.query(Employee).all()
            print("--- All Employees in DB ---")
            for emp in all_emps:
                print(f"ID: {emp.id}, Name: {emp.name}, Role: {emp.role}")
            print("---------------------------")
        else:
            print(f"✅ Employee {employee_id} found. Name: {employee.name}")
            if not employee.user:
                print(f"❌ Employee {employee_id} has NO associated User account.")
            else:
                print(f"✅ Employee {employee_id} has User account: {employee.user.email}")
        
        print(f"\nChecking Role: '{role_name}'")
        role = db.query(Role).filter(Role.name == role_name).first()
        if not role:
            print(f"❌ Role '{role_name}' NOT FOUND in database.")
            # List available roles
            roles = db.query(Role).all()
            print("Available roles:", [r.name for r in roles])
        else:
            print(f"✅ Role '{role_name}' found. ID: {role.id}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    with open("debug_result.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        check_employee_update_issues(50, "Manager")
        sys.stdout = sys.__stdout__
