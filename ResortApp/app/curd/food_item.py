from app.models.food_item import FoodItem, FoodItemImage
from app.schemas.food_item import FoodItemCreate
from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload

def create_food_item(db: Session, item: FoodItemCreate, image_paths: list[str]):
    db_item = FoodItem(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)

    for path in image_paths:
        image = FoodItemImage(image_url=path, item_id=db_item.id)
        db.add(image)

    db.commit()
    db.refresh(db_item)
    return db_item

def get_all_food_items(db: Session, skip: int = 0, limit: int = 1000):
    total = db.query(FoodItem).count()
    items = (
        db.query(FoodItem)
        .options(
            joinedload(FoodItem.images),
            joinedload(FoodItem.category)
        )
        .order_by(FoodItem.id.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )
    return {"items": items, "total": total, "limit": limit, "skip": skip} 

def delete_food_item(db: Session, item_id: int):
    item = db.query(FoodItem).filter(FoodItem.id == item_id).first()
    if item:
        db.delete(item)
        db.commit()
        return {"msg": "Deleted"}
    return {"msg": "Not found"}

def update_food_item_availability(db: Session, item_id: int, available: bool):
    item = db.query(FoodItem).filter(FoodItem.id == item_id).first()
    if item:
        item.available = available
        db.commit()
        return {"msg": "Availability updated"}
    return {"msg": "Item not found"}

def update_food_item(db: Session, item_id: int, item: FoodItemCreate, image_paths: list[str] = None, kept_image_ids: list[int] = None):
    db_item = db.query(FoodItem).filter(FoodItem.id == item_id).first()
    if not db_item:
        return None
    
    for key, value in item.dict().items():
        setattr(db_item, key, value)
    
    # Handle image deletions if kept_image_ids is provided
    if kept_image_ids is not None:
        # Get all current images for this item
        current_images = db.query(FoodItemImage).filter(FoodItemImage.item_id == item_id).all()
        # Find images to delete (those whose IDs are NOT in the kept list)
        for img in current_images:
            if img.id not in kept_image_ids:
                db.delete(img) # Delete from DB
                # Optional: Delete file from disk if needed, but DB sync is primary requirement
    
    if image_paths:
        for path in image_paths:
            image = FoodItemImage(image_url=path, item_id=db_item.id)
            db.add(image)
            
    db.commit()
    db.refresh(db_item)
    return db_item
