from fastapi import FastAPI, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from datetime import date
from typing import Optional
from app.utils.auth import get_db
from app.database import Base, engine
from app.models import Room, Booking
from app.models.booking import BookingRoom
from app.models.foodorder import FoodOrder
from app.models.service import AssignedService, Service
from app.models.Package import PackageBooking, Package, PackageBookingRoom
from app.models.checkout import Checkout
from app.schemas.checkout import BillSummary, BillBreakdown, CheckoutSuccess, CheckoutRequest
router = APIRouter(prefix="/bill", tags=["checkout"])

def get_all_rooms(db: Session, skip: int = 0, limit: int = 100):
    rooms = db.query(Room).offset(skip).limit(limit).all()
    today = date.today()
    results = []

    for room in rooms:
        # If room is under maintenance, always show "Maintenance"
        if room.status.lower() == "maintenance":
            status = "Maintenance"
        else:
            # Check active booking via association table
            active_booking = (
                db.query(Booking)
                .join(BookingRoom, BookingRoom.booking_id == Booking.id)
                .filter(
                    BookingRoom.room_id == room.id,
                    Booking.status.in_(["booked", "checked-in"]),
                    Booking.check_in <= today,
                    Booking.check_out > today,
                )
                .first()
            )

            # Check active package booking by joining PackageBookingRoom
            active_package = (
                db.query(PackageBooking)
                .join(PackageBookingRoom, PackageBookingRoom.package_booking_id == PackageBooking.id)
                .filter(
                    PackageBookingRoom.room_id == room.id,
                    PackageBooking.status.in_(["booked", "checked-in"]),
                    PackageBooking.check_in <= today,
                    PackageBooking.check_out > today,
                )
                .first()
            )

            if active_booking or active_package:
                status = "Booked"
            else:
                status = "Available"

        results.append(
            {
                "id": room.id,
                "number": room.number,
                "type": room.type,
                "price": room.price,
                "status": status,
                "image_url": room.image_url,
            }
        )

    return results

def calculate_bill_for_room(db: Session, room_number: str):
    """
    Calculates the total bill for a given room number.
    This logic is shared by both the get_bill and checkout endpoints.
    """
    room = db.query(Room).filter(Room.number == room_number).first()
    if not room:
        raise HTTPException(status_code=404, detail="Room not found.")

    # Find the active booking for the given room
    booking_room = db.query(BookingRoom).filter(
        BookingRoom.room_id == room.id,
        Booking.status != 'checked_out'
    ).join(Booking).first()
    
    package_booking_room = db.query(PackageBookingRoom).filter(
        PackageBookingRoom.room_id == room.id,
        PackageBooking.status != 'checked_out'
    ).join(PackageBooking).first()

    booking = None
    if booking_room:
        booking = db.query(Booking).filter(Booking.id == booking_room.booking_id).first()
    elif package_booking_room:
        booking = db.query(PackageBooking).filter(PackageBooking.id == package_booking_room.package_booking_id).first()

    if not booking:
        raise HTTPException(status_code=404, detail="No active booking found for this room.")
    
    # Check if the booking has already been checked out
    if booking.status == "checked_out":
        raise HTTPException(status_code=400, detail="Booking for this room is already checked out.")

    charges = BillBreakdown()

    # Calculate charges based on booking type
    if isinstance(booking, Booking):
        # Regular booking
        stay_duration = (booking.check_out - booking.check_in).days
        charges.room_charges = room.price * stay_duration
        charges.food_charges = sum(
            order.amount for order in db.query(FoodOrder).filter(
                FoodOrder.room_id == room.id,
                FoodOrder.billing_status == "unbilled"
            ).all()
        )
        # Corrected: Access the 'charges' attribute from the related 'Service' object.
        charges.service_charges = sum(
            assigned_service.service.charges for assigned_service in db.query(AssignedService).join(AssignedService.service).filter(
                AssignedService.room_id == room.id,
                AssignedService.billing_status == "unbilled"
            ).all()
        )
    elif isinstance(booking, PackageBooking):
        # Package booking
        package = db.query(Package).filter(Package.id == booking.package_id).first()
        if package:
            charges.package_charges = package.price
    else:
        raise HTTPException(status_code=404, detail="Invalid booking type.")

    charges.total_due = sum([
        charges.room_charges or 0,
        charges.food_charges or 0,
        charges.service_charges or 0,
        charges.package_charges or 0
    ])

    return {
        "room": room,
        "booking": booking,
        "charges": charges
    }


