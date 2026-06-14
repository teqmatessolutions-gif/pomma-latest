from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from datetime import datetime, date
import json
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.room import Room
from app.utils.aiosell_sync import sync_inventory
from app.core.aiosell_config import WEBHOOK_USER, WEBHOOK_PASS
from fastapi.security import HTTPBasic, HTTPBasicCredentials

router = APIRouter(prefix="/aiosell", tags=["Aiosell"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

security = HTTPBasic()

def map_aiosell_room_type(db: Session, room_code: str):
    """
    Resilient mapping helper with multi-stage fallback.
    """
    if not room_code:
        return []

    # Standardize the input
    clean_code = str(room_code).strip()
    slug_code = clean_code.lower().replace("-", " ") # Convert 'DELUXE-ROOM' to 'deluxe room'

    # --- STAGE 1: Exact Match (Fastest) ---
    rooms = db.query(Room).filter(Room.channel_manager_id == clean_code).all()
    if rooms: return rooms

    # --- STAGE 2: Exact Name/Type Match ---
    rooms = db.query(Room).filter(Room.type.ilike(clean_code)).all()
    if rooms: return rooms

    # --- STAGE 3: Slugified Name Match ---
    rooms = db.query(Room).filter(Room.type.ilike(slug_code)).all()
    if rooms: return rooms

    # --- STAGE 4: Prefix/Fuzzy Match ---
    # If AIOSell sends 'DELUXE-CP', this matches the first room starting with 'DELUXE'
    prefix = clean_code.split('-')[0].split('_')[0]
    rooms = db.query(Room).filter(Room.type.ilike(f"{prefix}%")).all()
    if rooms: return rooms

    print(f"CRITICAL: Failed to map AIOSell code '{room_code}' to any room type.")
    return []

@router.post("/webhook")
async def aiosell_webhook(
    request: Request, 
    db: Session = Depends(get_db),
    credentials: HTTPBasicCredentials = Depends(security)
):
    """
    Receive reservation updates from Aiosell.
    """
    # Verify credentials
    if credentials.username != WEBHOOK_USER or credentials.password != WEBHOOK_PASS:
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Basic"},
        )

    payload = await request.json()
    print(f"Received Aiosell Webhook: {json.dumps(payload)}")
    
    # Handle different payload structures
    res_data = payload.get("reservation") or payload
    
    # Check for mandatory fields
    ext_id = str(
        res_data.get("reservationId") or 
        res_data.get("bookingId") or 
        res_data.get("bookingID") or 
        res_data.get("id")
    )
    if not ext_id or ext_id == "None":
        return {"status": "error", "message": "No reservation ID found in payload"}
    
    action = payload.get("action", "book").lower()
    status = res_data.get("status", "booked").lower()
    
    # If action is cancel, override status
    if action in ["cancel", "cancelled", "delete"]:
        status = "cancelled"

    # 1. Handle Cancellation
    if status in ["cancelled", "canceled"]:
        booking = db.query(Booking).filter(Booking.external_id == ext_id).first()
        if booking:
            booking.status = "cancelled"
            booking.external_status = status
            db.commit()
            await sync_inventory(db)
            return {"status": "success", "message": "Booking cancelled"}
        return {"status": "success", "message": "Booking not found, nothing to cancel"}

    # 2. Handle Create / Update (MODIFY)
    existing_booking = db.query(Booking).filter(Booking.external_id == ext_id).first()
    
    # Fuzzy Date extraction
    ci_str = (
        res_data.get("checkIn") or 
        res_data.get("check_in") or 
        res_data.get("arrival") or 
        res_data.get("arrivalDate") or
        res_data.get("checkin")
    )
    co_str = (
        res_data.get("checkOut") or 
        res_data.get("check_out") or 
        res_data.get("departure") or 
        res_data.get("departureDate") or
        res_data.get("checkout")
    )
    if not ci_str or not co_str:
         return {"status": "error", "message": "Check-in or Check-out date missing"}

    check_in = datetime.strptime(ci_str[:10], "%Y-%m-%d").date()
    check_out = datetime.strptime(co_str[:10], "%Y-%m-%d").date()
    
    # Guest extraction
    guest_obj = (
        res_data.get("guest") or 
        res_data.get("guestDetails") or 
        res_data.get("customer") or 
        res_data.get("primaryGuest") or 
        res_data.get("traveller") or
        {}
    )
    if isinstance(guest_obj, dict):
        f_name = guest_obj.get("firstName") or ""
        l_name = guest_obj.get("lastName") or ""
        guest_name = (f"{f_name} {l_name}").strip() or guest_obj.get("name") or res_data.get("guestName") or "Unknown Guest"
        guest_email = guest_obj.get("email") or res_data.get("guestEmail")
        guest_mobile = guest_obj.get("phone") or guest_obj.get("mobile") or res_data.get("guestMobile")
    else:
        guest_name = res_data.get("guestName", "Unknown Guest")
        guest_email = res_data.get("guestEmail")
        guest_mobile = res_data.get("guestMobile")

    # Common fields
    adults = res_data.get("adults")
    children = res_data.get("children")
    if adults is None or children is None:
        adults, children = 0, 0
        for r in res_data.get("rooms", []):
            occ = r.get("occupancy", {})
            adults += int(occ.get("adults", 0))
            children += int(occ.get("children", 0))
    adults = adults or 2
    children = children or 0

    # Fuzzy Amount extraction
    amt_obj = res_data.get("amount", {})
    total_amount = (
        res_data.get("totalAmount") or 
        res_data.get("total_price") or 
        res_data.get("sellingPrice") or
        amt_obj.get("amountAfterTax") or 
        amt_obj.get("total") or 
        0
    )

    if existing_booking or action in ["modify", "update", "amend", "modified"]:
        target_booking = existing_booking
        if not target_booking:
            new_booking = Booking(
                guest_name=guest_name,
                guest_email=guest_email,
                guest_mobile=guest_mobile,
                check_in=check_in,
                check_out=check_out,
                adults=adults,
                children=children,
                total_amount=float(total_amount),
                source=payload.get("channel", "Aiosell"),
                external_id=ext_id,
                external_status=status,
                status="booked"
            )
            db.add(new_booking)
            db.flush()
            target_booking = new_booking
        else:
            target_booking.guest_name = guest_name
            target_booking.guest_email = guest_email
            target_booking.guest_mobile = guest_mobile
            target_booking.check_in = check_in
            target_booking.check_out = check_out
            target_booking.adults = adults
            target_booking.children = children
            target_booking.total_amount = float(total_amount)
            target_booking.external_status = status
            db.query(BookingRoom).filter(BookingRoom.booking_id == target_booking.id).delete()
            db.flush()
        booking_id = target_booking.id
    else:
        new_booking = Booking(
            guest_name=guest_name,
            guest_email=guest_email,
            guest_mobile=guest_mobile,
            check_in=check_in,
            check_out=check_out,
            adults=adults,
            children=children,
            total_amount=float(total_amount),
            source=payload.get("channel", "Aiosell"),
            external_id=ext_id,
            external_status=status,
            status="booked"
        )
        db.add(new_booking)
        db.flush()
        booking_id = new_booking.id
    
    # Assign Rooms with Resilient Mapping
    rooms_requested = res_data.get("rooms", [])
    if not rooms_requested:
        # Fallback if top-level roomCode is used instead of list
        rtc = res_data.get("roomCode")
        if rtc:
            rooms_requested = [{"roomCode": rtc, "quantity": 1}]

    for r_req in rooms_requested:
        rtc = r_req.get("roomCode")
        qty = r_req.get("quantity", 1)
        
        available_rooms = map_aiosell_room_type(db, rtc)
        
        assigned_count = 0
        for room in available_rooms:
            if assigned_count >= qty: break
            
            is_busy = db.query(BookingRoom).join(Booking).filter(
                BookingRoom.room_id == room.id,
                Booking.id != booking_id,
                Booking.status.in_(['booked', 'checked-in', 'occupied']),
                Booking.check_in < check_out,
                Booking.check_out > check_in
            ).first()
            
            if not is_busy:
                br = BookingRoom(booking_id=booking_id, room_id=room.id)
                db.add(br)
                assigned_count += 1
        
        if assigned_count < qty:
             print(f"Warning: Could not find enough available rooms for '{rtc}'. Assigned {assigned_count}/{qty}")
             # Add mapping failure info to special requests for manual review
             current_booking = db.query(Booking).filter(Booking.id == booking_id).first()
             failure_note = f"\nAUTO-MAPPING FAILED: Original Code: {rtc}. Assigned {assigned_count}/{qty} rooms."
             if not current_booking.package_name: # Re-using package_name or special_requests if available
                 current_booking.package_name = failure_note
             else:
                 current_booking.package_name += failure_note

    db.commit()
    await sync_inventory(db)
    
    return {"status": "success", "booking_id": ext_id}
