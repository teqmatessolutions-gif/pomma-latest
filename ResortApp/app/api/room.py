from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from typing import List, Optional
from PIL import Image
from sqlalchemy.orm import Session
from sqlalchemy import text, func
from app.database import SessionLocal
from app.schemas.room import RoomCreate, RoomOut
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
os.makedirs(UPLOAD_DIR, exist_ok=True)

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
    number: str = Form(...),
    type: str = Form(...),
    price: float = Form(...),
    status: str = Form("Available"),
    adults: int = Form(2),
    children: int = Form(0),
    images: List[UploadFile] = File(None), # Changed to list
    air_conditioning: bool = Form(False),
    wifi: bool = Form(False),
    bathroom: bool = Form(False),
    living_area: bool = Form(False),
    terrace: bool = Form(False),
    parking: bool = Form(False),
    kitchen: bool = Form(False),
    family_room: bool = Form(False),
    bbq: bool = Form(False),
    garden: bool = Form(False),
    dining: bool = Form(False),
    breakfast: bool = Form(False),
    db: Session = Depends(get_db)
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
            air_conditioning=air_conditioning,
            wifi=wifi,
            bathroom=bathroom,
            living_area=living_area,
            terrace=terrace,
            parking=parking,
            kitchen=kitchen,
            family_room=family_room,
            bbq=bbq,
            garden=garden,
            dining=dining,
            breakfast=breakfast
        )
        db.add(db_room)
        db.flush() # flush to get ID

        # Save images
        primary_image_set = False
        if images:
            for img in images:
                if not img.filename: continue
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
        print(f"Error creating room: {e}")
        raise HTTPException(status_code=500, detail=f"Error creating room: {str(e)}")


# Test endpoint to check if the router is working
@router.get("/test-simple")
def test_simple():
    return {"message": "Room router is working"}

# Test delete endpoint
@router.delete("/test/{room_id}")
def delete_room_test(room_id: int, db: Session = Depends(get_db)):
    # This is same as main delete
    return delete_room(room_id, db)

# Test GET endpoint for fetching rooms
@router.get("/test", response_model=list[RoomOut])
def get_rooms_test(db: Session = Depends(get_db), skip: int = 0, limit: int = 100):
    return get_rooms(db, skip, limit)

# ---------------- CREATE ----------------
@router.post("", response_model=RoomOut)
def create_room(
    number: str = Form(...),
    type: str = Form(...),
    price: float = Form(...),
    status: str = Form("Available"),
    adults: int = Form(2),
    children: int = Form(0),
    priority: int = Form(None),
    images: List[UploadFile] = File(None), # Changed to list
    air_conditioning: bool = Form(False),
    wifi: bool = Form(False),
    bathroom: bool = Form(False),
    living_area: bool = Form(False),
    terrace: bool = Form(False),
    parking: bool = Form(False),
    kitchen: bool = Form(False),
    family_room: bool = Form(False),
    bbq: bool = Form(False),
    garden: bool = Form(False),
    dining: bool = Form(False),
    breakfast: bool = Form(False),
    db: Session = Depends(get_db)
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
            air_conditioning=air_conditioning,
            wifi=wifi,
            bathroom=bathroom,
            living_area=living_area,
            terrace=terrace,
            parking=parking,
            kitchen=kitchen,
            family_room=family_room,
            bbq=bbq,
            garden=garden,
            dining=dining,
            breakfast=breakfast
        )
        db.add(db_room)
        db.flush() 

        # Save images
        primary_image_set = False
        if images:
            for img in images:
                if not img.filename: continue
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
        print(f"Error creating room: {e}")
        raise HTTPException(status_code=500, detail=f"Error creating room: {str(e)}")


# ---------------- READ ----------------
@router.post("/update-statuses")
def update_room_statuses_endpoint(db: Session = Depends(get_db)):
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
        rooms = db.query(Room).order_by(func.coalesce(Room.priority, 999999).asc()).offset(skip).limit(limit).all()
        return rooms
        
    except HTTPException: raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching rooms: {str(e)}")

@router.get("", response_model=list[RoomOut])
def get_rooms(db: Session = Depends(get_db), skip: int = 0, limit: int = 20):
    return _get_rooms_impl(db, skip, limit)

@router.get("/", response_model=list[RoomOut])
def get_rooms_slash(db: Session = Depends(get_db), skip: int = 0, limit: int = 20):
    return _get_rooms_impl(db, skip, limit)


# ---------------- DELETE ----------------
@router.delete("/{room_id}")
def delete_room(room_id: int, db: Session = Depends(get_db)):
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
def delete_room_image(image_id: int, db: Session = Depends(get_db)):
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
def delete_legacy_image(room_id: int, db: Session = Depends(get_db)):
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
    number: Optional[str] = Form(None),
    type: Optional[str] = Form(None),
    price: Optional[float] = Form(None),
    status: Optional[str] = Form(None),
    adults: Optional[int] = Form(None),
    children: Optional[int] = Form(None),
    priority: Optional[int] = Form(None),
    images: List[UploadFile] = File(None), # Add new images
    air_conditioning: Optional[bool] = Form(None),
    wifi: Optional[bool] = Form(None),
    bathroom: Optional[bool] = Form(None),
    living_area: Optional[bool] = Form(None),
    terrace: Optional[bool] = Form(None),
    parking: Optional[bool] = Form(None),
    kitchen: Optional[bool] = Form(None),
    family_room: Optional[bool] = Form(None),
    bbq: Optional[bool] = Form(None),
    garden: Optional[bool] = Form(None),
    dining: Optional[bool] = Form(None),
    breakfast: Optional[bool] = Form(None),
    db: Session = Depends(get_db)
):
    db_room = db.query(Room).filter(Room.id == room_id).first()
    if not db_room:
        raise HTTPException(status_code=404, detail="Room not found")

    # Update basic fields if provided
    if number is not None: db_room.number = number
    if type is not None: db_room.type = type
    if price is not None: db_room.price = price
    if status is not None: db_room.status = status
    if adults is not None: db_room.adults = adults
    if children is not None: db_room.children = children
    if priority is not None: db_room.priority = priority
    
    # Update feature fields
    if air_conditioning is not None: db_room.air_conditioning = air_conditioning
    if wifi is not None: db_room.wifi = wifi
    if bathroom is not None: db_room.bathroom = bathroom
    if living_area is not None: db_room.living_area = living_area
    if terrace is not None: db_room.terrace = terrace
    if parking is not None: db_room.parking = parking
    if kitchen is not None: db_room.kitchen = kitchen
    if family_room is not None: db_room.family_room = family_room
    if bbq is not None: db_room.bbq = bbq
    if garden is not None: db_room.garden = garden
    if dining is not None: db_room.dining = dining
    if breakfast is not None: db_room.breakfast = breakfast

    # Handle new image uploads
    if images:
        for img in images:
             if img.filename:
                image_url = save_image_file(img)
                
                # If room has no image, set this as primary
                if not db_room.image_url:
                    db_room.image_url = image_url
                
                # Add to gallery
                room_image = RoomImage(room_id=db_room.id, image_url=image_url)
                db.add(room_image)

    db.commit()
    db.refresh(db_room)
    return db_room

