from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from datetime import datetime, date
import json
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.room import Room
from app.utils.aiosell_sync import sync_inventory

router = APIRouter(prefix="/aiosell", tags=["Aiosell"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

from fastapi.security import HTTPBasic, HTTPBasicCredentials
import os

security = HTTPBasic()

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
    correct_username = os.getenv("AIOSELL_USERNAME", "admin@teqmates.com")
    correct_password = os.getenv("AIOSELL_PASSWORD", "teqmates@5412!")
    
    if credentials.username != correct_username or credentials.password != correct_password:
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Basic"},
        )

    payload = await request.json()
    print(f"Received Aiosell Webhook: {json.dumps(payload)}")
    
    # Handle different payload structures
    # Structure 1: Nested under "reservation"
    # Structure 2: Root level (as seen in Postman)
    res_data = payload.get("reservation") or payload
    
    # Check for mandatory fields to confirm it's a valid booking payload
    ext_id = str(res_data.get("reservationId") or res_data.get("bookingId") or res_data.get("id"))
    if not ext_id or ext_id == "None":
        return {"status": "error", "message": "No reservation ID (reservationId/bookingId) found in payload"}
    
    action = payload.get("action", "book").lower()
    status = res_data.get("status", "booked").lower()
    
    # If action is cancel, override status
    if action == "cancel":
        status = "cancelled"

    # 1. Handle Cancellation
    if status in ["cancelled", "canceled"]:
        booking = db.query(Booking).filter(Booking.external_booking_id == ext_id).first()
        if booking:
            booking.status = "cancelled"
            booking.external_status = status
            db.commit()
            # Trigger inventory sync
            await sync_inventory(db)
            return {"status": "success", "message": "Booking cancelled"}
        return {"status": "success", "message": "Booking not found, nothing to cancel"}

    # 2. Handle Create / Update
    existing_booking = db.query(Booking).filter(Booking.external_booking_id == ext_id).first()
    
    # Handle date formats (checkIn vs checkin)
    ci_str = res_data.get("checkIn") or res_data.get("checkin")
    co_str = res_data.get("checkOut") or res_data.get("checkout")
    
    if not ci_str or not co_str:
         return {"status": "error", "message": "Check-in or Check-out date missing"}

    check_in = datetime.strptime(ci_str, "%Y-%m-%d").date()
    check_out = datetime.strptime(co_str, "%Y-%m-%d").date()
    
    # Guest info extraction
    guest_obj = res_data.get("guest") or res_data.get("guestDetails", {})
    if isinstance(guest_obj, dict):
        f_name = guest_obj.get("firstName") or ""
        l_name = guest_obj.get("lastName") or ""
        guest_name = (f"{f_name} {l_name}").strip() or guest_obj.get("name", "Unknown Guest")
        guest_email = guest_obj.get("email") or res_data.get("guestEmail")
        guest_mobile = guest_obj.get("phone") or res_data.get("guestMobile")
    else:
        guest_name = res_data.get("guestName", "Unknown Guest")
        guest_email = res_data.get("guestEmail")
        guest_mobile = res_data.get("guestMobile")

    
    if existing_booking:
        existing_booking.guest_name = guest_name
        existing_booking.guest_email = guest_email
        existing_booking.guest_mobile = guest_mobile
        existing_booking.check_in = check_in
        existing_booking.check_out = check_out
        existing_booking.status = "booked"
        existing_booking.external_status = status
        db.commit()
    else:
        # Get adults/children from rooms or root
        adults = res_data.get("adults")
        children = res_data.get("children")
        
        # If not at root, try to sum from rooms list
        if adults is None or children is None:
            adults, children = 0, 0
            for r in res_data.get("rooms", []):
                occ = r.get("occupancy", {})
                adults += int(occ.get("adults", 0))
                children += int(occ.get("children", 0))
        
        # Fallback to defaults
        adults = adults or 2
        children = children or 0

        # Total amount
        amt_obj = res_data.get("amount", {})
        total_amount = res_data.get("totalAmount")
        if total_amount is None:
            total_amount = amt_obj.get("amountAfterTax") or amt_obj.get("total") or 0

        new_booking = Booking(
            guest_name=guest_name,
            guest_email=guest_email,
            guest_mobile=guest_mobile,
            check_in=check_in,
            check_out=check_out,
            adults=adults,
            children=children,
            total_amount=float(total_amount),
            channel=payload.get("channel", "Aiosell"),
            external_booking_id=ext_id,
            external_status=status,
            status="booked"
        )
        db.add(new_booking)
        db.flush()
        
        # Assign Rooms
        rooms_requested = res_data.get("rooms", [])
        for r_req in rooms_requested:
            rtc = r_req.get("roomCode")
            qty = r_req.get("quantity", 1)
            
            available_rooms = db.query(Room).filter(Room.aiosell_room_code == rtc).all()
            
            assigned_count = 0
            for room in available_rooms:
                if assigned_count >= qty:
                    break
                
                is_busy = db.query(BookingRoom).join(Booking).filter(
                    BookingRoom.room_id == room.id,
                    Booking.status.in_(['booked', 'checked-in', 'occupied']),
                    Booking.check_in < check_out,
                    Booking.check_out > check_in
                ).first()
                
                if not is_busy:
                    br = BookingRoom(booking_id=new_booking.id, room_id=room.id)
                    db.add(br)
                    assigned_count += 1
            
            if assigned_count < qty:
                 print(f"Warning: Could not find enough available rooms for {rtc}. Assigned {assigned_count}/{qty}")

        db.commit()
    
    # Trigger inventory sync
    await sync_inventory(db)
    
    return {"status": "success", "booking_id": ext_id}

