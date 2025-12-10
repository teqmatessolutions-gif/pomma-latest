from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_, or_, func
from app.database import SessionLocal
from app.models.inventory import (
    InventoryItem, InventoryCategory, UnitOfMeasurement, Location, UOMConversion, StockLevel, RoomInventoryItem,
    RoomInventoryAudit, RoomAsset, AssetInspection, LinenStock, LinenMovement,
    Recipe, RecipeIngredient, WastageLog, StockMovement, Indent, IndentItem,
    LocationType, StockState, IndentStatus
)
from app.models.room import Room
from app.models.user import User
from app.models.food_item import FoodItem
from app.api.auth import get_current_user
from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime, date
from decimal import Decimal

router = APIRouter(prefix="/inventory", tags=["Inventory"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# ==================== Pydantic Schemas ====================

class InventoryCategoryCreate(BaseModel):
    name: str
    description: Optional[str] = None

class InventoryCategoryOut(BaseModel):
    id: int
    name: str
    description: Optional[str]
    is_active: bool

    class Config:
        from_attributes = True

class UnitOfMeasurementCreate(BaseModel):
    name: str
    symbol: Optional[str] = None
    description: Optional[str] = None

class UnitOfMeasurementOut(BaseModel):
    id: int
    name: str
    symbol: Optional[str]
    description: Optional[str]
    is_active: bool

    class Config:
        from_attributes = True

class InventoryItemCreate(BaseModel):
    name: str
    description: Optional[str] = None
    category_id: int
    sku: Optional[str] = None
    barcode: Optional[str] = None
    base_uom_id: int
    unit_price: float = 0.0
    selling_price: float = 0.0
    track_expiry: bool = False
    track_serial: bool = False
    track_batch: bool = False
    min_stock_level: float = 0.0
    max_stock_level: float = 0.0

class InventoryItemOut(BaseModel):
    id: int
    name: str
    description: Optional[str]
    category_id: int
    category: Optional[InventoryCategoryOut] = None
    sku: Optional[str]
    barcode: Optional[str]
    base_uom_id: int
    base_uom: Optional[UnitOfMeasurementOut] = None
    unit_price: float
    selling_price: float
    track_expiry: bool
    track_serial: bool
    track_batch: bool
    min_stock_level: float
    max_stock_level: float
    is_active: bool

    class Config:
        from_attributes = True

class LocationCreate(BaseModel):
    name: str
    code: Optional[str] = None
    location_type: str
    parent_location_id: Optional[int] = None
    description: Optional[str] = None

class LocationOut(BaseModel):
    id: int
    name: str
    code: Optional[str]
    location_type: str
    parent_location_id: Optional[int]
    description: Optional[str]
    is_active: bool

    class Config:
        from_attributes = True

class StockLevelOut(BaseModel):
    id: int
    item_id: int
    location_id: int
    quantity: float
    uom: str
    expiry_date: Optional[date]
    batch_number: Optional[str]
    item: Optional[InventoryItemOut] = None
    location: Optional[LocationOut] = None

    class Config:
        from_attributes = True

class RoomInventoryItemCreate(BaseModel):
    room_id: int
    item_id: int
    par_stock: float

class RoomInventoryAuditCreate(BaseModel):
    room_id: int
    room_inventory_item_id: int
    found_quantity: float
    notes: Optional[str] = None

class RecipeCreate(BaseModel):
    name: str
    description: Optional[str] = None
    food_item_id: Optional[int] = None
    servings: int = 1
    ingredients: List[dict]  # [{"item_id": 1, "quantity": 200, "uom": "g"}]

class IndentCreate(BaseModel):
    requested_from_location_id: int
    requested_to_location_id: int
    items: List[dict]  # [{"item_id": 1, "quantity": 5, "uom": "kg"}]
    notes: Optional[str] = None


# ==================== Inventory Categories ====================

@router.get("/categories", response_model=List[InventoryCategoryOut])
def list_categories(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List all inventory categories"""
    return db.query(InventoryCategory).filter(InventoryCategory.is_active == True).all()

@router.post("/categories", response_model=InventoryCategoryOut)
def create_category(
    category: InventoryCategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new inventory category"""
    # Check if category with same name exists
    existing = db.query(InventoryCategory).filter(InventoryCategory.name == category.name).first()
    if existing:
        raise HTTPException(status_code=400, detail="Category with this name already exists")
    
    db_category = InventoryCategory(**category.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    return db_category

@router.delete("/categories/{category_id}")
def delete_category(
    category_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Soft delete a category"""
    category = db.query(InventoryCategory).filter(InventoryCategory.id == category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    category.is_active = False
    db.commit()
    return {"message": "Category deleted successfully"}


# ==================== Units of Measurement ====================

@router.get("/uoms", response_model=List[UnitOfMeasurementOut])
def list_uoms(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List all units of measurement"""
    return db.query(UnitOfMeasurement).filter(UnitOfMeasurement.is_active == True).all()

@router.post("/uoms", response_model=UnitOfMeasurementOut)
def create_uom(
    uom: UnitOfMeasurementCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new unit of measurement"""
    # Check if UOM with same name exists
    existing = db.query(UnitOfMeasurement).filter(UnitOfMeasurement.name == uom.name).first()
    if existing:
        raise HTTPException(status_code=400, detail="Unit of measurement with this name already exists")
    
    db_uom = UnitOfMeasurement(**uom.dict())
    db.add(db_uom)
    db.commit()
    db.refresh(db_uom)
    return db_uom

@router.delete("/uoms/{uom_id}")
def delete_uom(
    uom_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Soft delete a unit of measurement"""
    uom = db.query(UnitOfMeasurement).filter(UnitOfMeasurement.id == uom_id).first()
    if not uom:
        raise HTTPException(status_code=404, detail="Unit of measurement not found")
    
    uom.is_active = False
    db.commit()
    return {"message": "Unit of measurement deleted successfully"}


# ==================== Master Inventory ====================

@router.get("/items", response_model=List[InventoryItemOut])
def list_inventory_items(
    category_id: Optional[int] = Query(None),
    search: Optional[str] = Query(None),
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List all inventory items with optional filtering"""
    query = db.query(InventoryItem).options(
        joinedload(InventoryItem.category_ref),
        joinedload(InventoryItem.uom_ref)
    )
    
    if category_id:
        query = query.filter(InventoryItem.category_id == category_id)
    if search:
        query = query.filter(
            or_(
                InventoryItem.name.ilike(f"%{search}%"),
                InventoryItem.sku.ilike(f"%{search}%"),
                InventoryItem.barcode.ilike(f"%{search}%")
            )
        )
    
    return query.filter(InventoryItem.is_active == True).offset(skip).limit(limit).all()

@router.post("/items", response_model=InventoryItemOut)
def create_inventory_item(
    item: InventoryItemCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new inventory item"""
    # Verify category exists
    category = db.query(InventoryCategory).filter(InventoryCategory.id == item.category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Verify UOM exists
    uom = db.query(UnitOfMeasurement).filter(UnitOfMeasurement.id == item.base_uom_id).first()
    if not uom:
        raise HTTPException(status_code=404, detail="Unit of measurement not found")
    
    db_item = InventoryItem(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    # Load relationships
    db.refresh(db_item)
    return db_item

@router.get("/items/{item_id}", response_model=InventoryItemOut)
def get_inventory_item(
    item_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific inventory item"""
    item = db.query(InventoryItem).options(
        joinedload(InventoryItem.category_ref),
        joinedload(InventoryItem.uom_ref)
    ).filter(InventoryItem.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

@router.put("/items/{item_id}", response_model=InventoryItemOut)
def update_inventory_item(
    item_id: int,
    item: InventoryItemCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an inventory item"""
    db_item = db.query(InventoryItem).filter(InventoryItem.id == item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Item not found")
    
    # Verify category exists
    category = db.query(InventoryCategory).filter(InventoryCategory.id == item.category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Verify UOM exists
    uom = db.query(UnitOfMeasurement).filter(UnitOfMeasurement.id == item.base_uom_id).first()
    if not uom:
        raise HTTPException(status_code=404, detail="Unit of measurement not found")
    
    for key, value in item.dict().items():
        setattr(db_item, key, value)
    
    db_item.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_item)
    # Load relationships
    return db_item

@router.delete("/items/{item_id}")
def delete_inventory_item(
    item_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Soft delete an inventory item"""
    db_item = db.query(InventoryItem).filter(InventoryItem.id == item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Item not found")
    
    db_item.is_active = False
    db.commit()
    return {"message": "Item deleted successfully"}


# ==================== Locations ====================

@router.get("/locations", response_model=List[LocationOut])
def list_locations(
    location_type: Optional[str] = Query(None),
    parent_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List all locations"""
    query = db.query(Location).filter(Location.is_active == True)
    
    if location_type:
        query = query.filter(Location.location_type == location_type)
    if parent_id:
        query = query.filter(Location.parent_location_id == parent_id)
    
    return query.all()

@router.post("/locations", response_model=LocationOut)
def create_location(
    location: LocationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new location"""
    db_location = Location(**location.dict())
    db.add(db_location)
    db.commit()
    db.refresh(db_location)
    return db_location


# ==================== Stock Levels ====================

@router.get("/stock-levels", response_model=List[StockLevelOut])
def list_stock_levels(
    location_id: Optional[int] = Query(None),
    item_id: Optional[int] = Query(None),
    low_stock_only: bool = Query(False),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List stock levels with optional filtering"""
    query = db.query(StockLevel).join(InventoryItem)
    
    if location_id:
        query = query.filter(StockLevel.location_id == location_id)
    if item_id:
        query = query.filter(StockLevel.item_id == item_id)
    if low_stock_only:
        query = query.filter(
            StockLevel.quantity <= InventoryItem.min_stock_level
        )
    
    return query.all()

@router.post("/stock-levels")
def create_stock_level(
    item_id: int,
    location_id: int,
    quantity: float,
    uom: str,
    expiry_date: Optional[date] = None,
    batch_number: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create or update stock level"""
    existing = db.query(StockLevel).filter(
        and_(
            StockLevel.item_id == item_id,
            StockLevel.location_id == location_id
        )
    ).first()
    
    if existing:
        existing.quantity += quantity
        if expiry_date:
            existing.expiry_date = expiry_date
        if batch_number:
            existing.batch_number = batch_number
        existing.last_updated = datetime.utcnow()
    else:
        existing = StockLevel(
            item_id=item_id,
            location_id=location_id,
            quantity=quantity,
            uom=uom,
            expiry_date=expiry_date,
            batch_number=batch_number
        )
        db.add(existing)
    
    db.commit()
    db.refresh(existing)
    return existing


# ==================== Room Inventory (Minibar) ====================

@router.get("/room-inventory/{room_id}")
def get_room_inventory(
    room_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all inventory items for a room"""
    items = db.query(RoomInventoryItem).filter(
        RoomInventoryItem.room_id == room_id,
        RoomInventoryItem.is_active == True
    ).all()
    return items

@router.post("/room-inventory")
def create_room_inventory_item(
    item: RoomInventoryItemCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Set par stock for a room inventory item"""
    # Check if already exists
    existing = db.query(RoomInventoryItem).filter(
        and_(
            RoomInventoryItem.room_id == item.room_id,
            RoomInventoryItem.item_id == item.item_id
        )
    ).first()
    
    if existing:
        existing.par_stock = item.par_stock
        existing.current_stock = item.par_stock  # Initialize with par stock
    else:
        existing = RoomInventoryItem(
            room_id=item.room_id,
            item_id=item.item_id,
            par_stock=item.par_stock,
            current_stock=item.par_stock
        )
        db.add(existing)
    
    db.commit()
    db.refresh(existing)
    return existing

@router.post("/room-inventory/audit")
def audit_room_inventory(
    audit: RoomInventoryAuditCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Perform room inventory audit and auto-bill consumed items"""
    room_item = db.query(RoomInventoryItem).filter(
        RoomInventoryItem.id == audit.room_inventory_item_id
    ).first()
    
    if not room_item:
        raise HTTPException(status_code=404, detail="Room inventory item not found")
    
    expected = room_item.par_stock
    found = audit.found_quantity
    consumed = expected - found
    
    # Get item details for pricing
    item = db.query(InventoryItem).filter(InventoryItem.id == room_item.item_id).first()
    
    # Calculate billed amount
    billed_amount = consumed * item.selling_price if consumed > 0 else 0.0
    
    # Create audit record
    audit_record = RoomInventoryAudit(
        room_id=audit.room_id,
        room_inventory_item_id=audit.room_inventory_item_id,
        expected_quantity=expected,
        found_quantity=found,
        consumed_quantity=consumed,
        billed_amount=billed_amount,
        audited_by=current_user.id,
        notes=audit.notes
    )
    db.add(audit_record)
    
    # Update current stock
    room_item.current_stock = found
    room_item.last_audit_date = datetime.utcnow()
    room_item.last_audited_by = current_user.id
    
    # Create replenishment request if consumed > 0
    if consumed > 0:
        # TODO: Create indent for replenishment
        pass
    
    db.commit()
    db.refresh(audit_record)
    
    return {
        "audit": audit_record,
        "consumed": consumed,
        "billed_amount": billed_amount,
        "replenishment_needed": consumed > 0
    }


# ==================== Room Assets ====================

@router.get("/room-assets/{room_id}")
def get_room_assets(
    room_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all assets for a room"""
    assets = db.query(RoomAsset).filter(RoomAsset.room_id == room_id).all()
    return assets

@router.post("/room-assets")
def create_room_asset(
    room_id: int,
    item_id: int,
    asset_id: str,
    serial_number: Optional[str] = None,
    purchase_date: Optional[date] = None,
    purchase_price: Optional[float] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new room asset"""
    asset = RoomAsset(
        room_id=room_id,
        item_id=item_id,
        asset_id=asset_id,
        serial_number=serial_number,
        purchase_date=purchase_date,
        purchase_price=purchase_price,
        status="good"
    )
    db.add(asset)
    db.commit()
    db.refresh(asset)
    return asset

@router.post("/room-assets/{asset_id}/inspect")
def inspect_asset(
    asset_id: int,
    status: str,
    damage_description: Optional[str] = None,
    charge_to_guest: bool = False,
    charge_amount: float = 0.0,
    notes: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Inspect an asset and log inspection"""
    asset = db.query(RoomAsset).filter(RoomAsset.id == asset_id).first()
    if not asset:
        raise HTTPException(status_code=404, detail="Asset not found")
    
    inspection = AssetInspection(
        asset_id=asset_id,
        inspected_by=current_user.id,
        status=status,
        damage_description=damage_description,
        charge_to_guest=charge_to_guest,
        charge_amount=charge_amount,
        notes=notes
    )
    db.add(inspection)
    
    asset.status = status
    asset.last_inspection_date = date.today()
    db.commit()
    db.refresh(inspection)
    return inspection


# ==================== Kitchen Inventory & Recipes ====================

@router.get("/recipes")
def list_recipes(
    food_item_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List all recipes"""
    query = db.query(Recipe).filter(Recipe.is_active == True)
    if food_item_id:
        query = query.filter(Recipe.food_item_id == food_item_id)
    return query.all()

@router.post("/recipes")
def create_recipe(
    recipe: RecipeCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new recipe"""
    db_recipe = Recipe(
        name=recipe.name,
        description=recipe.description,
        food_item_id=recipe.food_item_id,
        servings=recipe.servings
    )
    db.add(db_recipe)
    db.flush()
    
    # Add ingredients
    for ing in recipe.ingredients:
        ingredient = RecipeIngredient(
            recipe_id=db_recipe.id,
            item_id=ing["item_id"],
            quantity=ing["quantity"],
            uom=ing["uom"]
        )
        db.add(ingredient)
    
    db.commit()
    db.refresh(db_recipe)
    return db_recipe

@router.post("/recipes/{recipe_id}/consume")
def consume_recipe(
    recipe_id: int,
    quantity: int = 1,  # Number of servings
    location_id: int = None,  # Kitchen location
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Consume ingredients when a recipe is prepared"""
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    ingredients = db.query(RecipeIngredient).filter(
        RecipeIngredient.recipe_id == recipe_id
    ).all()
    
    consumed_items = []
    for ingredient in ingredients:
        # Calculate quantity per serving
        qty_per_serving = ingredient.quantity / recipe.servings
        total_qty = qty_per_serving * quantity
        
        # Deduct from stock
        if location_id:
            stock = db.query(StockLevel).filter(
                and_(
                    StockLevel.item_id == ingredient.item_id,
                    StockLevel.location_id == location_id
                )
            ).first()
            
            if stock:
                if stock.quantity < total_qty:
                    raise HTTPException(
                        status_code=400,
                        detail=f"Insufficient stock for {ingredient.item.name}"
                    )
                stock.quantity -= total_qty
                stock.last_updated = datetime.utcnow()
                consumed_items.append({
                    "item": ingredient.item.name,
                    "consumed": total_qty,
                    "remaining": stock.quantity
                })
    
    db.commit()
    return {"message": "Ingredients consumed", "consumed": consumed_items}


# ==================== Indents ====================

@router.get("/indents")
def list_indents(
    status: Optional[str] = Query(None),
    location_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List all indents"""
    query = db.query(Indent)
    
    if status:
        query = query.filter(Indent.status == status)
    if location_id:
        query = query.filter(
            or_(
                Indent.requested_from_location_id == location_id,
                Indent.requested_to_location_id == location_id
            )
        )
    
    return query.order_by(Indent.requested_date.desc()).all()

@router.post("/indents")
def create_indent(
    indent: IndentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new indent"""
    # Generate indent number
    count = db.query(Indent).count()
    indent_number = f"IND-{datetime.now().strftime('%Y%m%d')}-{count + 1:04d}"
    
    db_indent = Indent(
        indent_number=indent_number,
        requested_from_location_id=indent.requested_from_location_id,
        requested_to_location_id=indent.requested_to_location_id,
        requested_by=current_user.id,
        status=IndentStatus.PENDING
    )
    db.add(db_indent)
    db.flush()
    
    # Add items
    for item in indent.items:
        indent_item = IndentItem(
            indent_id=db_indent.id,
            item_id=item["item_id"],
            requested_quantity=item["quantity"],
            uom=item["uom"]
        )
        db.add(indent_item)
    
    db.commit()
    db.refresh(db_indent)
    return db_indent

@router.post("/indents/{indent_id}/approve")
def approve_indent(
    indent_id: int,
    approved_items: List[dict],  # [{"item_id": 1, "approved_quantity": 5}]
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Approve an indent"""
    indent = db.query(Indent).filter(Indent.id == indent_id).first()
    if not indent:
        raise HTTPException(status_code=404, detail="Indent not found")
    
    indent.status = IndentStatus.APPROVED
    indent.approved_by = current_user.id
    indent.approved_date = datetime.utcnow()
    
    # Update approved quantities
    for approved_item in approved_items:
        indent_item = db.query(IndentItem).filter(
            and_(
                IndentItem.indent_id == indent_id,
                IndentItem.item_id == approved_item["item_id"]
            )
        ).first()
        if indent_item:
            indent_item.approved_quantity = approved_item["approved_quantity"]
    
    db.commit()
    db.refresh(indent)
    return indent


# ==================== Stock Movements ====================

@router.get("/stock-movements")
def list_stock_movements(
    item_id: Optional[int] = Query(None),
    location_id: Optional[int] = Query(None),
    movement_type: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """List stock movements"""
    query = db.query(StockMovement)
    
    if item_id:
        query = query.filter(StockMovement.item_id == item_id)
    if location_id:
        query = query.filter(
            or_(
                StockMovement.from_location_id == location_id,
                StockMovement.to_location_id == location_id
            )
        )
    if movement_type:
        query = query.filter(StockMovement.movement_type == movement_type)
    
    return query.order_by(StockMovement.movement_date.desc()).limit(100).all()

@router.post("/stock-movements")
def create_stock_movement(
    item_id: int,
    movement_type: str,
    from_location_id: Optional[int],
    to_location_id: int,
    quantity: float,
    uom: str,
    batch_number: Optional[str] = None,
    expiry_date: Optional[date] = None,
    reference_number: Optional[str] = None,
    notes: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a stock movement (transfer, issue, receipt)"""
    # Deduct from source location
    if from_location_id:
        from_stock = db.query(StockLevel).filter(
            and_(
                StockLevel.item_id == item_id,
                StockLevel.location_id == from_location_id
            )
        ).first()
        
        if not from_stock or from_stock.quantity < quantity:
            raise HTTPException(status_code=400, detail="Insufficient stock at source location")
        
        from_stock.quantity -= quantity
        from_stock.last_updated = datetime.utcnow()
    
    # Add to destination location
    to_stock = db.query(StockLevel).filter(
        and_(
            StockLevel.item_id == item_id,
            StockLevel.location_id == to_location_id
        )
    ).first()
    
    if to_stock:
        to_stock.quantity += quantity
        to_stock.last_updated = datetime.utcnow()
    else:
        to_stock = StockLevel(
            item_id=item_id,
            location_id=to_location_id,
            quantity=quantity,
            uom=uom,
            expiry_date=expiry_date,
            batch_number=batch_number
        )
        db.add(to_stock)
    
    # Create movement record
    movement = StockMovement(
        item_id=item_id,
        movement_type=movement_type,
        from_location_id=from_location_id,
        to_location_id=to_location_id,
        quantity=quantity,
        uom=uom,
        batch_number=batch_number,
        expiry_date=expiry_date,
        moved_by=current_user.id,
        reference_number=reference_number,
        notes=notes
    )
    db.add(movement)
    
    db.commit()
    db.refresh(movement)
    return movement


# ==================== Wastage Tracking ====================

@router.post("/wastage")
def log_wastage(
    item_id: int,
    location_id: int,
    quantity: float,
    uom: str,
    reason: str,
    notes: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Log wastage"""
    # Deduct from stock
    stock = db.query(StockLevel).filter(
        and_(
            StockLevel.item_id == item_id,
            StockLevel.location_id == location_id
        )
    ).first()
    
    if not stock or stock.quantity < quantity:
        raise HTTPException(status_code=400, detail="Insufficient stock")
    
    stock.quantity -= quantity
    stock.last_updated = datetime.utcnow()
    
    # Create wastage log
    wastage = WastageLog(
        item_id=item_id,
        location_id=location_id,
        quantity=quantity,
        uom=uom,
        reason=reason,
        logged_by=current_user.id,
        notes=notes
    )
    db.add(wastage)
    db.commit()
    db.refresh(wastage)
    return wastage


# ==================== Dashboard/Reports ====================

@router.get("/dashboard")
def get_inventory_dashboard(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get inventory dashboard statistics"""
    total_items = db.query(InventoryItem).filter(InventoryItem.is_active == True).count()
    
    # Low stock items
    low_stock = db.query(StockLevel).join(InventoryItem).filter(
        StockLevel.quantity <= InventoryItem.min_stock_level
    ).count()
    
    # Pending indents
    pending_indents = db.query(Indent).filter(Indent.status == IndentStatus.PENDING).count()
    
    # Total stock value (approximate)
    total_value = db.query(
        func.sum(StockLevel.quantity * InventoryItem.unit_price)
    ).join(InventoryItem).scalar() or 0.0
    
    return {
        "total_items": total_items,
        "low_stock_items": low_stock,
        "pending_indents": pending_indents,
        "total_stock_value": float(total_value)
    }

