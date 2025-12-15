
from app.database import SessionLocal
from app.models.checkout import Checkout
from app.models.foodorder import FoodOrder
from app.models.service import AssignedService
from sqlalchemy import or_
import sys

def inspect_data():
    with open("inspect_checkout_23_output.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        db = SessionLocal()
        try:
            # 1. Get Checkout 23
            checkout = db.query(Checkout).filter(Checkout.id == 23).first()
            if not checkout:
                print("Checkout 23 not found!")
                return

            print(f"Checkout ID: {checkout.id}")
            print(f"  Booking ID: {checkout.booking_id}")
            print(f"  Package Booking ID: {checkout.package_booking_id}")
            print(f"  Room Number: {checkout.room_number}")
            print(f"  Food Total: {checkout.food_total}")
            print(f"  Service Total: {checkout.service_total}")
            print(f"  Created At: {checkout.created_at}")

            # 2. Check Linked Food Orders
            print("\n--- Linked Food Orders ---")
            if checkout.package_booking_id:
                orders = db.query(FoodOrder).filter(FoodOrder.package_booking_id == checkout.package_booking_id).all()
                print(f"Found {len(orders)} orders linked to PackageBooking {checkout.package_booking_id}")
                for o in orders:
                    print(f"  Order {o.id}: Amount {o.amount}, Room {o.room_id}")
            
            # 3. Check Potential Orphaned Food Orders (Same Room, date close)
            # Assuming Room 101 (from screenshot)
            room_num = checkout.room_number
            if room_num:
                from app.models.room import Room
                room = db.query(Room).filter(Room.number == room_num).first()
                if room:
                    print(f"Room {room_num} ID: {room.id}")
                    orphans = db.query(FoodOrder).filter(
                        FoodOrder.room_id == room.id,
                        FoodOrder.package_booking_id == None,
                        FoodOrder.booking_id == None
                    ).all()
                    print(f"Found {len(orphans)} ORPHANED food orders for Room {room.id}")
                    for o in orphans:
                        print(f"  Order {o.id}: Amount {o.amount}, Date {o.created_at}, Status: {o.billing_status}")
                    
                    orphaned_services = db.query(AssignedService).filter(
                        AssignedService.room_id == room.id,
                        AssignedService.package_booking_id == None,
                        AssignedService.booking_id == None
                    ).all()
                    print(f"Found {len(orphaned_services)} ORPHANED services for Room {room.id}")
                    for s in orphaned_services:
                         print(f"  Service {s.id}: Status: {s.billing_status}, Assigned At: {s.assigned_at}")


        finally:
            db.close()

if __name__ == "__main__":
    inspect_data()
