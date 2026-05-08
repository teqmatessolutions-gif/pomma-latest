from sqlalchemy.orm import Session, joinedload
from sqlalchemy import or_, and_
from datetime import date, datetime
from typing import List, Optional, Union, Any

from app.models.room import Room
from app.models.booking import Booking, BookingRoom
from app.models.Package import Package, PackageBooking, PackageBookingRoom
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.service import AssignedService, Service, ServiceStatus
from app.schemas.checkout import BillBreakdown, FoodOrderItem as FoodOrderItemSchema, ServiceItem as ServiceItemSchema

def calculate_booking_bill(db: Session, booking: Union[Booking, PackageBooking], room_id: Optional[int] = None) -> dict:
    """
    Authoritative billing calculation for any booking (Regular or Package).
    - If room_id is provided, calculates for that specific room only.
    - Otherwise, calculates for the entire booking (all rooms).
    """
    is_package = isinstance(booking, PackageBooking)
    
    # 1. Get associated rooms
    all_rooms = []
    if is_package:
        all_rooms = [link.room for link in booking.rooms if link.room]
    else:
        all_rooms = [link.room for link in booking.booking_rooms if link.room]
    
    # If room_id is provided, filter the room list
    target_rooms = all_rooms
    if room_id:
        target_rooms = [r for r in all_rooms if r.id == room_id]
        if not target_rooms:
            # Fallback: if room_id not in booking, use empty list
            target_rooms = []
            
    room_ids = [room.id for room in target_rooms]
    
    # 2. Calculate stay duration
    today = date.today()
    effective_checkout_date = max(today, booking.check_out)
    stay_days = max(1, (effective_checkout_date - booking.check_in).days)
    
    charges = BillBreakdown()
    
    # 3. Calculate Room/Package Charges
    if is_package:
        package = booking.package
        is_whole_property = False
        if package:
            booking_type = getattr(package, 'booking_type', None)
            if booking_type:
                is_whole_property = booking_type.lower() in ['whole_property', 'whole property']
            else:
                room_types = getattr(package, 'room_types', None)
                is_whole_property = not room_types or not room_types.strip()
        
        package_price = package.price if package else 0
        
        if is_whole_property:
            charges.package_charges = package_price * stay_days
            charges.room_charges = 0
        else:
            num_rooms_to_bill = len(target_rooms)
            charges.package_charges = package_price * num_rooms_to_bill * stay_days
            charges.room_charges = 0
    else:
        charges.package_charges = 0
        charges.room_charges = sum((room.price or 0) * stay_days for room in target_rooms)
    
    # 4. Food Charges (Filtered by room_ids)
    unbilled_food_order_items = (db.query(FoodOrderItem)
                                 .join(FoodOrder)
                                 .options(joinedload(FoodOrderItem.food_item))
                                 .filter(FoodOrder.room_id.in_(room_ids), 
                                        or_(FoodOrder.billing_status == "unbilled", 
                                            FoodOrder.billing_status.is_(None)))
                                 .filter(FoodOrder.status != "cancelled")
                                 .all())
                                 
    charges.food_charges = sum(item.quantity * item.food_item.price for item in unbilled_food_order_items if item.food_item)
    
    # Aggregate food items
    food_aggregation = {}
    for item in unbilled_food_order_items:
        if not item.food_item: continue
        name = item.food_item.name
        if name in food_aggregation:
            food_aggregation[name]['quantity'] += item.quantity
            food_aggregation[name]['amount'] += item.quantity * item.food_item.price
        else:
            food_aggregation[name] = {
                "item_name": name,
                "quantity": item.quantity,
                "amount": item.quantity * item.food_item.price
            }
    charges.food_items = [FoodOrderItemSchema(**v) for v in food_aggregation.values()]
    
    # 5. Service Charges (Filtered by room_ids)
    unbilled_services = db.query(AssignedService).options(joinedload(AssignedService.service)).filter(
        AssignedService.room_id.in_(room_ids), 
        AssignedService.billing_status == "unbilled",
        AssignedService.status != ServiceStatus.cancelled
    ).all()
    
    charges.service_charges = sum(ass.service.charges for ass in unbilled_services if ass.service)
    
    # Aggregate service items
    service_aggregation = {}
    for ass in unbilled_services:
        if not ass.service: continue
        name = ass.service.name
        if name in service_aggregation:
            service_aggregation[name]['charges'] += ass.service.charges
            service_aggregation[name]['quantity'] += 1
        else:
            service_aggregation[name] = {
                "service_name": name,
                "quantity": 1,
                "charges": ass.service.charges
            }
    charges.service_items = [ServiceItemSchema(**v) for v in service_aggregation.values()]
    
    # 6. GST Calculations
    room_charge_amount = (charges.room_charges or 0)
    if room_charge_amount > 0:
        if room_charge_amount <= 7500:
            charges.room_gst = room_charge_amount * 0.05
        else:
            charges.room_gst = room_charge_amount * 0.18
        charges.room_cgst = charges.room_gst / 2
        charges.room_sgst = charges.room_gst / 2
        
    package_charge_amount = (charges.package_charges or 0)
    if package_charge_amount > 0:
        if package_charge_amount <= 7500:
            charges.package_gst = package_charge_amount * 0.05
        else:
            charges.package_gst = package_charge_amount * 0.18
        charges.package_cgst = charges.package_gst / 2
        charges.package_sgst = charges.package_gst / 2
        
    if (charges.food_charges or 0) > 0:
        charges.food_gst = charges.food_charges * 0.05
        charges.food_cgst = charges.food_gst / 2
        charges.food_sgst = charges.food_gst / 2
        
    if (charges.service_charges or 0) > 0:
        charges.service_gst = charges.service_charges * 0.05
        charges.service_cgst = charges.service_gst / 2
        charges.service_sgst = charges.service_gst / 2
        
    charges.total_gst = (charges.room_gst or 0) + (charges.food_gst or 0) + (charges.service_gst or 0) + (charges.package_gst or 0)
    charges.cgst = charges.total_gst / 2
    charges.sgst = charges.total_gst / 2
    charges.total_due = sum([charges.room_charges, charges.food_charges, charges.service_charges, charges.package_charges])
    
    number_of_guests = getattr(booking, 'adults', 1) + getattr(booking, 'children', 0)
    
    return {
        "booking": booking,
        "all_rooms": target_rooms if room_id else all_rooms,
        "charges": charges,
        "is_package": is_package,
        "stay_nights": stay_days,
        "number_of_guests": number_of_guests,
        "effective_checkout_date": effective_checkout_date,
        "grand_total": charges.total_due + charges.total_gst
    }
