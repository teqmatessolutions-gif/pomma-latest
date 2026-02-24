from fastapi import APIRouter, UploadFile, File, Form, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from typing import Annotated, Any

from app.curd import food_item
from app.schemas.food_item import FoodItemCreate
from app.models.user import User
import os, shutil, uuid
from app.utils.auth import get_db, get_current_user
from app.utils.thumbnail_generator import generate_thumbnail

router = APIRouter(prefix="/food-items", tags=["FoodItem"])
UPLOAD_DIR = "uploads/food_items"
os.makedirs(UPLOAD_DIR, exist_ok=True)



@router.post("")
    try:
        image_paths = []
        # Only process images if they are provided
        if images is not None:
            # If a single file is uploaded, convert to list
            if not isinstance(images, list):
                images = [images]
            
            for image in images:
                if not image or not getattr(image, 'filename', None):
                    continue
                # Generate unique filename
                filename = f"food_{uuid.uuid4().hex}_{image.filename}"
                path = os.path.join(UPLOAD_DIR, filename)
                with open(path, "wb") as buffer:
                    shutil.copyfileobj(image.file, buffer)
                
                # Generate thumbnail
                try:
                    generate_thumbnail(path)
                except Exception as e:
                    print(f"Error generating thumbnail for {filename}: {e}")

                # Store with leading slash for proper URL construction
                web_path = f"/{UPLOAD_DIR}/{filename}".replace("\\", "/")
                image_paths.append(web_path)

        item_data = FoodItemCreate(
            name=name, description=description, price=price,
            available=available, category_id=category_id
        )
        return food_item.create_food_item(db, item_data, image_paths)
    except Exception as e:
        import traceback
        print(f"ERROR creating food item: {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Failed to create food item: {str(e)}")

@router.put("/{item_id}")
async def update_item(
    request: Request,
    item_id: int,
    name: Annotated[Any, Form()] = None,
    description: Annotated[Any, Form()] = None,
    price: Annotated[Any, Form()] = None,
    available: Annotated[Any, Form()] = None,
    category_id: Annotated[Any, Form()] = None,
    images: Annotated[Any, File()] = None,
    keep_image_ids: Annotated[Any, Form()] = "",
    db: Annotated[Any, Depends(get_db)] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    try:
        form_data = await request.form()
        print(f"DEBUG: Raw Form Keys received: {form_data.keys()}")
        
        print(f"DEBUG: update_item called for item_id: {item_id}")
        print(f"DEBUG: keep_image_ids received raw: '{keep_image_ids}'")
        
        # Parse keep_image_ids string to list of ints
        keep_ids_list = []
        if keep_image_ids and keep_image_ids.strip():
            try:
                if isinstance(keep_image_ids, str):
                    keep_ids_list = [int(id_str) for id_str in keep_image_ids.split(",") if id_str.strip().isdigit()]
            except ValueError:
                print(f"Error parsing keep_image_ids: {keep_image_ids}")
                
        print(f"DEBUG: Parsed keep_ids_list: {keep_ids_list}")

        image_paths = []
        if images is not None:
            # Ensure images is a list
            if not isinstance(images, list):
                images = [images]
                
            for image in images:
                if not image or not getattr(image, 'filename', None):
                    continue
                filename = f"food_{uuid.uuid4().hex}_{image.filename}"
                path = os.path.join(UPLOAD_DIR, filename)
                with open(path, "wb") as buffer:
                    shutil.copyfileobj(image.file, buffer)
                
                # Generate thumbnail
                try:
                    generate_thumbnail(path)
                except Exception as e:
                    print(f"Error generating thumbnail for {filename}: {e}")

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
    except HTTPException: raise
    except Exception as e:
        import traceback
        print(f"ERROR updating food item: {str(e)}\n{traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=f"Failed to update food item: {str(e)}")


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

@router.get("", response_model=None)
def list_items(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 1000):
    data = _list_items_impl(db, skip, limit)
    # Calculate page number
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }

@router.get("/")  # Handle trailing slash
def list_items_slash(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 1000):
    data = _list_items_impl(db, skip, limit)
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }

@router.delete("/{item_id}")
def delete_item(item_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    return food_item.delete_food_item(db, item_id)

@router.patch("/{item_id}/toggle-availability")
def toggle_availability(item_id: int, available: bool, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    return food_item.update_food_item_availability(db, item_id, available)
