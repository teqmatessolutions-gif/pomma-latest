
from app.database import SessionLocal
from app.models.service import AssignedService

def link_services_to_booking():
    db = SessionLocal()
    try:
        # services to update
        service_ids = [27, 28]
        target_booking_id = 30
        
        services = db.query(AssignedService).filter(AssignedService.id.in_(service_ids)).all()
        
        if not services:
            print("Services not found.")
            return

        for s in services:
            print(f"Updating Service {s.id} ({s.status})...")
            print(f"  Old Booking ID: {s.booking_id}")
            s.booking_id = target_booking_id
            print(f"  New Booking ID: {s.booking_id}")
        
        db.commit()
        print(f"Successfully linked services {service_ids} to Booking ID {target_booking_id}.")

    except Exception as e:
        print(f"Error updating services: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    link_services_to_booking()
