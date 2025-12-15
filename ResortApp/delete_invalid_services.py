
from app.database import SessionLocal
from app.models.service import AssignedService

def delete_invalid_services():
    db = SessionLocal()
    try:
        # Delete ID 27 and 28
        ids_to_delete = [27, 28]
        services = db.query(AssignedService).filter(AssignedService.id.in_(ids_to_delete)).all()
        
        if not services:
            print("Services not found.")
            return

        for s in services:
            print(f"Deleting Service {s.id} ({s.status}) assigned at {s.assigned_at}...")
            db.delete(s)
        
        db.commit()
        print("Successfully deleted invalid services.")

    except Exception as e:
        print(f"Error deleting services: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    delete_invalid_services()
