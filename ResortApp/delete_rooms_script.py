
import sys
import os
from sqlalchemy.orm import Session
from app.database import SessionLocal, engine

# Import all relevant models
from app.models.room import Room, RoomImage
from app.models.foodorder import FoodOrder
from app.models.booking import BookingRoom
from app.models.Package import PackageBookingRoom
from app.models.service import AssignedService

def delete_rooms():
    db: Session = SessionLocal()
    try:
        keep_rooms = ["102", "103", "201"]
        
        rooms = db.query(Room).all()
        print(f"Total rooms registered: {len(rooms)}")
        
        rooms_to_delete = [r for r in rooms if r.number not in keep_rooms]
        print(f"Rooms targeted for deletion ({len(rooms_to_delete)}): {[r.number for r in rooms_to_delete]}")
        
        if not rooms_to_delete:
            print("No rooms found to delete.")
            return

        deletion_count = 0
        for room in rooms_to_delete:
            print(f"Processing Room {room.number} (ID: {room.id})...")
            
            try:
                # 1. Booking Rooms
                booking_rooms = db.query(BookingRoom).filter(BookingRoom.room_id == room.id).all()
                if booking_rooms:
                    print(f"  - Deleting {len(booking_rooms)} associated booking_rooms...")
                    for br in booking_rooms:
                        db.delete(br)
                        
                # 2. Package Booking Rooms
                pkg_booking_rooms = db.query(PackageBookingRoom).filter(PackageBookingRoom.room_id == room.id).all()
                if pkg_booking_rooms:
                    print(f"  - Deleting {len(pkg_booking_rooms)} associated package_booking_rooms...")
                    for pbr in pkg_booking_rooms:
                        db.delete(pbr)

                # 3. Food Orders
                food_orders = db.query(FoodOrder).filter(FoodOrder.room_id == room.id).all()
                if food_orders:
                    print(f"  - Deleting {len(food_orders)} associated food orders...")
                    for fo in food_orders:
                        db.delete(fo)

                # 4. Assigned Services
                assigned_services = db.query(AssignedService).filter(AssignedService.room_id == room.id).all()
                if assigned_services:
                    print(f"  - Deleting {len(assigned_services)} associated assigned_services...")
                    for asrv in assigned_services:
                        db.delete(asrv)

                # 5. Room Images
                images = db.query(RoomImage).filter(RoomImage.room_id == room.id).all()
                if images:
                    print(f"  - Deleting {len(images)} associated images...")
                    for img in images:
                        db.delete(img)

                # 6. Delete the Room itself
                print(f"  - Deleting room object...")
                db.delete(room)
                
                db.flush()
                deletion_count += 1
                
            except Exception as inner_e:
                print(f"Error processing room {room.number}: {inner_e}")
                # Print exception type explicitly
                print(f"Exception Type: {type(inner_e)}")
                raise inner_e

        db.commit()
        print(f"Deletion successful. {deletion_count} rooms deleted.")
        
        # Verification
        remaining = db.query(Room).all()
        print(f"Remaining rooms ({len(remaining)}): {[r.number for r in remaining]}")
        
    except Exception as e:
        print(f"An error occurred: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    delete_rooms()
