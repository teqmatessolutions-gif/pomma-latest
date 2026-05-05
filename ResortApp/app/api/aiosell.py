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

@router.post("/webhook")
async def aiosell_webhook(request: Request, db: Session = Depends(get_db)):
    """
    Receive reservation updates from Aiosell.
    """
    payload = await request.json()
    print(f"Received Aiosell Webhook: {json.dumps(payload)}")
    
    res_data = payload.get("reservation")
    if not res_data:
        return {"status": "error", "message": "No reservation data found"}
    
    ext_id = str(res_data.get("reservationId") or res_data.get("id"))
    status = res_data.get("status", "booked").lower()
    
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
    # Check if booking already exists
    existing_booking = db.query(Booking).filter(Booking.external_booking_id == ext_id).first()
    
    check_in = datetime.strptime(res_data.get("checkIn"), "%Y-%m-%d").date()
    check_out = datetime.strptime(res_data.get("checkOut"), "%Y-%m-%d").date()
    
    guest_name = res_data.get("guestName") or res_data.get("guestDetails", {}).get("name", "Unknown Guest")
    guest_email = res_data.get("guestEmail") or res_data.get("guestDetails", {}).get("email")
    guest_mobile = res_data.get("guestMobile") or res_data.get("guestDetails", {}).get("phone")
    
    if existing_booking:
        # Update existing booking
        # For simplicity, we'll keep the same rooms if dates haven't changed, 
        # but if dates or rooms changed, it's safer to re-assign?
        # Actually, let's just update basic info for now.
        existing_booking.guest_name = guest_name
        existing_booking.guest_email = guest_email
        existing_booking.guest_mobile = guest_mobile
        existing_booking.check_in = check_in
        existing_booking.check_out = check_out
        existing_booking.status = "booked" # Reset to booked if it was cancelled before?
        existing_booking.external_status = status
        db.commit()
    else:
        # Create new booking
        new_booking = Booking(
            guest_name=guest_name,
            guest_email=guest_email,
            guest_mobile=guest_mobile,
            check_in=check_in,
            check_out=check_out,
            adults=res_data.get("adults", 2),
            children=res_data.get("children", 0),
            total_amount=float(res_data.get("totalAmount", 0)),
            channel="Aiosell",
            external_booking_id=ext_id,
            external_status=status,
            status="booked"
        )
        db.add(new_booking)
        db.flush() # Get ID
        
        # Assign Rooms
        rooms_requested = res_data.get("rooms", [])
        for r_req in rooms_requested:
            rtc = r_req.get("roomCode")
            qty = r_req.get("quantity", 1)
            
            # Find available rooms of this type
            # This is a simplified "find first available" logic
            available_rooms = db.query(Room).filter(Room.aiosell_room_code == rtc).all()
            
            assigned_count = 0
            for room in available_rooms:
                if assigned_count >= qty:
                    break
                
                # Double check availability for these dates
                # (Overlapping check)
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
    
    # Trigger inventory sync after processing
    await sync_inventory(db)
    
    return {"status": "success", "booking_id": ext_id}
