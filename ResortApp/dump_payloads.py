import sys
import os
import json
from datetime import date, timedelta

# Add ResortApp to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.database import SessionLocal
from app.utils.aiosell_sync import calculate_availability
from app.models.room import Room
from app.core.aiosell_config import AIOSELL_HOTEL_CODE

def print_payloads():
    db = SessionLocal()
    today = date.today()
    
    # 1. Inventory Payload
    updates_inv = []
    avail = calculate_availability(db, today)
    if avail:
        rooms_list = [{"roomCode": rtc, "available": count} for rtc, count in avail.items()]
        updates_inv.append({
            "startDate": today.isoformat(),
            "endDate": today.isoformat(),
            "rooms": rooms_list
        })
    
    payload_inv = {
        "hotelCode": AIOSELL_HOTEL_CODE,
        "updates": updates_inv
    }
    
    # 2. Rates Payload
    rooms = db.query(Room).filter(Room.aiosell_room_code != None).all()
    end_date = today + timedelta(days=29)
    
    rate_updates = []
    for room in rooms:
        for mapping in room.rate_plan_mappings:
            price = room.price
            if mapping.offset_percentage:
                price += price * (mapping.offset_percentage / 100)
            if mapping.fixed_offset:
                price += mapping.fixed_offset
                
            rate_updates.append({
                "roomCode": room.aiosell_room_code,
                "rateplanCode": mapping.aiosell_id,
                "rate": round(price, 2)
            })
            
    payload_rates = {
        "hotelCode": AIOSELL_HOTEL_CODE,
        "updates": [
            {
                "startDate": today.isoformat(),
                "endDate": end_date.isoformat(),
                "rates": rate_updates
            }
        ]
    } if rate_updates else {"hotelCode": AIOSELL_HOTEL_CODE, "updates": []}

    # 3. Restrictions Payload
    restriction_updates = []
    for room in rooms:
        restriction_updates.append({
            "roomCode": room.aiosell_room_code,
            "minStay": room.min_stay or 1,
            "cta": room.cta or False,
            "ctd": room.ctd or False
        })
        
    payload_rest = {
        "hotelCode": AIOSELL_HOTEL_CODE,
        "updates": [
            {
                "startDate": today.isoformat(),
                "endDate": end_date.isoformat(),
                "restrictions": restriction_updates
            }
        ]
    } if restriction_updates else {"hotelCode": AIOSELL_HOTEL_CODE, "updates": []}

    print("=== INVENTORY PAYLOAD ===")
    print(json.dumps(payload_inv, indent=4))
    print("\n=== RATES PAYLOAD ===")
    print(json.dumps(payload_rates, indent=4))
    print("\n=== RESTRICTIONS PAYLOAD ===")
    print(json.dumps(payload_rest, indent=4))
    
    db.close()

if __name__ == "__main__":
    print_payloads()
