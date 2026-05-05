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
    AIOSELL_BASE_URL
)

async def push_to_aiosell(endpoint: str, payload: dict):
    """Generic helper to push data to Aiosell"""
    url = AIOSELL_BASE_URL
    auth = (AIOSELL_USERNAME, AIOSELL_PASSWORD)
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(url, json=payload, auth=auth, timeout=30.0)
            if response.status_code == 200:
                print(f"Successfully pushed to Aiosell {endpoint} via {url}")
                print(f"Aiosell Response: {response.text}")
                return True
            else:
                print(f"Failed to push to Aiosell {endpoint}: {response.status_code} - {response.text}")
                return False
    except Exception as e:
        print(f"Error pushing to Aiosell {endpoint}: {str(e)}")
        return False

def calculate_availability(db: Session, target_date: date):
    """
    Calculate availability for each room type on a specific date.
    Returns a dict: {room_type_code: available_count}
    """
    # 1. Get total rooms per type
    room_types = db.query(Room.aiosell_room_code, func.count(Room.id)).filter(Room.aiosell_room_code != None).group_by(Room.aiosell_room_code).all()
    total_rooms = {rtc: count for rtc, count in room_types}
    
    if not total_rooms:
        return {}

    # 2. Get booked rooms for this date
    booked_room_ids = db.query(BookingRoom.room_id).join(Booking).filter(
        Booking.status.in_(['booked', 'checked-in', 'occupied']),
        Booking.check_in <= target_date,
        Booking.check_out > target_date # Check-out date is not included in stay
    ).all()
    
    package_booked_room_ids = db.query(PackageBookingRoom.room_id).join(PackageBooking).filter(
        PackageBooking.status.in_(['booked', 'checked-in', 'occupied']),
        PackageBooking.check_in <= target_date,
        PackageBooking.check_out > target_date
    ).all()
    
    all_booked_ids = set([r[0] for r in booked_room_ids] + [r[0] for r in package_booked_room_ids])
    
    # 3. Calculate remaining availability per type
    availability = {rtc: total for rtc, total in total_rooms.items()}
    
    rooms_with_type = db.query(Room.id, Room.aiosell_room_code).filter(Room.aiosell_room_code != None).all()
    for rid, rtc in rooms_with_type:
        if rid in all_booked_ids:
            if rtc in availability:
                availability[rtc] -= 1
    
    # Ensure no negative availability
    for rtc in availability:
        availability[rtc] = max(0, availability[rtc])
        
    return availability

async def sync_all(db: Session, days=30):
    """Full sync of everything: inventory, rates, and restrictions in one combined payload."""
    today = date.today()
    rooms = db.query(Room).filter(Room.aiosell_room_code != None).all()
    updates = []
    
    for i in range(days):
        target_date = today + timedelta(days=i)
        avail = calculate_availability(db, target_date)
        
        day_rooms = []
        day_rates = []
        day_rest = []
        
        for room in rooms:
            code = room.aiosell_room_code
            if code in avail:
                day_rooms.append({"roomCode": code, "available": avail[code]})
                
            day_rest.append({
                "roomCode": code,
                "minStay": room.min_stay or 1,
                "cta": room.cta or False,
                "ctd": room.ctd or False
            })
            
            for mapping in room.rate_plan_mappings:
                price = room.price
                if mapping.offset_percentage:
                    price += price * (mapping.offset_percentage / 100)
                if mapping.fixed_offset:
                    price += mapping.fixed_offset
                    
                day_rates.append({
                    "roomCode": code,
                    "rateplanCode": mapping.aiosell_id,
                    "rate": round(price, 2)
                })
                
        if day_rooms or day_rates or day_rest:
            update_item = {
                "startDate": target_date.isoformat(),
                "endDate": target_date.isoformat()
            }
            if day_rooms:
                update_item["rooms"] = day_rooms
            if day_rates:
                update_item["rates"] = day_rates
            if day_rest:
                update_item["restrictions"] = day_rest
                
            updates.append(update_item)
            
    if not updates:
        return
        
    payload = {
        "hotelCode": AIOSELL_HOTEL_CODE,
        "updates": updates
    }
    
    await push_to_aiosell("combined_sync", payload)

async def sync_inventory(db: Session, days=30):
    await sync_all(db, days)

async def sync_rates(db: Session, days=30):
    await sync_all(db, days)

async def sync_restrictions(db: Session, days=30):
    await sync_all(db, days)
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
