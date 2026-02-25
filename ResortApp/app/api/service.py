from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session, joinedload
from typing import List, Annotated, Any
import os
import shutil
import uuid
from PIL import Image
import io
from app.schemas import service as service_schema
from app.models.user import User
from app.curd import service as service_crud
from app.utils.auth import get_db, get_current_user

router = APIRouter(prefix="/services", tags=["Services"])

UPLOAD_DIR = "uploads/services"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure directory exists at startup

# Service CRUD
@router.post("", response_model=service_schema.ServiceOut)
async def create_service(
    name: Annotated[Any, Form()] = None,
    description: Annotated[Any, Form()] = None,
    charges: Annotated[Any, Form()] = None,
    images: Annotated[Any, File()] = None,
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    try:
        image_urls = []
        
        # Handle images (ensure it's a list)
        if images is not None:
            # If a single file is uploaded, convert to list
            if not isinstance(images, list):
                images = [images]
            
            for img in images:
                if not img or not img.filename:
                    continue
                # Generate unique filename
                filename = f"svc_{uuid.uuid4().hex}_{img.filename}"
                file_path = os.path.join(UPLOAD_DIR, filename)
                with open(file_path, "wb") as buffer:
                    shutil.copyfileobj(img.file, buffer)
                
                # Generate and Save Thumbnail
                try:
                    thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
                    thumb_path = os.path.join(UPLOAD_DIR, thumb_filename)
                    with Image.open(file_path) as img_pil:
                        img_pil.thumbnail((200, 200), Image.Resampling.BICUBIC)
                        if img_pil.mode in ("RGBA", "P"):
                            img_pil = img_pil.convert("RGB")
                        img_pil.save(thumb_path, "JPEG", quality=60)
                except Exception as thumb_error:
                    print(f"Warning: Failed to generate thumbnail for {filename}: {thumb_error}")
                # Store with leading slash for proper URL construction
                normalized_path = file_path.replace('\\', '/')
                image_urls.append(f"/{normalized_path}")
        
        # Ensure charges is a float
        charges_val = 0.0
        if charges:
            try:
                charges_val = float(charges)
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid charges amount")

        return service_crud.create_service(db, name, description, charges_val, image_urls)
    except Exception as e:
        import traceback
        print(f"ERROR creating service: {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Failed to create service: {str(e)}")

def _list_services_impl(db: Session, skip: int = 0, limit: int = 20):
    """Helper function for list_services"""
    return service_crud.get_services(db, skip=skip, limit=limit)

@router.get("", response_model=List[service_schema.ServiceOut])
def list_services(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _list_services_impl(db, skip, limit)

@router.get("/", response_model=List[service_schema.ServiceOut])  # Handle trailing slash
def list_services_slash(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _list_services_impl(db, skip, limit)

@router.put("/{service_id}", response_model=service_schema.ServiceOut)
async def update_service(
    service_id: int,
    name: Annotated[Any, Form()] = None,
    description: Annotated[Any, Form()] = None,
    charges: Annotated[Any, Form()] = None,
    images: Annotated[Any, File()] = None,
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    try:
        image_urls = []
        if images is not None:
             # Ensure images is a list
            if not isinstance(images, list):
                images = [images]
                
            for img in images:
                if not img or not img.filename:
                    continue
                # Generate unique filename
                filename = f"svc_{uuid.uuid4().hex}_{img.filename}"
                file_path = os.path.join(UPLOAD_DIR, filename)
                with open(file_path, "wb") as buffer:
                    shutil.copyfileobj(img.file, buffer)
                
                # Generate and Save Thumbnail
                try:
                    thumb_filename = f"{os.path.splitext(filename)[0]}_thumb.jpg"
                    thumb_path = os.path.join(UPLOAD_DIR, thumb_filename)
                    with Image.open(file_path) as img_pil:
                        img_pil.thumbnail((200, 200), Image.Resampling.LANCZOS)
                        if img_pil.mode in ("RGBA", "P"):
                            img_pil = img_pil.convert("RGB")
                        img_pil.save(thumb_path, "JPEG", quality=60, optimize=True)
                except Exception as thumb_error:
                    print(f"Warning: Failed to generate thumbnail for {filename}: {thumb_error}")
                # Store with leading slash for proper URL construction
                normalized_path = file_path.replace('\\', '/')
                image_urls.append(f"/{normalized_path}")
        
        # Ensure charges is a float
        charges_val = None
        if charges:
            try:
                charges_val = float(charges)
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid charges amount")
        
        updated = service_crud.update_service(db, service_id, name, description, charges_val, image_urls)
        if not updated:
            raise HTTPException(status_code=404, detail="Service not found")
        return updated
    except HTTPException: raise
    except Exception as e:
        import traceback
        print(f"ERROR updating service: {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Failed to update service: {str(e)}")

@router.delete("/{service_id}")
def delete_service(service_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    success = service_crud.delete_service(db, service_id)
    if not success:
        raise HTTPException(status_code=404, detail="Service not found")
    return {"detail": "Deleted successfully"}

# Assigned Services
@router.post("/assign", response_model=service_schema.AssignedServiceOut)
def assign_service(payload: service_schema.AssignedServiceCreate, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    return service_crud.create_assigned_service(db, payload)

@router.get("/assigned", response_model=None)
def get_all_assigned_services(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    data = service_crud.get_assigned_services(db, skip=skip, limit=limit)
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }

@router.patch("/assigned/{assigned_id}")
def update_assigned_status(
    assigned_id: int,
    status_update: service_schema.AssignedServiceUpdate,
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    return service_crud.update_assigned_service_status(db, assigned_id, status_update)

@router.delete("/assigned/{assigned_id}")
def delete_assigned_service(assigned_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    success = service_crud.delete_assigned_service(db, assigned_id)
    if not success:
        raise HTTPException(status_code=404, detail="Assigned service not found")
@router.post("/bookings", response_model=service_schema.AssignedServiceOut)
def create_service_booking(payload: service_schema.AssignedServiceCreate, db: Annotated[Any, Depends(get_db)] = None):
    """Create a new service booking (publicly accessible for QR guests)"""
    # For guest bookings, we might need to adjust the payload schema if it differs from admin assignment
    # reusing the logic but ensuring no auth required
    return service_crud.create_assigned_service(db, payload)
