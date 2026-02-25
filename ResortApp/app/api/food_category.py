from fastapi import APIRouter, Depends, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import Annotated, Any
from app.schemas.food_category import *
from app.curd import food_category as crud
from app.utils.auth import get_db, get_current_user
from app.models.food_category import FoodCategory
from app.models.user import User
import os, shutil, uuid
import uuid,os, shutil
UPLOAD_DIR = "static/food_categories"
# os.makedirs(UPLOAD_DIR, exist_ok=True) -> Moved to main.py startup_event
router = APIRouter(prefix="/food-categories", tags=["Food Categories"])


@router.post("", response_model=FoodCategoryOut)
def create_category(name: Annotated[Any, Form()] = None, image: Annotated[Any, File()] = None, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    filename = None
    if image:
        filename = f"category_{uuid.uuid4().hex}_{image.filename}"
        path = os.path.join("static/food_categories", filename)
        with open(path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
    
    category = FoodCategory(name=name, image=filename)
    db.add(category)
    db.commit()
    db.refresh(category)
    return category


def _read_all_impl(db: Session, skip: int = 0, limit: int = 20):
    """Helper function for read_all"""
    return crud.get_categories(db, skip=skip, limit=limit)

@router.get("", response_model=list[FoodCategoryOut])
def read_all(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _read_all_impl(db, skip, limit)

@router.get("/", response_model=list[FoodCategoryOut])  # Handle trailing slash
def read_all_slash(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20):
    return _read_all_impl(db, skip, limit)

@router.put("/{cat_id}", response_model=FoodCategoryOut)
def update(cat_id: int, name: Annotated[Any, Form()] = None, image: Annotated[Any, File()] = None, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    """Update a food category"""
    category = db.query(FoodCategory).filter(FoodCategory.id == cat_id).first()
    if not category:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Category not found")
    
    category.name = name
    
    # Handle image update if provided
    if image and image.filename:
        # Delete old image if exists
        if category.image:
            old_path = os.path.join(UPLOAD_DIR, category.image)
            if os.path.exists(old_path):
                os.remove(old_path)
        
        # Save new image
        filename = f"category_{uuid.uuid4().hex}_{image.filename}"
        path = os.path.join(UPLOAD_DIR, filename)
        with open(path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        category.image = filename
    
    db.commit()
    db.refresh(category)
    return category

@router.delete("/{cat_id}")
def delete(cat_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    """Delete a food category"""
    category = db.query(FoodCategory).filter(FoodCategory.id == cat_id).first()
    if not category:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Delete image if exists
    if category.image:
        image_path = os.path.join(UPLOAD_DIR, category.image)
        if os.path.exists(image_path):
            os.remove(image_path)
    
    db.delete(category)
    db.commit()
    return {"message": "Category deleted successfully"}
