from fastapi import APIRouter, UploadFile, File, Form, Depends, HTTPException, Request
from sqlalchemy.orm import Session

from app.curd import food_item
from app.schemas.food_item import FoodItemCreate
from app.models.user import User
import os, shutil, uuid
from app.utils.auth import get_db, get_current_user

router = APIRouter(prefix="/food-items", tags=["FoodItem"])
UPLOAD_DIR = "uploads/food_items"
os.makedirs(UPLOAD_DIR, exist_ok=True)



@router.post("")
async def create_item(
    name: str = Form(...),
    description: str = Form(...),
    price: float = Form(...),
    available: bool = Form(...),
    category_id: int = Form(...),
    images: list[UploadFile] = File(None),  # Make images optional
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    image_paths = []
    # Only process images if they are provided
    if images and images[0].filename:  # Check if images exist and have filenames
        for image in images:
            # Generate unique filename
            filename = f"food_{uuid.uuid4().hex}_{image.filename}"
            path = os.path.join(UPLOAD_DIR, filename)
            with open(path, "wb") as buffer:
                shutil.copyfileobj(image.file, buffer)
            # Store with leading slash for proper URL construction
            web_path = f"/{UPLOAD_DIR}/{filename}".replace("\\", "/")
            image_paths.append(web_path)

    item_data = FoodItemCreate(
        name=name, description=description, price=price,
        available=available, category_id=category_id
    )
    return food_item.create_food_item(db, item_data, image_paths)

@router.put("/{item_id}")
async def update_item(
    request: Request,
    item_id: int,
    name: str = Form(...),
    description: str = Form(...),
    price: float = Form(...),
    available: bool = Form(...),
    category_id: int = Form(...),
    images: list[UploadFile] = File(None),
    keep_image_ids: str = Form(""), # Comma-separated list of IDs to keep
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    form_data = await request.form()
    print(f"DEBUG: Raw Form Keys received: {form_data.keys()}")
    
    print(f"DEBUG: update_item called for item_id: {item_id}")
    print(f"DEBUG: keep_image_ids received raw: '{keep_image_ids}'")
    
    # Parse keep_image_ids string to list of ints
    keep_ids_list = []
    if keep_image_ids and keep_image_ids.strip():
        try:
            keep_ids_list = [int(id_str) for id_str in keep_image_ids.split(",") if id_str.strip().isdigit()]
        except ValueError:
            print(f"Error parsing keep_image_ids: {keep_image_ids}")
            
    print(f"DEBUG: Parsed keep_ids_list: {keep_ids_list}")

    image_paths = []
    if images and images[0].filename:
        for image in images:
            filename = f"food_{uuid.uuid4().hex}_{image.filename}"
            path = os.path.join(UPLOAD_DIR, filename)
            with open(path, "wb") as buffer:
                shutil.copyfileobj(image.file, buffer)
            web_path = f"/{UPLOAD_DIR}/{filename}".replace("\\", "/")
            image_paths.append(web_path)

    item_data = FoodItemCreate(
        name=name, description=description, price=price,
        available=available, category_id=category_id
    )
    
    updated_item = food_item.update_food_item(db, item_id, item_data, image_paths, keep_ids_list)
    if updated_item is None:
        raise HTTPException(status_code=404, detail="Food item not found")
    return updated_item


def _list_items_impl(db: Session, skip: int = 0, limit: int = 20):
    """Helper function for list_items"""
    try:
        return food_item.get_all_food_items(db, skip=skip, limit=limit)
    except Exception as e:
        import traceback
        error_detail = f"Failed to fetch food items: {str(e)}\n{traceback.format_exc()}"
        print(f"ERROR: {error_detail}")
        import sys
        sys.stderr.write(f"ERROR in food-items: {error_detail}\n")
        # Return empty list to prevent frontend breakage
        return []

@router.get("")
def list_items(db: Session = Depends(get_db), skip: int = 0, limit: int = 1000):
    return _list_items_impl(db, skip, limit)

@router.get("/")  # Handle trailing slash
def list_items_slash(db: Session = Depends(get_db), skip: int = 0, limit: int = 1000):
    return _list_items_impl(db, skip, limit)

@router.delete("/{item_id}")
def delete_item(item_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return food_item.delete_food_item(db, item_id)

@router.patch("/{item_id}/toggle-availability")
def toggle_availability(item_id: int, available: bool, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return food_item.update_food_item_availability(db, item_id, available)
