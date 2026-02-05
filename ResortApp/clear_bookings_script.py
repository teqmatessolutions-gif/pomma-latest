
import sys
import os
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.database import SessionLocal, engine

# Import models
from app.models.booking import Booking, BookingRoom, CheckInDocument
from app.models.Package import PackageBooking, PackageBookingRoom, PackageCheckInDocument
from app.models.checkout import Checkout
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.service import AssignedService

def clear_bookings():
    db: Session = SessionLocal()
    try:
        print("Starting cleanup of Bookings and Checkouts...")

        # 1. Clear Checkouts (Child of Booking/PackageBooking)
        checkouts = db.query(Checkout).all()
        if checkouts:
            print(f"Deleting {len(checkouts)} checkouts...")
            for c in checkouts:
                db.delete(c)
            db.flush()
        
        # 2. Clear Food Orders linked to Bookings (or all? User said "completed checkouts" implies billing data)
        # Often FoodOrders are linked to a booking. If we delete bookings, we should delete these.
        # We will delete any food order that has a booking_id or package_booking_id.
        food_orders = db.query(FoodOrder).filter(
            or_(FoodOrder.booking_id.isnot(None), FoodOrder.package_booking_id.isnot(None))
        ).all()
        if food_orders:
            print(f"Deleting {len(food_orders)} booking-related food orders...")
            for fo in food_orders:
                # FoodOrderItem cascades from FoodOrder usually, but let's be safe
                db.delete(fo)
            db.flush()

        # 3. Clear Assigned Services linked to Bookings
        assigned_services = db.query(AssignedService).filter(
            or_(AssignedService.booking_id.isnot(None), AssignedService.package_booking_id.isnot(None))
        ).all()
        if assigned_services:
            print(f"Deleting {len(assigned_services)} booking-related assigned services...")
            for asrv in assigned_services:
                db.delete(asrv)
            db.flush()

        # 4. Clear Regular Bookings
        bookings = db.query(Booking).all()
        print(f"Found {len(bookings)} regular bookings.")
        for b in bookings:
            # Manually delete reverse relationships if cascade is flaky
            
            # Booking Rooms
            b_rooms = db.query(BookingRoom).filter(BookingRoom.booking_id == b.id).all()
            for br in b_rooms: db.delete(br)
            
            # Check-in Docs
            b_docs = db.query(CheckInDocument).filter(CheckInDocument.booking_id == b.id).all()
            for bd in b_docs: db.delete(bd)

            db.delete(b)
        db.flush()

        # 5. Clear Package Bookings
        pkg_bookings = db.query(PackageBooking).all()
        print(f"Found {len(pkg_bookings)} package bookings.")
        for pb in pkg_bookings:
            # Package Rooms
            pb_rooms = db.query(PackageBookingRoom).filter(PackageBookingRoom.package_booking_id == pb.id).all()
            for pbr in pb_rooms: db.delete(pbr)

            # Package Docs
            pb_docs = db.query(PackageCheckInDocument).filter(PackageCheckInDocument.package_booking_id == pb.id).all()
            for pbd in pb_docs: db.delete(pbd)

            db.delete(pb)
        db.flush()

        db.commit()
        print("Successfully cleared all bookings and checkouts.")

    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    clear_bookings()
