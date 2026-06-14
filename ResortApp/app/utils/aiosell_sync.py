import httpx
import json
from datetime import date, timedelta
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.models.room import Room, RatePlanMapping
from app.models.booking import Booking, BookingRoom
from app.models.Package import PackageBooking, PackageBookingRoom
from app.core.aiosell_config import (
    AIOSELL_USERNAME,
    AIOSELL_PASSWORD,
    AIOSELL_HOTEL_CODE,
    AIOSELL_ACTIVE,
    get_inventory_url,
    get_rates_url
)

from app.models.frontend import ResortInfo

async def push_to_aiosell(url: str, payload: dict):
    """Generic helper to push data to Aiosell"""
    if not AIOSELL_ACTIVE:
        print("Aiosell Sync is DISABLED (AIOSELL_ACTIVE=false)")
        return False
        
    auth = (AIOSELL_USERNAME, AIOSELL_PASSWORD)
    
    # Add credentials to payload as some Aiosell endpoints expect them in the body
    payload["username"] = AIOSELL_USERNAME
    payload["password"] = AIOSELL_PASSWORD
    
    try:
        print(f"Pushing to Aiosell: {url}")
        print(f"Using Username: {AIOSELL_USERNAME}")
        # Hide password in logs
        log_payload = payload.copy()
        log_payload["password"] = "********"
        print(f"Payload: {json.dumps(log_payload, indent=2)}")
        
        async with httpx.AsyncClient() as client:
            response = await client.post(url, json=payload, auth=auth, timeout=30.0)
            if response.status_code == 200:
                print(f"Successfully pushed to Aiosell")
                print(f"Aiosell Response: {response.text}")
                return True
            else:
                print(f"Failed to push to Aiosell: {response.status_code} - {response.text}")
                return False
    except Exception as e:
        print(f"Error pushing to Aiosell: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def get_actual_hotel_code(db: Session):
    try:
        resort = db.query(ResortInfo).first()
        if resort and resort.hotel_code:
            return resort.hotel_code
    except:
        pass
    return AIOSELL_HOTEL_CODE

from app.models.Package import Package, PackageBooking, PackageBookingRoom

def calculate_availability(db: Session, target_date: date):
    """
    Calculate availability for each room and package on a specific date.
    Returns a list of dicts: [{"roomCode": code, "available": 0/1}]
    """
    # 1. Get all rooms that have an Aiosell code
    rooms = db.query(Room).filter(Room.channel_manager_id != None).all()
    
    # 2. Get all packages that have an Aiosell code
    packages = db.query(Package).filter(Package.channel_manager_id != None).all()

    # 3. Get booked room IDs for this date
    booked_room_ids = db.query(BookingRoom.room_id).join(Booking).filter(
        Booking.status.in_(['booked', 'checked-in', 'occupied']),
        Booking.check_in <= target_date,
        Booking.check_out > target_date
    ).all()
    
    package_booked_room_ids = db.query(PackageBookingRoom.room_id).join(PackageBooking).filter(
        PackageBooking.status.in_(['booked', 'checked-in', 'occupied']),
        PackageBooking.check_in <= target_date,
        PackageBooking.check_out > target_date
    ).all()
    
    all_booked_ids = set([r[0] for r in booked_room_ids] + [r[0] for r in package_booked_room_ids])
    
    # 4. Calculate availability
    availability = []
    
    # Check if a Whole Property package is booked for this date
    # (A package is "whole_property" if it has booking_type == 'whole_property')
    whole_property_booked = any(
        db.query(PackageBooking).filter(
            PackageBooking.package_id == pkg.id,
            PackageBooking.status.in_(['booked', 'checked-in', 'occupied']),
            PackageBooking.check_in <= target_date,
            PackageBooking.check_out > target_date
        ).first() is not None
        for pkg in packages if pkg.booking_type == 'whole_property'
    )

    # Process Rooms
    for room in rooms:
        # Room is unavailable if:
        # 1. It is individually booked
        # 2. OR any "Whole Property" package is booked
        is_booked = (room.id in all_booked_ids) or whole_property_booked
        
        base_count = room.online_inventory if room.online_inventory is not None else 1
        current_avail = base_count if not is_booked else 0
        
        availability.append({
            "roomCode": room.channel_manager_id,
            "available": max(0, current_avail)
        })
        
    # Process Packages
    for pkg in packages:
        if pkg.booking_type == 'whole_property':
            # Whole Property is unavailable if:
            # 1. ANY room in the resort is booked
            # 2. OR the package itself is booked (covered by rule 1 if rooms are linked, but good to be explicit)
            any_room_booked = len(all_booked_ids) > 0
            current_avail = pkg.online_inventory if pkg.online_inventory is not None else 1
            if any_room_booked or whole_property_booked:
                current_avail = 0
                
            availability.append({
                "roomCode": pkg.channel_manager_id,
                "available": max(0, current_avail)
            })
        else:
            # Regular Room-Type packages
            base_count = pkg.online_inventory if pkg.online_inventory is not None else 1
            availability.append({
                "roomCode": pkg.channel_manager_id,
                "available": max(0, base_count)
            })
        
    return availability

async def sync_all(db: Session, days=30):
    """Full sync of everything: inventory and rates."""
    await sync_inventory(db, days)
    await sync_rates(db, days)

async def sync_inventory(db: Session, days=30):
    today = date.today()
    hotel_code = get_actual_hotel_code(db)
    updates = []
    
    for i in range(days):
        target_date = today + timedelta(days=i)
        day_rooms = calculate_availability(db, target_date)
            
        if day_rooms:
            updates.append({
                "startDate": target_date.isoformat(),
                "endDate": target_date.isoformat(),
                "rooms": day_rooms
            })
            
    if updates:
        payload = {"hotelCode": hotel_code, "updates": updates}
        await push_to_aiosell(get_inventory_url(), payload)

async def sync_rates(db: Session, days=30):
    today = date.today()
    hotel_code = get_actual_hotel_code(db)
    
    # Get all rooms and packages with Aiosell codes to process their rates
    rooms = db.query(Room).filter(Room.channel_manager_id != None).all()
    packages = db.query(Package).filter(Package.channel_manager_id != None).all()
    
    updates = []
    for i in range(days):
        target_date = today + timedelta(days=i)
        day_rates = []
        
        # Process Room Rates
        for room in rooms:
            for mapping in room.rate_plan_mappings:
                price = room.price or 0
                if mapping.price_offset:
                    price += mapping.price_offset
                elif mapping.offset_percentage:
                    price += price * (mapping.offset_percentage / 100)
                if mapping.fixed_offset:
                    price += mapping.fixed_offset
                    
                day_rates.append({
                    "roomCode": room.channel_manager_id,
                    "rateplanCode": mapping.channel_manager_id,
                    "rate": round(price, 2)
                })
        
        # Process Package Rates
        for pkg in packages:
            for mapping in pkg.rate_plan_mappings:
                price = pkg.price or 0
                if mapping.price_offset:
                    price += mapping.price_offset
                elif mapping.offset_percentage:
                    price += price * (mapping.offset_percentage / 100)
                if mapping.fixed_offset:
                    price += mapping.fixed_offset
                    
                day_rates.append({
                    "roomCode": pkg.channel_manager_id,
                    "rateplanCode": mapping.channel_manager_id,
                    "rate": round(price, 2)
                })
                
        if day_rates:
            updates.append({
                "startDate": target_date.isoformat(),
                "endDate": target_date.isoformat(),
                "rates": day_rates
            })
            
    if updates:
        payload = {"hotelCode": hotel_code, "updates": updates}
        await push_to_aiosell(get_rates_url(), payload)

async def sync_restrictions(db: Session, days=30):
    # Restrictions logic can be added here if needed
    pass

def trigger_aiosell_sync(db_factory, sync_type="inventory"):
    """
    Wrapper to trigger sync in a background task with its own DB session.
    """
    import asyncio
    
    async def run_sync():
        db = db_factory()
        try:
            if sync_type == "inventory":
                await sync_inventory(db)
            elif sync_type == "rates":
                await sync_rates(db)
            elif sync_type == "all":
                await sync_all(db)
        finally:
            db.close()
            
    # Try to get existing loop or run in new one
    try:
        loop = asyncio.get_event_loop()
        if loop.is_running():
            loop.create_task(run_sync())
        else:
            loop.run_until_complete(run_sync())
    except Exception:
        asyncio.run(run_sync())
