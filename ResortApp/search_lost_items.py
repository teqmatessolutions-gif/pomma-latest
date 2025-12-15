
from app.database import SessionLocal
from app.models.foodorder import FoodOrder
from app.models.service import AssignedService
from app.models.room import Room
import sys

def search_lost_items():
    with open("search_lost_output.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        db = SessionLocal()
        try:
            # 1. Find Room 101
            room = db.query(Room).filter(Room.number == "101").first()
            if not room:
                print("Room 101 not found")
                return
            
            print(f"Room 101 ID: {room.id}")
            
            # 2. List ALL food orders for this room
            print("\n--- All Food Orders for Room 101 ---")
            orders = db.query(FoodOrder).filter(FoodOrder.room_id == room.id).all()
            for o in orders:
                print(f"Order {o.id}: Amount {o.amount}, Status: {o.status}, Billing: {o.billing_status}")
                print(f"  Booking ID: {o.booking_id}, Package Booking ID: {o.package_booking_id}")
                print(f"  Created At: {o.created_at}")

            # 3. List ALL services
            print("\n--- All Services for Room 101 ---")
            services = db.query(AssignedService).filter(AssignedService.room_id == room.id).all()
            for s in services:
                # Need to load service details
                s_name = s.service.name if s.service else "Unknown"
                s_charge = s.service.charges if s.service else 0
                print(f"Service {s.id} ({s_name}): Charge {s_charge}, Status: {s.status}, Billing: {s.billing_status}")
                print(f"  Booking ID: {s.booking_id}, Package Booking ID: {s.package_booking_id}")
                print(f"  Assigned At: {s.assigned_at}")

        finally:
            db.close()

if __name__ == "__main__":
    search_lost_items()
