from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from typing import List, Optional, Annotated, Any
from PIL import Image
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import text, func
from app.database import SessionLocal
from app.schemas.room import RoomCreate, RoomOut, RoomPaginatedResponse, RoomBookingHistoryItem
from app.curd import room as crud_room
from app.models.room import Room, RoomImage
from app.models.booking import Booking, BookingRoom
import shutil
import os
from uuid import uuid4
from datetime import date

router = APIRouter(prefix="/rooms", tags=["Rooms"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

UPLOAD_DIR = os.path.join("uploads", "rooms")
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure directory exists at startup

def str_to_bool(val) -> bool:
    """Convert form string booleans ('true'/'false') to Python bool."""
    if isinstance(val, bool):
        return val
    if isinstance(val, str):
        return val.strip().lower() == 'true'
    return bool(val)

def save_image_file(image: UploadFile) -> str:
    """Helper to save uploaded image and return the relative URL"""
    try:
        ext = image.filename.split('.')[-1]
        filename = f"room_{uuid4().hex}.{ext}"
        image_path = os.path.join(UPLOAD_DIR, filename)
        
        image.file.seek(0)
        with open(image_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)

        # Generate and Save Thumbnail
        thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
        thumb_path = os.path.join(UPLOAD_DIR, thumb_filename)
        
        image.file.seek(0)
        with Image.open(image.file) as img:
            img.thumbnail((400, 400), Image.Resampling.BICUBIC)
            if img.mode in ("RGBA", "P"):
                img = img.convert("RGB")
            img.save(thumb_path, "JPEG", quality=80)
            
        return f"uploads/rooms/{filename}"
    except Exception as e:
        print(f"Error saving image {image.filename}: {e}")
        raise HTTPException(status_code=500, detail=f"Error saving image: {str(e)}")

# Test endpoint without authentication - handles images
@router.post("/test", response_model=RoomOut)
def create_room_test(
    number: Annotated[Any, Form()] = None,
    type: Annotated[Any, Form()] = None,
    price: Annotated[Any, Form()] = None,
    status: Annotated[Any, Form()] = "Available",
    adults: Annotated[Any, Form()] = 2,
    children: Annotated[Any, Form()] = 0,
    images: Annotated[Any, File()] = None, # Changed to list
    air_conditioning: Annotated[Any, Form()] = False,
    wifi: Annotated[Any, Form()] = False,
    bathroom: Annotated[Any, Form()] = False,
    living_area: Annotated[Any, Form()] = False,
    terrace: Annotated[Any, Form()] = False,
    parking: Annotated[Any, Form()] = False,
    kitchen: Annotated[Any, Form()] = False,
    family_room: Annotated[Any, Form()] = False,
    bbq: Annotated[Any, Form()] = False,
    garden: Annotated[Any, Form()] = False,
    dining: Annotated[Any, Form()] = False,
    breakfast: Annotated[Any, Form()] = False,
    db: Annotated[Any, Depends(get_db)] = None
):
    try:
        # Create Room
        db_room = Room(
            number=number,
            type=type,
            price=price,
            status=status,
            adults=adults,
            children=children,
            air_conditioning=str_to_bool(air_conditioning),
            wifi=str_to_bool(wifi),
            bathroom=str_to_bool(bathroom),
            living_area=str_to_bool(living_area),
            terrace=str_to_bool(terrace),
            parking=str_to_bool(parking),
            kitchen=str_to_bool(kitchen),
            family_room=str_to_bool(family_room),
            bbq=str_to_bool(bbq),
            garden=str_to_bool(garden),
            dining=str_to_bool(dining),
            breakfast=str_to_bool(breakfast)
        )
        db.add(db_room)
        db.flush() # flush to get ID

        # Save images
        primary_image_set = False
        if images:
            # Ensure images is a list
            if not isinstance(images, list):
                images = [images]
            
            for img in images:
                if not img or not getattr(img, 'filename', None): continue
                image_url = save_image_file(img)
                
                # Set primary image if not set
                if not primary_image_set:
                    db_room.image_url = image_url
                    primary_image_set = True
                
                # Add to gallery
                room_image = RoomImage(room_id=db_room.id, image_url=image_url)
                db.add(room_image)

        db.commit()
        db.refresh(db_room)
        return db_room
    except Exception as e:
        db.rollback()
        import traceback
        print(f"Error creating room (test): {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Error creating room: {str(e)}")


# Test endpoint to check if the router is working
@router.get("/test-simple")
def test_simple():
    return {"message": "Room router is working"}

# Test delete endpoint
@router.delete("/test/{room_id}")
def delete_room_test(room_id: int, db: Annotated[Any, Depends(get_db)] = None):
    # This is same as main delete
    return delete_room(room_id, db)

# Test GET endpoint for fetching rooms
@router.get("/test", response_model=RoomPaginatedResponse)
def get_rooms_test(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 100):
    return get_rooms(db, skip, limit)

# ---------------- CREATE ----------------
@router.post("", response_model=RoomOut)
def create_room(
    number: Annotated[Any, Form()] = None,
    type: Annotated[Any, Form()] = None,
    price: Annotated[Any, Form()] = None,
    status: Annotated[Any, Form()] = "Available",
    adults: Annotated[Any, Form()] = 2,
    children: Annotated[Any, Form()] = 0,
    priority: Annotated[Any, Form()] = None,
    images: Annotated[Any, File()] = None, # Changed to list
    air_conditioning: Annotated[Any, Form()] = False,
    wifi: Annotated[Any, Form()] = False,
    bathroom: Annotated[Any, Form()] = False,
    living_area: Annotated[Any, Form()] = False,
    terrace: Annotated[Any, Form()] = False,
    parking: Annotated[Any, Form()] = False,
    kitchen: Annotated[Any, Form()] = False,
    family_room: Annotated[Any, Form()] = False,
    bbq: Annotated[Any, Form()] = False,
    garden: Annotated[Any, Form()] = False,
    dining: Annotated[Any, Form()] = False,
    breakfast: Annotated[Any, Form()] = False,
    aiosell_room_code: Annotated[Any, Form()] = None,
    online_inventory: Annotated[Any, Form()] = 0,
    min_stay: Annotated[Any, Form()] = 1,
    cta: Annotated[Any, Form()] = False,
    ctd: Annotated[Any, Form()] = False,
    rate_plan_mappings: Annotated[Any, Form()] = None, # JSON string
    db: Annotated[Any, Depends(get_db)] = None
):
    try:
        db_room = Room(
            number=number,
            type=type,
            price=price,
            status=status,
            adults=adults,
            children=children,
            priority=priority,
            air_conditioning=str_to_bool(air_conditioning),
            wifi=str_to_bool(wifi),
            bathroom=str_to_bool(bathroom),
            living_area=str_to_bool(living_area),
            terrace=str_to_bool(terrace),
            parking=str_to_bool(parking),
            kitchen=str_to_bool(kitchen),
            family_room=str_to_bool(family_room),
            bbq=str_to_bool(bbq),
            garden=str_to_bool(garden),
            dining=str_to_bool(dining),
            breakfast=str_to_bool(breakfast),
            channel_manager_id=aiosell_room_code,
            online_inventory=int(online_inventory) if online_inventory else 0,
            min_stay=int(min_stay) if min_stay else 1,
            cta=str_to_bool(cta),
            ctd=str_to_bool(ctd)
        )
        db.add(db_room)
        db.flush() 

        # Handle Rate Plan Mappings
        if rate_plan_mappings:
            import json
            from app.models.room import RatePlanMapping
            try:
                mappings = json.loads(rate_plan_mappings)
                for m in mappings:
                    db_mapping = RatePlanMapping(
                        room_id=db_room.id,
                        plan_name=m.get("plan_name"),
                        occupancy=m.get("occupancy", 2),
                        channel_manager_id=m.get("channel_manager_id") if "channel_manager_id" in m else m.get("aiosell_id"),
                        price_offset=float(m.get("price_offset", 0)),
                        offset_percentage=float(m.get("offset_percentage", 0)),
                        fixed_offset=float(m.get("fixed_offset", 0))
                    )
                    db.add(db_mapping)
            except Exception as json_err:
                print(f"Error parsing rate_plan_mappings: {json_err}")

        # Save images
        primary_image_set = False
        if images:
            # Ensure images is a list
            if not isinstance(images, list):
                images = [images]
            
            for img in images:
                if not img or not getattr(img, 'filename', None): continue
                image_url = save_image_file(img)
                
                # Set primary image if not set
                if not primary_image_set:
                    db_room.image_url = image_url
                    primary_image_set = True
                
                # Add to gallery
                room_image = RoomImage(room_id=db_room.id, image_url=image_url)
        db.commit()
        db.refresh(db_room)
        
        try:
            from app.database import SessionLocal
            from app.utils.aiosell_sync import trigger_aiosell_sync
            trigger_aiosell_sync(SessionLocal, "all")
        except: pass

        return db_room
    except Exception as e:
        db.rollback()
        import traceback
        print(f"Error creating room: {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Error creating room: {str(e)}")


# ---------------- READ ----------------
@router.post("/update-statuses")
def update_room_statuses_endpoint(db: Annotated[Any, Depends(get_db)] = None):
    try:
        from app.utils.room_status import update_room_statuses
        update_room_statuses(db)
        return {"message": "Room statuses updated successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating room statuses: {str(e)}")

def _get_rooms_impl(db: Session, skip: int = 0, limit: int = 20):
    try:
        # Simple health check
        try:
            db.execute(text("SELECT 1"))
        except Exception:
             raise HTTPException(status_code=503, detail="Database unavailable")
        
        if limit <= 1000:
            try:
                from app.utils.room_status import update_room_statuses
                update_room_statuses(db)
            except Exception: pass
        
        # RoomImage is loaded via relationship
        total = db.query(Room).count()
        rooms = db.query(Room).options(joinedload(Room.images)).order_by(func.coalesce(Room.priority, 999999).asc()).offset(skip).limit(limit).all()
        return {"total": total, "items": rooms}
        
    except HTTPException: raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching rooms: {str(e)}")

@router.get("", response_model=RoomPaginatedResponse)
def get_rooms(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _get_rooms_impl(db, skip, limit)

@router.get("/", response_model=RoomPaginatedResponse)
def get_rooms_slash(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _get_rooms_impl(db, skip, limit)


# ---------------- DELETE ----------------
@router.delete("/{room_id}")
def delete_room(room_id: int, db: Annotated[Any, Depends(get_db)] = None):
    db_room = db.query(Room).filter(Room.id == room_id).first()
    if db_room is None:
        raise HTTPException(status_code=404, detail="Room not found")

    # Delete all associated images
    for room_image in db_room.images:
        path = room_image.image_url.lstrip("/")
        if os.path.exists(path):
            try: os.remove(path)
            except: pass
        # Thumb
        base, _ = os.path.splitext(path)
        thumb = f"{base}_thumb.jpg"
        if os.path.exists(thumb):
            try: os.remove(thumb)
            except: pass

    # Delete primary image if not in gallery (orphaned check, though likely covered above if we added it to gallery)
    if db_room.image_url:
         path = db_room.image_url.lstrip("/")
         if os.path.exists(path):
             try: os.remove(path)
             except: pass

    db.delete(db_room)
    db.commit()
    return {"message": "Room deleted successfully"}

@router.delete("/images/{image_id}")
def delete_room_image(image_id: int, db: Annotated[Any, Depends(get_db)] = None):
    db_image = db.query(RoomImage).filter(RoomImage.id == image_id).first()
    if not db_image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    room_id = db_image.room_id
    
    # Check if this is the primary image
    room = db.query(Room).filter(Room.id == room_id).first()
    is_primary = room.image_url == db_image.image_url
    
    # Delete file
    path = db_image.image_url.lstrip("/")
    if os.path.exists(path):
        try: os.remove(path)
        except: pass
    
    # Delete thumb
    base, _ = os.path.splitext(path)
    thumb = f"{base}_thumb.jpg"
    if os.path.exists(thumb):
        try: os.remove(thumb)
        except: pass
    
    db.delete(db_image)
    
    # If it was primary, try to set another one as primary
    if is_primary:
        remaining = db.query(RoomImage).filter(RoomImage.room_id == room_id, RoomImage.id != image_id).first()
        room.image_url = remaining.image_url if remaining else None
        
    db.commit()
    return {"message": "Image deleted successfully"}

@router.delete("/{room_id}/legacy-image")
def delete_legacy_image(room_id: int, db: Annotated[Any, Depends(get_db)] = None):
    room = db.query(Room).filter(Room.id == room_id).first()
    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    
    if room.image_url:
        path = room.image_url.lstrip("/")
        if os.path.exists(path):
            try: os.remove(path)
            except: pass
        
        # Delete thumb
        base, _ = os.path.splitext(path)
        thumb = f"{base}_thumb.jpg"
        if os.path.exists(thumb):
            try: os.remove(thumb)
            except: pass
            
        room.image_url = None
        db.commit()
        
    return {"message": "Legacy image deleted successfully"}


# ---------------- UPDATE ----------------
@router.put("/{room_id}", response_model=RoomOut)
def update_room(
    room_id: int,
    number: Annotated[Any, Form()] = None,
    type: Annotated[Any, Form()] = None,
    price: Annotated[Any, Form()] = None,
    status: Annotated[Any, Form()] = None,
    adults: Annotated[Any, Form()] = None,
    children: Annotated[Any, Form()] = None,
    priority: Annotated[Any, Form()] = None,
    images: Annotated[Any, File()] = None, # Add new images
    air_conditioning: Annotated[Any, Form()] = None,
    wifi: Annotated[Any, Form()] = None,
    bathroom: Annotated[Any, Form()] = None,
    living_area: Annotated[Any, Form()] = None,
    terrace: Annotated[Any, Form()] = None,
    parking: Annotated[Any, Form()] = None,
    kitchen: Annotated[Any, Form()] = None,
    family_room: Annotated[Any, Form()] = None,
    bbq: Annotated[Any, Form()] = None,
    garden: Annotated[Any, Form()] = None,
    dining: Annotated[Any, Form()] = None,
    breakfast: Annotated[Any, Form()] = None,
    aiosell_room_code: Annotated[Any, Form()] = None,
    online_inventory: Annotated[Any, Form()] = None,
    min_stay: Annotated[Any, Form()] = None,
    cta: Annotated[Any, Form()] = None,
    ctd: Annotated[Any, Form()] = None,
    rate_plan_mappings: Annotated[Any, Form()] = None, # JSON string
    db: Annotated[Any, Depends(get_db)] = None
):
    try:
        db_room = db.query(Room).filter(Room.id == room_id).first()
        if not db_room:
            raise HTTPException(status_code=404, detail="Room not found")

        # Update basic fields if provided (convert form-data strings to correct types)
        if number is not None: db_room.number = number
        if type is not None: db_room.type = type
        if price is not None: db_room.price = float(price)
        if status is not None: db_room.status = status
        if adults is not None: db_room.adults = int(adults)
        if children is not None: db_room.children = int(children)
        if priority is not None: db_room.priority = int(priority)
        
        # Aiosell Fields
        if aiosell_room_code is not None: db_room.channel_manager_id = aiosell_room_code
        if online_inventory is not None: db_room.online_inventory = int(online_inventory)
        if min_stay is not None: db_room.min_stay = int(min_stay)
        if cta is not None: db_room.cta = str_to_bool(cta)
        if ctd is not None: db_room.ctd = str_to_bool(ctd)

        # Update feature fields (convert string booleans to actual booleans)
        if air_conditioning is not None: db_room.air_conditioning = str_to_bool(air_conditioning)
        if wifi is not None: db_room.wifi = str_to_bool(wifi)
        if bathroom is not None: db_room.bathroom = str_to_bool(bathroom)
        if living_area is not None: db_room.living_area = str_to_bool(living_area)
        if terrace is not None: db_room.terrace = str_to_bool(terrace)
        if parking is not None: db_room.parking = str_to_bool(parking)
        if kitchen is not None: db_room.kitchen = str_to_bool(kitchen)
        if family_room is not None: db_room.family_room = str_to_bool(family_room)
        if bbq is not None: db_room.bbq = str_to_bool(bbq)
        if garden is not None: db_room.garden = str_to_bool(garden)
        if dining is not None: db_room.dining = str_to_bool(dining)
        if breakfast is not None: db_room.breakfast = str_to_bool(breakfast)

        # Handle Rate Plan Mappings
        if rate_plan_mappings:
            import json
            from app.models.room import RatePlanMapping
            try:
                # Remove existing mappings
                db.query(RatePlanMapping).filter(RatePlanMapping.room_id == room_id).delete()
                
                mappings = json.loads(rate_plan_mappings)
                for m in mappings:
                    db_mapping = RatePlanMapping(
                        room_id=db_room.id,
                        plan_name=m.get("plan_name"),
                        occupancy=m.get("occupancy", 2),
                        channel_manager_id=m.get("channel_manager_id") if "channel_manager_id" in m else m.get("aiosell_id"),
                        price_offset=float(m.get("price_offset", 0)),
                        offset_percentage=float(m.get("offset_percentage", 0)),
                        fixed_offset=float(m.get("fixed_offset", 0))
                    )
                    db.add(db_mapping)
            except Exception as json_err:
                print(f"Error parsing rate_plan_mappings: {json_err}")

        # Handle new image uploads
        if images:
            # Ensure images is a list
            if not isinstance(images, list):
                images = [images]
            
            for img in images:
                 if img and getattr(img, 'filename', None):
                    image_url = save_image_file(img)
                    
                    # If room has no image, set this as primary
                    if not db_room.image_url:
                        db_room.image_url = image_url
                    
                    # Add to gallery
                    room_image = RoomImage(room_id=db_room.id, image_url=image_url)
                    db.add(room_image)

        db.commit()
        db.refresh(db_room)
        
        try:
            from app.database import SessionLocal
            from app.utils.aiosell_sync import trigger_aiosell_sync
            trigger_aiosell_sync(SessionLocal, "all")
        except: pass

        return db_room
    except Exception as e:
        db.rollback()
        import traceback
        print(f"Error updating room: {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Error updating room: {str(e)}")


# ---------------- BOOKING HISTORY ----------------
@router.get("/{room_id}/bookings", response_model=List[RoomBookingHistoryItem])
def get_room_bookings(room_id: int, db: Annotated[Any, Depends(get_db)] = None):
    """
    Get all bookings (regular and package) for a specific room.
    """
    from app.models.Package import PackageBooking, PackageBookingRoom
    from app.schemas.room import RoomBookingHistoryItem
    
    # 1. Fetch Regular Bookings
    regular_bookings = (
        db.query(Booking)
        .join(BookingRoom)
        .filter(BookingRoom.room_id == room_id)
        .options(joinedload(Booking.booking_rooms).joinedload(BookingRoom.room))
        .all()
    )
    
    # 2. Fetch Package Bookings
    package_bookings = (
        db.query(PackageBooking)
        .join(PackageBookingRoom)
        .filter(PackageBookingRoom.room_id == room_id)
        .options(joinedload(PackageBooking.package))
        .all()
    )
    
    results = []
    
    # Process Regular Bookings
    for b in regular_bookings:
        # Calculate total if missing (legacy data support)
        calculated_total = b.total_amount
        if not calculated_total or calculated_total == 0:
            stay_days = max(1, (b.check_out - b.check_in).days)
            room_total = sum((br.room.price or 0) for br in b.booking_rooms if br.room)
            calculated_total = room_total * stay_days

        results.append(RoomBookingHistoryItem(
            id=b.id,
            display_id=f"BK-{str(b.id).zfill(6)}",
            booking_type="booking",
            guest_name=b.guest_name,
            guest_email=b.guest_email,
            guest_mobile=b.guest_mobile,
            check_in=str(b.check_in),
            check_out=str(b.check_out),
            status=b.status,
            adults=b.adults,
            children=b.children,
            total_amount=calculated_total,
            package_name=None
        ))
        
    # Process Package Bookings
    for pb in package_bookings:
        # Calculate approximate total per room for package (prorated)? 
        # For simplicity, we'll show the full package price or a note. 
        # Actually, let's just show 0 or the full package price, but usually room history 
        # cares more about dates and guest info.
        
        # Calculate package total
        pkg_price = pb.package.price if pb.package else 0
        stay_days = max(1, (pb.check_out - pb.check_in).days)
        # Total for the whole booking (all rooms)
        # If we want per-room, we'd divide by num rooms, but let's just show total package cost for now
        # or maybe we can't easily know per-room cost without more logic.
        # Let's show the full booking total amount.
        booking_total = pkg_price * stay_days 
        # If multiple rooms, this total is for the whole package booking group. 
        
        results.append(RoomBookingHistoryItem(
            id=pb.id,
            display_id=f"PK-{str(pb.id).zfill(6)}",
            booking_type="package",
            guest_name=pb.guest_name,
            guest_email=pb.guest_email,
            guest_mobile=pb.guest_mobile,
            check_in=str(pb.check_in),
            check_out=str(pb.check_out),
            status=pb.status,
            adults=pb.adults,
            children=pb.children,
            total_amount=booking_total,
            package_name=pb.package.title if pb.package else "Unknown Package"
        ))
    
    # 3. Sort by check-in date descending
    results.sort(key=lambda x: x.check_in, reverse=True)
    
    return results
