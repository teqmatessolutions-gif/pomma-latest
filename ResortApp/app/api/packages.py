from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, BackgroundTasks
from sqlalchemy.orm import Session, joinedload
from typing import List, Union, Optional, Annotated, Any
import os
from app.models.user import User
from app.models.room import Room
from app.models.Package import Package, PackageBooking, PackageBookingRoom
from app.models.frontend import ResortInfo
from app.utils.auth import get_db, get_current_user
from app.utils.booking_id import parse_display_id
from app.schemas.packages import PackageBookingCreate, PackageOut, PackageBookingOut, PackageBookingPaginationOut
from fastapi.responses import FileResponse
from app.curd import packages as crud_package
import shutil
import uuid
from PIL import Image
import io

router = APIRouter(prefix="/packages", tags=["Packages"])

UPLOAD_DIR = "uploads/packages"
CHECKIN_UPLOAD_DIR = "uploads/checkin_proofs"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure directory exists at startup
os.makedirs(CHECKIN_UPLOAD_DIR, exist_ok=True)  # Ensure directory exists at startup


# ------------------- Packages -------------------

@router.post("", response_model=PackageOut)
async def create_package_api(
    title: Annotated[Any, Form()] = None,
    description: Annotated[Any, Form()] = None,
    price: Annotated[Any, Form()] = None,
    booking_type: Annotated[Any, Form()] = "room_type",
    room_types: Annotated[Any, Form()] = None,  # Comma-separated list of room types
    status: Annotated[Any, Form()] = "Available",
    priority: Annotated[Any, Form()] = None,
    images: Annotated[Any, File()] = [],
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    try:
        # Validate booking_type
        if booking_type not in ["whole_property", "room_type"]:
            raise HTTPException(status_code=400, detail="booking_type must be either 'whole_property' or 'room_type'")
        
        # If booking_type is room_type, room_types must be provided
        if booking_type == "room_type" and not room_types:
            raise HTTPException(status_code=400, detail="room_types is required when booking_type is 'room_type'")
        
        # If booking_type is whole_property, room_types should be empty
        if booking_type == "whole_property":
            room_types = None
        
        image_urls = []
        try:
            if images is not None:
                # Ensure images is a list
                if not isinstance(images, list):
                    images = [images]
            
                for img in images:
                    if not img or not getattr(img, 'filename', None):
                        continue
                    # Generate unique filename
                    original_filename = img.filename if img.filename else "image.jpg"
                    filename = f"pkg_{uuid.uuid4().hex}_{original_filename}"
                    file_path = os.path.join(UPLOAD_DIR, filename)
                    
                    # Write to disk
                    try:
                        contents = await img.read()
                        with open(file_path, "wb") as buffer:
                            buffer.write(contents)
                    except Exception as file_err:
                        print(f"Error saving file {filename}: {file_err}")
                        continue
                    
                    # Store with leading slash
                    normalized_path = file_path.replace('\\', '/')
                    image_urls.append(f"/{normalized_path}")

                    # Generate and Save Thumbnail
                    try:
                        thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
                        thumb_path = os.path.join(UPLOAD_DIR, thumb_filename)
                        with Image.open(io.BytesIO(contents)) as img_pil:
                            img_pil.thumbnail((200, 200), Image.Resampling.LANCZOS)
                            if img_pil.mode in ("RGBA", "P"):
                                img_pil = img_pil.convert("RGB")
                            img_pil.save(thumb_path, "JPEG", quality=60, optimize=True)
                    except Exception as thumb_error:
                        print(f"Warning: Failed to generate thumbnail for {filename}: {thumb_error}")

        except Exception as img_error:
            import traceback
            error_detail = f"Failed to save package images: {str(img_error)}\n{traceback.format_exc()}"
            print(f"ERROR: {error_detail}")
            import sys
            sys.stderr.write(f"ERROR in create_package_api (image upload): {error_detail}\n")
            raise HTTPException(status_code=500, detail=f"Failed to upload images: {str(img_error)}")

        try:
            return crud_package.create_package(db, title, description, price, image_urls, booking_type, room_types, status, priority)
        except Exception as db_error:
            import traceback
            error_detail = f"Failed to create package in database: {str(db_error)}\n{traceback.format_exc()}"
            print(f"ERROR: {error_detail}")
            import sys
            sys.stderr.write(f"ERROR in create_package_api (database): {error_detail}\n")
            # Clean up uploaded images if package creation fails
            for img_url in image_urls:
                try:
                    # Remove leading slash to get actual file path
                    file_path = img_url.lstrip('/')
                    if os.path.exists(file_path):
                        os.remove(file_path)
                except Exception as cleanup_error:
                    print(f"Warning: Failed to cleanup image {img_url}: {str(cleanup_error)}")
            raise HTTPException(status_code=500, detail=f"Failed to create package: {str(db_error)}")
    except HTTPException:
        # Re-raise HTTP exceptions (like validation errors) as-is
        raise
    except Exception as e:
        import traceback
        error_detail = f"Unexpected error in create_package_api: {str(e)}\n{traceback.format_exc()}"
        print(f"ERROR: {error_detail}")
        import sys
        sys.stderr.write(f"ERROR in create_package_api: {error_detail}\n")
        raise HTTPException(status_code=500, detail=f"Failed to create package: {str(e)}")


@router.put("/{package_id}", response_model=PackageOut)
async def update_package_api(
    package_id: int,
    title: Annotated[Any, Form()] = None,
    description: Annotated[Any, Form()] = None,
    price: Annotated[Any, Form()] = None,
    booking_type: Annotated[Any, Form()] = "room_type",
    room_types: Annotated[Any, Form()] = None,  # Comma-separated list of room types
    status: Annotated[Any, Form()] = "Available",
    priority: Annotated[Any, Form()] = None,
    keep_image_ids: Annotated[Any, Form()] = "",
    images: Annotated[Any, File()] = [],
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    # Validate booking_type
    if booking_type not in ["whole_property", "room_type"]:
        raise HTTPException(status_code=400, detail="booking_type must be either 'whole_property' or 'room_type'")
    
    # If booking_type is room_type, room_types must be provided
    if booking_type == "room_type" and not room_types:
        raise HTTPException(status_code=400, detail="room_types is required when booking_type is 'room_type'")
    
    # If booking_type is whole_property, room_types should be empty
    if booking_type == "whole_property":
        room_types = None
    
    # Get existing package
    package = db.query(Package).filter(Package.id == package_id).first()
    if not package:
        raise HTTPException(status_code=404, detail="Package not found")
    
    # Update package fields
    package.title = title
    package.description = description
    package.price = price
    package.booking_type = booking_type
    package.room_types = room_types
    package.status = status
    package.priority = priority
    
    # Add new images if provided
    if images is not None:
        # Ensure images is a list
        if not isinstance(images, list):
            images = [images]
            
        image_urls = []
        for img in images:
            if not img or not getattr(img, 'filename', None):
                continue
            # Generate unique filename
            filename = f"pkg_{uuid.uuid4().hex}_{img.filename}"
            file_path = os.path.join(UPLOAD_DIR, filename)
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(img.file, buffer)
            # Store with leading slash for proper URL construction
            normalized_path = file_path.replace('\\', '/')
            image_urls.append(f"/{normalized_path}")

            # Generate and Save Thumbnail
            try:
                thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
                thumb_path = os.path.join(UPLOAD_DIR, thumb_filename)
                
                img.file.seek(0) 
                file_content = img.file.read()
                
                with Image.open(io.BytesIO(file_content)) as img_pil:
                   img_pil.thumbnail((200, 200), Image.Resampling.BICUBIC)
                   if img_pil.mode in ("RGBA", "P"):
                       img_pil = img_pil.convert("RGB")
                   img_pil.save(thumb_path, "JPEG", quality=60)
            except Exception as thumb_error:
                print(f"Warning: Failed to generate thumbnail for {filename}: {thumb_error}")
        
        # Add new images to existing ones
        for url in image_urls:
            from app.models.Package import PackageImage
            img = PackageImage(package_id=package.id, image_url=url)
            db.add(img)

    # Handle deletion of removed images
    if keep_image_ids is not None:
        # Parse kept IDs
        keep_ids = []
        if keep_image_ids.strip():
            keep_ids = [int(id_str) for id_str in keep_image_ids.split(",") if id_str.strip().isdigit()]
            
        # Fetch current images
        from app.models.Package import PackageImage
        current_existing_images = db.query(PackageImage).filter(PackageImage.package_id == package.id).all()
        
        for img_obj in current_existing_images:
            if img_obj.id not in keep_ids:
                # This image was removed in UI, delete it
                try:
                    # Remove file from disk
                    if img_obj.image_url:
                        file_path = img_obj.image_url.lstrip('/')
                        if os.path.exists(file_path):
                            os.remove(file_path)
                        
                        # Try to remove thumbnail too
                        # Thumbnail path logic: uploads/packages/filename_thumb.jpg
                        # Original path: /uploads/packages/filename.jpg
                        dir_name = os.path.dirname(file_path)
                        base_name = os.path.basename(file_path)
                        name_part, ext_part = os.path.splitext(base_name)
                        thumb_name = f"{name_part}_thumb.jpg" # Usually we enforce jpg for thumbs
                        thumb_path = os.path.join(dir_name, thumb_name)
                        if os.path.exists(thumb_path):
                            os.remove(thumb_path)

                except Exception as e:
                    print(f"Warning: Failed to delete image file {img_obj.image_url}: {e}")
                
                # Remove from DB
                db.delete(img_obj)

    
    db.commit()
    db.refresh(package)
    return package


@router.delete("/{package_id}")
def delete_package_api(package_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    success = crud_package.delete_package(db, package_id)
    return {"deleted": success}


# ------------------- Package Bookings -------------------

@router.post("/book", response_model=PackageBookingOut)
def book_package_api(
    booking: PackageBookingCreate,
    background_tasks: BackgroundTasks,
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    result = crud_package.book_package(db, booking)
    
    # Calculate booking charges and send confirmation email if email address is provided
    if booking.guest_email and result:
        try:
            from app.utils.email import send_email, create_booking_confirmation_email
            from datetime import datetime, date
            
            # Get package details
            package = db.query(Package).filter(Package.id == booking.package_id).first()
            
            # Calculate stay duration
            check_in_date = result.check_in if isinstance(result.check_in, date) else datetime.strptime(str(result.check_in), '%Y-%m-%d').date()
            check_out_date = result.check_out if isinstance(result.check_out, date) else datetime.strptime(str(result.check_out), '%Y-%m-%d').date()
            stay_nights = max(1, (check_out_date - check_in_date).days)
            
            # Calculate package charges (package price per night per room)
            package_price = package.price if package else 0
            package_charges = package_price * stay_nights * len(booking.room_ids) if booking.room_ids else package_price * stay_nights
            
            # Get room details with prices
            rooms_data = []
            for pbr in result.rooms:
                if pbr.room:
                    rooms_data.append({
                        'number': pbr.room.number,
                        'type': pbr.room.type or 'Standard',
                        'price': pbr.room.price or 0
                    })
            
            # Format booking ID (PK-000001)
            formatted_booking_id = f"PK-{str(result.id).zfill(6)}"
            
            # Fetch Resort Info
            resort_info_data = {}
            try:
                resort_info_obj = db.query(ResortInfo).filter(ResortInfo.is_active == True).first()
                if resort_info_obj:
                    resort_info_data = {
                        "name": resort_info_obj.name,
                        "support_email": resort_info_obj.support_email,
                        "gst_no": resort_info_obj.gst_no
                    }
            except Exception as e:
                print(f"Failed to fetch resort info: {str(e)}")

            email_html = create_booking_confirmation_email(
                guest_name=result.guest_name,
                booking_id=result.id,
                booking_type='package',
                check_in=str(result.check_in),
                check_out=str(result.check_out),
                rooms=rooms_data,
                total_amount=package_charges,
                package_name=package.title if package else None,
                guests={'adults': booking.adults, 'children': booking.children},
                guest_mobile=booking.guest_mobile,
                package_charges=package_charges,
                stay_nights=stay_nights,
                resort_info=resort_info_data
            )
            
            # Use background task for email
            resort_name = resort_info_data.get("name", "Elysian Retreat")
            background_tasks.add_task(
                send_email,
                to_email=booking.guest_email,
                subject=f"Package Booking Confirmation {formatted_booking_id} - {resort_name}",
                html_content=email_html,
                to_name=result.guest_name,
                sender_name=resort_name
            )
        except Exception as e:
            # Log error but don't fail the booking
            print(f"Failed to queue confirmation email: {str(e)}")
    
    return result

@router.post("/book/guest", response_model=PackageBookingOut, summary="Book a package as a guest")
def book_package_guest_api(
    booking: PackageBookingCreate,
    background_tasks: BackgroundTasks,
    db: Annotated[Any, Depends(get_db)] = None
):
    """
    Public endpoint for guests to book a package without authentication.
    """
    try:
        result = crud_package.book_package(db, booking)
        
        # Calculate booking charges and send confirmation email if email address is provided
        if result:
            # Normalize email for sending
            guest_email = None
            try:
                if booking.guest_email:
                    guest_email = booking.guest_email.strip() if isinstance(booking.guest_email, str) and booking.guest_email.strip() else None
            except (AttributeError, TypeError):
                pass
            
            if guest_email:
                try:
                    from app.utils.email import send_email, create_booking_confirmation_email
                    from datetime import datetime, date
                    
                    # Get package details
                    package = db.query(Package).filter(Package.id == booking.package_id).first()
                    
                    # Calculate stay duration
                    check_in_date = result.check_in if isinstance(result.check_in, date) else datetime.strptime(str(result.check_in), '%Y-%m-%d').date()
                    check_out_date = result.check_out if isinstance(result.check_out, date) else datetime.strptime(str(result.check_out), '%Y-%m-%d').date()
                    stay_nights = max(1, (check_out_date - check_in_date).days)
                    
                    # Calculate package charges (package price per night per room)
                    package_price = package.price if package else 0
                    package_charges = package_price * stay_nights * len(booking.room_ids) if booking.room_ids else package_price * stay_nights
                    
                    # Get room details with prices
                    rooms_data = []
                    for pbr in result.rooms:
                        if pbr.room:
                            rooms_data.append({
                                'number': pbr.room.number,
                                'type': pbr.room.type or 'Standard',
                                'price': pbr.room.price or 0
                            })
                    
                    # Format booking ID (PK-000001)
                    formatted_booking_id = f"PK-{str(result.id).zfill(6)}"
                    
                    # Fetch Resort Info
                    resort_info_data = {}
                    try:
                        resort_info_obj = db.query(ResortInfo).filter(ResortInfo.is_active == True).first()
                        if resort_info_obj:
                            resort_info_data = {
                                "name": resort_info_obj.name,
                                "support_email": resort_info_obj.support_email,
                                "gst_no": resort_info_obj.gst_no
                            }
                    except Exception as e:
                        print(f"Failed to fetch resort info: {str(e)}")

                    email_html = create_booking_confirmation_email(
                        guest_name=result.guest_name,
                        booking_id=result.id,
                        booking_type='package',
                        check_in=str(result.check_in),
                        check_out=str(result.check_out),
                        rooms=rooms_data,
                        total_amount=package_charges,
                        package_name=package.title if package else None,
                        guests={'adults': booking.adults, 'children': booking.children},
                        guest_mobile=booking.guest_mobile,
                        package_charges=package_charges,
                        stay_nights=stay_nights,
                        resort_info=resort_info_data
                    )
                    
                    # Use background task for email
                    resort_name = resort_info_data.get("name", "Elysian Retreat")
                    background_tasks.add_task(
                        send_email,
                        to_email=guest_email,
                        subject=f"Package Booking Confirmation {formatted_booking_id} - {resort_name}",
                        html_content=email_html,
                        to_name=result.guest_name,
                        sender_name=resort_name
                    )
                except Exception as e:
                    # Log error but don't fail the booking
                    print(f"Failed to queue confirmation email: {str(e)}")
        
        return result
        
    except HTTPException:
        # Re-raise HTTP exceptions (like validation errors) as-is
        raise
    except Exception as e:
        # Log the full error for debugging
        import traceback
        error_trace = traceback.format_exc()
        print(f"Error in book_package_guest_api: {str(e)}")
        print(f"Traceback: {error_trace}")
        
        # Return a user-friendly error message
        raise HTTPException(
            status_code=500,
            detail=f"Failed to create package booking: {str(e)}"
        )

@router.get("/bookingsall", response_model=PackageBookingPaginationOut)
def get_bookings(
    db: Annotated[Any, Depends(get_db)] = None, 
    skip: int = 0, 
    limit: int = 20,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    fromDate: Optional[str] = None,
    toDate: Optional[str] = None
):
    from datetime import datetime
    
    try:
        # It's possible for a package to be deleted, leaving an orphaned booking.
        # We must filter to only include bookings that still have a valid package_id.
        # We also need to eagerly load the related package and room data for the frontend.
        query = db.query(PackageBooking).options(
            joinedload(PackageBooking.package),
            joinedload(PackageBooking.rooms).joinedload(PackageBookingRoom.room)
        ).filter(PackageBooking.package_id.is_not(None))
        
        # Date filtering
        final_start = from_date or fromDate
        final_end = to_date or toDate
        
        try:
            if final_start and final_end:
                dt_start = datetime.strptime(final_start, "%Y-%m-%d").date()
                dt_end = datetime.strptime(final_end, "%Y-%m-%d").date()
                # Robust date overlap logic: (booking.check_in < requested_check_out AND booking.check_out > requested_check_in)
                query = query.filter(
                    PackageBooking.check_in < dt_end,
                    PackageBooking.check_out > dt_start
                )
            elif final_start:
                dt_start = datetime.strptime(final_start, "%Y-%m-%d").date()
                query = query.filter(PackageBooking.check_in >= dt_start)
            elif final_end:
                dt_end = datetime.strptime(final_end, "%Y-%m-%d").date()
                query = query.filter(PackageBooking.check_in <= dt_end)
                    
        except Exception as e:
            print(f"ERROR parsing dates in package bookings: {e}")
        
        # Calculate total count before pagination
        total = query.count()
        
        result = query.offset(skip).limit(limit).all()
        result_items = result if result is not None else []
        
        page = (skip // limit) + 1 if limit > 0 else 1
        return {
            "items": result_items,
            "total": total,
            "page": page,
            "limit": limit
        }
    except Exception as e:
        import traceback
        error_detail = f"Failed to fetch package bookings: {str(e)}\n{traceback.format_exc()}"
        print(f"ERROR: {error_detail}")
        import sys
        sys.stderr.write(f"ERROR in /packages/bookingsall: {error_detail}\n")
        # Return empty pagination structure to prevent frontend breakage
        print(f"Unexpected error in package bookings endpoint, returning empty list: {str(e)}")
        return {
            "items": [],
            "total": 0,
            "page": 1,
            "limit": limit
        }


def _list_packages_impl(db: Session, skip: int = 0, limit: int = 20):
    """Helper function for list_packages"""
    try:
        # Use CRUD function which has the correct sorting logic (priority based)
        return crud_package.get_packages(db, skip=skip, limit=limit)
    except Exception as e:
        import traceback
        error_detail = f"Failed to fetch packages: {str(e)}\n{traceback.format_exc()}"
        print(f"ERROR: {error_detail}")
        import sys
        sys.stderr.write(f"ERROR in /packages: {error_detail}\n")
        # Return empty list to prevent frontend breakage
        print(f"Unexpected error in packages endpoint, returning empty list: {str(e)}")
        return []

@router.get("", response_model=List[PackageOut])
def list_packages(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _list_packages_impl(db, skip, limit)

@router.get("/", response_model=List[PackageOut])  # Handle trailing slash
def list_packages_slash(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _list_packages_impl(db, skip, limit)


@router.get("/{package_id}", response_model=PackageOut)
def get_package_api(package_id: int, db: Annotated[Any, Depends(get_db)] = None):
    return crud_package.get_package(db, package_id)


@router.delete("/booking/{booking_id}")
def delete_package_booking_api(booking_id: Union[str, int], db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    # Parse display ID (PK-000001) or accept numeric ID
    numeric_id, booking_type = parse_display_id(str(booking_id))
    if numeric_id is None:
        raise HTTPException(status_code=400, detail=f"Invalid booking ID format: {booking_id}")
    if booking_type and booking_type != "package":
        raise HTTPException(status_code=400, detail=f"Invalid booking type. Expected package booking, got: {booking_id}")
    booking_id = numeric_id
    
    success = crud_package.delete_package_booking(db, booking_id)
    if not success:
        raise HTTPException(status_code=404, detail="Booking not found")
    return {"deleted": success}

# ------------------- Cancel a package booking -------------------
@router.put("/booking/{booking_id}/cancel", response_model=PackageBookingOut)
def cancel_package_booking(booking_id: Union[str, int], db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    # Parse display ID (PK-000001) or accept numeric ID
    numeric_id, booking_type = parse_display_id(str(booking_id))
    if numeric_id is None:
        raise HTTPException(status_code=400, detail=f"Invalid booking ID format: {booking_id}")
    if booking_type and booking_type != "package":
        raise HTTPException(status_code=400, detail=f"Invalid booking type. Expected package booking, got: {booking_id}")
    booking_id = numeric_id
    
    booking = db.query(PackageBooking).filter(PackageBooking.id == booking_id).first()
    if not booking:
        raise HTTPException(status_code=404, detail="Package booking not found")

    # Free rooms back to Available
    if booking.rooms:
        room_ids = [br.room_id for br in booking.rooms]
        db.query(Room).filter(Room.id.in_(room_ids)).update({"status": "Available"}, synchronize_session=False)

    booking.status = "cancelled"
    db.commit()
    db.refresh(booking)
    return booking

@router.put("/booking/{booking_id}/extend", response_model=PackageBookingOut)
def extend_package_booking_checkout(booking_id: Union[str, int], new_checkout: str, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    """
    Extend the checkout date for a package booking.
    Validates that the new checkout date is after the current checkout date
    and checks for conflicts with other bookings on the same rooms.
    Accepts both display ID (PK-000001) and numeric ID.
    """
    from datetime import datetime
    from sqlalchemy import and_, or_
    
    # Parse display ID (PK-000001) or accept numeric ID
    numeric_id, booking_type = parse_display_id(str(booking_id))
    if numeric_id is None:
        raise HTTPException(status_code=400, detail=f"Invalid booking ID format: {booking_id}")
    if booking_type and booking_type != "package":
        raise HTTPException(status_code=400, detail=f"Invalid booking type. Expected package booking, got: {booking_id}")
    booking_id = numeric_id
    
    # Parse the new checkout date string to a date object
    try:
        new_checkout_date = datetime.strptime(new_checkout, '%Y-%m-%d').date()
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD format")
    
    # Fetch the package booking with its rooms
    booking = db.query(PackageBooking).options(
        joinedload(PackageBooking.rooms).joinedload(PackageBookingRoom.room)
    ).filter(PackageBooking.id == booking_id).first()
    
    if not booking:
        raise HTTPException(status_code=404, detail="Package booking not found")
    
    # IMPORTANT: Refresh the booking from database to get the latest status
    # This ensures we have the most current status, not a stale cached value
    db.refresh(booking)
    
    # Check if booking is in a valid state for extension
    # Normalize status: convert to lowercase and replace underscores/hyphens with hyphens for consistent comparison
    if not booking.status:
        raise HTTPException(
            status_code=400, 
            detail="Booking status is missing. Cannot extend checkout."
        )
    
    # Normalize status: handle variations like "booked", "Booked", "BOOKED", "checked-in", "checked_in", "checked-out", "checked_out"
    raw_status_lower = booking.status.lower().strip() if booking.status else ''
    # Replace underscores and spaces with hyphens, but be careful not to break "booked"
    normalized_status = raw_status_lower.replace('_', '-').replace(' ', '-')
    
    # Debug: Print the actual status values for troubleshooting
    print(f"[DEBUG] Extend package booking - ID: {booking_id}")
    print(f"[DEBUG]   Guest: {booking.guest_name}")
    print(f"[DEBUG]   Original status from DB: '{booking.status}'")
    print(f"[DEBUG]   Raw lower: '{raw_status_lower}'")
    print(f"[DEBUG]   Normalized: '{normalized_status}'")
    print(f"[DEBUG]   Check-in: {booking.check_in}, Check-out: {booking.check_out}")
    
    # First, check if it's explicitly "booked" - this should always be allowed and skip all other checks
    is_booked = normalized_status == 'booked' or raw_status_lower == 'booked'
    
    if is_booked:
        # "booked" status is always valid for extension - skip all other checks
        print(f"[DEBUG]   Status is 'booked' - allowing extension without further checks")
        # Continue to date validation and conflict checks below
    else:
        # For non-"booked" statuses, check if it's checked-out
        # Check if it's checked-out (must end with "-out" or be exactly "checked_out")
        # This ensures "checked-in" is NOT matched
        # Be very specific: only match if it explicitly contains "checked" and "out"
        is_checked_out = False
        if normalized_status == 'checked-out' or raw_status_lower in ['checked_out', 'checked-out', 'checked out']:
            is_checked_out = True
        elif normalized_status.startswith('checked-') and normalized_status.endswith('-out'):
            is_checked_out = True
        
        # Check if it's a valid status for extension (checked-in)
        is_valid_for_extension = (
            normalized_status == 'checked-in' or
            raw_status_lower in ['checked_in', 'checked-in', 'checked in']
        )
        
        print(f"[DEBUG]   Is valid for extension: {is_valid_for_extension}")
        print(f"[DEBUG]   Is checked out: {is_checked_out}")
        print(f"[DEBUG]   Has check-in images: id_card={bool(booking.id_card_image_url)}, guest_photo={bool(booking.guest_photo_url)}")
        
        # Special case: If status is "checked_out" but has check-in images, it might be a data inconsistency
        # Also check if check-out date is in the future (guest is still checked in)
        from datetime import date
        has_checkin_images = bool(booking.id_card_image_url) or bool(booking.guest_photo_url)
        today = date.today()
        checkout_is_future = booking.check_out >= today
        
        # If status says "checked_out" but:
        # 1. Has check-in images (guest was checked in), OR
        # 2. Check-out date is today or in the future (guest should still be checked in)
        # Then treat as checked-in for extension purposes
        if is_checked_out and (has_checkin_images or checkout_is_future):
            print(f"[DEBUG]   WARNING: Status is 'checked_out' but has check-in images or future checkout date.")
            print(f"[DEBUG]   Has check-in images: {has_checkin_images}, Checkout is future: {checkout_is_future}")
            print(f"[DEBUG]   Allowing extension due to data inconsistency - treating as checked-in.")
            # Treat as checked-in for extension purposes
            is_checked_out = False
            is_valid_for_extension = True
        
        # Reject checked-out statuses first (unless they have check-in images)
        if is_checked_out:
            raise HTTPException(
                status_code=400, 
                detail=f"Cannot extend checkout for package booking with status '{booking.status}'. The guest has already checked out. If this booking was checked in, please refresh the page or contact support."
            )
        
        # Then check if it's a valid status for extension
        if not is_valid_for_extension:
            raise HTTPException(
                status_code=400, 
                detail=f"Cannot extend checkout for package booking with status '{booking.status}'. Only 'booked' or 'checked-in' bookings can be extended."
            )
    
    # Validate that new checkout date is after current checkout date
    if new_checkout_date <= booking.check_out:
        raise HTTPException(
            status_code=400, 
            detail=f"New checkout date ({new_checkout_date}) must be after current checkout date ({booking.check_out})"
        )
    
    # Check for conflicts with other bookings on the same rooms
    room_ids = [br.room_id for br in booking.rooms if br.room_id]
    
    if room_ids:
        # Check for conflicts with regular bookings
        from app.models.booking import Booking, BookingRoom
        conflicting_bookings = db.query(Booking).join(BookingRoom).filter(
            BookingRoom.room_id.in_(room_ids),
            Booking.status.in_(['booked', 'checked-in', 'checked_in']),
            and_(
                Booking.check_in < new_checkout_date,
                Booking.check_out > booking.check_out
            )
        ).first()
        
        if conflicting_bookings:
            raise HTTPException(
                status_code=400,
                detail=f"Cannot extend checkout date. Room(s) are already booked by another booking (ID: {conflicting_bookings.id}) during the extended period."
            )
        
        # Check for conflicts with other package bookings
        conflicting_package_bookings = db.query(PackageBooking).join(PackageBookingRoom).filter(
            PackageBooking.id != booking_id,
            PackageBookingRoom.room_id.in_(room_ids),
            PackageBooking.status.in_(['booked', 'checked-in', 'checked_in']),
            and_(
                PackageBooking.check_in < new_checkout_date,
                PackageBooking.check_out > booking.check_out
            )
        ).first()
        
        if conflicting_package_bookings:
            raise HTTPException(
                status_code=400,
                detail=f"Cannot extend checkout date. Room(s) are already booked by another package booking (ID: {conflicting_package_bookings.id}) during the extended period."
            )
    
    # Update the checkout date
    booking.check_out = new_checkout_date
    db.commit()
    db.refresh(booking)
    
    # Reload booking with relationships for response
    booking_with_rooms = db.query(PackageBooking).options(
        joinedload(PackageBooking.rooms).joinedload(PackageBookingRoom.room),
        joinedload(PackageBooking.package)
    ).filter(PackageBooking.id == booking_id).first()
    
    return booking_with_rooms

@router.put("/booking/{booking_id}/check-in", response_model=PackageBookingOut)
def check_in_package_booking(
    booking_id: Union[str, int],
    id_card_images: Annotated[Any, File()] = None, # Changed to accept multiple files
    guest_photos: Annotated[Any, File()] = None,   # Changed to accept multiple files
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    from datetime import date
    from app.models.Package import PackageCheckInDocument # Import valid model
    
    # Parse display ID (PK-000001) or accept numeric ID
    numeric_id, booking_type = parse_display_id(str(booking_id))
    if numeric_id is None:
        raise HTTPException(status_code=400, detail=f"Invalid booking ID format: {booking_id}")
    if booking_type and booking_type != "package":
        raise HTTPException(status_code=400, detail=f"Invalid booking type. Expected package booking, got: {booking_id}")
    booking_id = numeric_id
    
    booking = (
        db.query(PackageBooking)
        .options(joinedload(PackageBooking.rooms).joinedload(PackageBookingRoom.room))
        .filter(PackageBooking.id == booking_id).first()
    )
    if not booking:
        raise HTTPException(status_code=404, detail="Package booking not found")

    # Normalize status to be robust against case/whitespace/underscore differences
    normalized_status = (booking.status or "").strip().lower().replace("_", "-")
    
    # Check if there are existing documents in the new table
    # This helps with the recovery logic (if old columns are empty but new table has data)
    has_documents = db.query(PackageCheckInDocument).filter(PackageCheckInDocument.package_booking_id == booking.id).count() > 0
    
    # Allow check-in when:
    #  - status is 'booked' (normal case), OR
    #  - status is 'checked-out' but no check-in images were ever saved (recover-from-state issue)
    # This prevents lock-out when UI shows BOOKED but DB flipped due to earlier process.
    recoverable_checked_out = (
        normalized_status == "checked-out" and 
        not booking.id_card_image_url and 
        not booking.guest_photo_url and
        not has_documents
    )
    
    today = date.today()
    if booking.check_in > today:
        # early check-in: verify availability for the gap [today, booking.check_in)
        gap_start = today
        gap_end = booking.check_in
        
        # Need to import these locally
        from app.models.booking import Booking, BookingRoom
        
        # Check regular booking conflicts
        conflicting_regular = db.query(BookingRoom).join(Booking).filter(
            BookingRoom.room_id.in_([br.room_id for br in booking.rooms]),
            Booking.status.in_(['booked', 'checked-in', 'checked_in']),
            Booking.check_in < gap_end,
            Booking.check_out > gap_start
        ).first()

        # Check package booking conflicts
        conflicting_package = db.query(PackageBookingRoom).join(PackageBooking).filter(
            PackageBookingRoom.room_id.in_([br.room_id for br in booking.rooms]),
            PackageBooking.status.in_(['booked', 'checked-in', 'checked_in']),
            PackageBooking.check_in < gap_end,
            PackageBooking.check_out > gap_start
        ).first()

        if conflicting_regular or conflicting_package:
             raise HTTPException(status_code=400, detail=f"Cannot check-in early. Rooms are overlapping with another booking between {gap_start} and {gap_end}.")
        
        # Update check-in date to today
        booking.check_in = today

    # ---------------------------------------------------------
    # CRITICAL FIX: Prevent check-in if room is currently occupied
    # ---------------------------------------------------------
    if booking.rooms:
        room_ids = [br.room_id for br in booking.rooms]
        
        # Need to import these locally
        from app.models.booking import Booking, BookingRoom
        
        # Check regular bookings that are currently checked in
        occupied_regular = db.query(Booking).join(BookingRoom).filter(
            BookingRoom.room_id.in_(room_ids),
            Booking.status.in_(['checked-in', 'checked_in'])
        ).first()
        
        if occupied_regular:
            raise HTTPException(
                status_code=400, 
                detail=f"Cannot check-in. Room is currently occupied by another guest (Booking {occupied_regular.id}). Please check them out first."
            )
            
        # Check package bookings that are currently checked in
        occupied_package = db.query(PackageBooking).join(PackageBookingRoom).filter(
            PackageBookingRoom.room_id.in_(room_ids),
            PackageBooking.status.in_(['checked-in', 'checked_in']),
            PackageBooking.id != booking_id
        ).first()
        
        if occupied_package:
             raise HTTPException(
                status_code=400, 
                detail=f"Cannot check-in. Room is currently occupied by another package guest (Booking {occupied_package.id}). Please check them out first."
            )
    # ---------------------------------------------------------

    if normalized_status != "booked" and not recoverable_checked_out:
        raise HTTPException(
            status_code=400,
            detail=f"Package booking {booking_id} cannot be checked in. Expected status 'booked', found '{booking.status}'."
        )

    # Helper function to save file and create document record
    def save_document(file: UploadFile, doc_type: str):
        if not file or not file.filename:
            return None
            
        file_ext = os.path.splitext(file.filename)[1]
        unique_filename = f"{doc_type}_pkg_{booking_id}_{uuid.uuid4().hex}{file_ext}"
        file_path = os.path.join(CHECKIN_UPLOAD_DIR, unique_filename)
        
        try:
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(file.file, buffer)
                
            # Create document record
            doc = PackageCheckInDocument(
                package_booking_id=booking.id,
                type=doc_type,
                image_url=unique_filename
            )
            db.add(doc)
            return unique_filename
        except Exception as e:
            print(f"Error saving {doc_type} for package booking {booking_id}: {e}")
            return None

    # Process ID Card Images
    first_id_card = None
    if id_card_images is not None:
        # Ensure it's a list
        if not isinstance(id_card_images, list):
            id_card_images = [id_card_images]
            
        for file in id_card_images:
            saved_filename = save_document(file, "id_card")
            if saved_filename and not first_id_card:
                first_id_card = saved_filename

    # Process Guest Photos
    first_guest_photo = None
    if guest_photos is not None:
        # Ensure it's a list
        if not isinstance(guest_photos, list):
            guest_photos = [guest_photos]
            
        for file in guest_photos:
            saved_filename = save_document(file, "guest_photo")
            if saved_filename and not first_guest_photo:
                first_guest_photo = saved_filename

    # Populate legacy columns for backward compatibility if they are empty
    if first_id_card and not booking.id_card_image_url:
        booking.id_card_image_url = first_id_card
        
    if first_guest_photo and not booking.guest_photo_url:
        booking.guest_photo_url = first_guest_photo

    booking.status = "checked-in"
    booking.user_id = current_user.id

    if booking.rooms:
        room_ids = [br.room_id for br in booking.rooms]
        db.query(Room).filter(Room.id.in_(room_ids)).update({"status": "Checked-in"}, synchronize_session=False)

    db.commit()
    db.refresh(booking)
    return booking

# -------------------------------
# GET check-in images for packages
# -------------------------------
@router.get("/booking/checkin-image/{filename}")
def get_package_checkin_image(filename: str):
    filepath = os.path.join(CHECKIN_UPLOAD_DIR, filename)
    if not os.path.exists(filepath) or not os.path.isfile(filepath):
        raise HTTPException(status_code=404, detail="Image not found")
    return FileResponse(filepath)
