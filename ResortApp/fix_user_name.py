
from app.database import SessionLocal
from app.models.user import User

def fix_user_name():
    db = SessionLocal()
    try:
        # Find the user named 'Conflict Guest'
        user = db.query(User).filter(User.name == "Conflict Guest").first()
        if user:
            print(f"Found user ID {user.id} with name '{user.name}'.")
            user.name = "Admin User"
            db.commit()
            print("Renamed to 'Admin User'.")
        else:
            print("No user named 'Conflict Guest' found.")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    fix_user_name()
