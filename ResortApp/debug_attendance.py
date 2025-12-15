from app.api.attendance import WorkingLogRecord
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.employee import WorkingLog, Employee
from app.models.user import User
from datetime import datetime

def debug_attendance():
    db: Session = SessionLocal()
    try:
        # Find employee 'basil'
        user = db.query(User).filter(User.name.ilike("%nonexistent%")).first()
        if not user:
            print("User 'nonexistent' not found.")
            # List all users to help debug
            print("Available users:")
            for u in db.query(User).all():
                print(f" - {u.name} ({u.email}) role:{u.role.name if u.role else 'None'}")
            
            # Find admin
            admin = db.query(User).filter(User.email == 'admin@orchid.com').first()
            if admin:
                 print(f"Admin found: {admin.email}")
            return

        employee = db.query(Employee).filter(Employee.user_id == user.id).first()
        if not employee:
            print(f"Employee record for user {user.name} not found.")
            return

        print(f"Found Employee: {user.name} (ID: {employee.id})")

        logs = db.query(WorkingLog).filter(WorkingLog.employee_id == employee.id).order_by(WorkingLog.date.desc()).all()
        
        print(f"Found {len(logs)} logs.")
        
        for log in logs:
            print("-" * 40)
            print(f"Log ID: {log.id}")
            
            duration_hours = None
            if log.check_in_time and log.check_out_time:
                try:
                    start_dt = datetime.combine(log.date, log.check_in_time)
                    end_dt = datetime.combine(log.date, log.check_out_time)
                    
                    if end_dt > start_dt:
                        duration = end_dt - start_dt
                        duration_hours = duration.total_seconds() / 3600
                        print(f"Calculated Duration: {duration_hours} hours")
                except Exception as e:
                    print(f"Error during calculation: {e}")
            
            # TEST PYDANTIC MODEL
            try:
                log_data = WorkingLogRecord.model_validate(log)
                print(f"Pydantic Model (Before Assign): {log_data.duration_hours}")
                
                log_data.duration_hours = duration_hours
                print(f"Pydantic Model (After Assign): {log_data.duration_hours}")
                
                # Check if it persists in dump
                print(f"Serialized Dump: {log_data.model_dump()['duration_hours']}")
                
            except Exception as e:
                print(f"Pydantic Error: {e}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    debug_attendance()
