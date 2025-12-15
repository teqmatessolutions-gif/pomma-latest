
from app.database import SessionLocal
from app.models.foodorder import FoodOrder
from app.models.service import AssignedService

def fix_links():
    db = SessionLocal()
    try:
        # Target Package Booking ID 16
        pkg_id = 16
        
        # 1. Fix Food Order 23
        order = db.query(FoodOrder).filter(FoodOrder.id == 23).first()
        if order:
            print(f"Updating FoodOrder 23: was booking_id={order.booking_id}")
            order.booking_id = None
            order.package_booking_id = pkg_id
        
        # 2. Fix Services 29, 30
        services = db.query(AssignedService).filter(AssignedService.id.in_([29, 30])).all()
        for s in services:
             print(f"Updating Service {s.id}: was booking_id={s.booking_id}")
             s.booking_id = None
             s.package_booking_id = pkg_id
             
        db.commit()
        print("Successfully updated links to Package Booking 16.")

    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    fix_links()
