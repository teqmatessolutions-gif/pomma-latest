from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.employee import Employee, Leave, Attendance, WorkingLog
from app.models.user import User

def clear_non_admin_employees():
    db: Session = SessionLocal()
    try:
        # 1. Identify Admin User
        admin_user = db.query(User).filter(User.email == "admin@orchid.com").first()
        admin_user_id = admin_user.id if admin_user else None
        
        print(f"Admin User ID: {admin_user_id}")

        # 2. Get all Employees
        employees = db.query(Employee).all()
        
        for emp in employees:
            # Check if this employee is the admin
            if emp.user_id == admin_user_id and admin_user_id is not None:
                print(f"Skipping Admin Employee: {emp.name} (ID: {emp.id})")
                continue
            
            print(f"Deleting Employee: {emp.name} (ID: {emp.id})")
            
            # Delete related records explicitly to avoid FK errors
            # Leaves
            db.query(Leave).filter(Leave.employee_id == emp.id).delete()
            # Attendances
            db.query(Attendance).filter(Attendance.employee_id == emp.id).delete()
            # WorkingLogs
            db.query(WorkingLog).filter(WorkingLog.employee_id == emp.id).delete()
            # Expenses (already cleared in previous step, but good to be safe if any left)
            # from app.models.expense import Expense
            # db.query(Expense).filter(Expense.employee_id == emp.id).delete()
            
            # Delete the Employee
            db.delete(emp)
            
            # Optionally, we might want to delete the User account too if they are not admin?
            # The prompt said "clear all employee", usually implies the user account too if created for employee.
            # But let's stick to Employee table primarily unless we are sure.
            # If I delete the employee, the user remains as a "User" without an "Employee" profile.
            # I will also delete the User if they are not the admin, assuming these are employee accounts.
            if emp.user_id and emp.user_id != admin_user_id:
                 user_to_delete = db.query(User).filter(User.id == emp.user_id).first()
                 if user_to_delete:
                     print(f"  -> Also deleting associated User: {user_to_delete.email}")
                     db.delete(user_to_delete)

        db.commit()
        print("Employee cleanup completed.")
        
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    clear_non_admin_employees()
