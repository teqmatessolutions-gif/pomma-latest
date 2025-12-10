from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey, Date, DateTime, Text, Enum
from sqlalchemy.orm import relationship
from app.database import Base
from datetime import datetime
import enum


# Inventory Category (Customizable)
class InventoryCategory(Base):
    __tablename__ = "inventory_categories"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    description = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    items = relationship("InventoryItem", back_populates="category_ref")


# Unit of Measurement (Customizable)
class UnitOfMeasurement(Base):
    __tablename__ = "units_of_measurement"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)  # e.g., "pieces", "kg", "liters"
    symbol = Column(String, nullable=True)  # e.g., "pcs", "kg", "L"
    description = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    items = relationship("InventoryItem", back_populates="uom_ref")


class LocationType(str, enum.Enum):
    CENTRAL_WAREHOUSE = "central_warehouse"
    BRANCH_STORE = "branch_store"
    SUB_STORE = "sub_store"  # Kitchen, Housekeeping, Bar, Room


class StockState(str, enum.Enum):
    IN_ROOM = "in_room"
    IN_CLOSET = "in_closet"
    IN_LAUNDRY = "in_laundry"
    IN_STORE = "in_store"
    DAMAGED = "damaged"
    LOST = "lost"


class IndentStatus(str, enum.Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"
    FULFILLED = "fulfilled"


# Master Inventory Item
class InventoryItem(Base):
    __tablename__ = "inventory_items"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    category_id = Column(Integer, ForeignKey("inventory_categories.id"), nullable=False)
    sku = Column(String, unique=True, nullable=True)  # Stock Keeping Unit
    barcode = Column(String, nullable=True)
    
    # Base unit of measurement
    base_uom_id = Column(Integer, ForeignKey("units_of_measurement.id"), nullable=False)
    
    # Pricing (for consumables)
    unit_price = Column(Float, default=0.0)
    selling_price = Column(Float, default=0.0)
    
    # Tracking
    track_expiry = Column(Boolean, default=False)  # For raw materials
    track_serial = Column(Boolean, default=False)  # For fixed assets
    track_batch = Column(Boolean, default=False)  # For linens
    
    # Low stock alert
    min_stock_level = Column(Float, default=0.0)
    max_stock_level = Column(Float, default=0.0)
    
    # Status
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    category_ref = relationship("InventoryCategory", back_populates="items")
    uom_ref = relationship("UnitOfMeasurement", back_populates="items")
    uom_conversions = relationship("UOMConversion", back_populates="item", cascade="all, delete-orphan")
    stock_levels = relationship("StockLevel", back_populates="item", cascade="all, delete-orphan")
    room_inventory_items = relationship("RoomInventoryItem", back_populates="item", cascade="all, delete-orphan")
    room_assets = relationship("RoomAsset", back_populates="item", cascade="all, delete-orphan")
    recipe_ingredients = relationship("RecipeIngredient", back_populates="item", cascade="all, delete-orphan")
    stock_movements = relationship("StockMovement", back_populates="item", cascade="all, delete-orphan")
    indents = relationship("IndentItem", back_populates="item", cascade="all, delete-orphan")


# Location Hierarchy
class Location(Base):
    __tablename__ = "locations"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    code = Column(String, unique=True, nullable=True)
    location_type = Column(Enum(LocationType), nullable=False)
    parent_location_id = Column(Integer, ForeignKey("locations.id"), nullable=True)
    description = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Self-referential relationship for hierarchy
    parent = relationship("Location", remote_side=[id], backref="children")
    
    # Relationships
    stock_levels = relationship("StockLevel", back_populates="location", cascade="all, delete-orphan")
    stock_movements_from = relationship("StockMovement", foreign_keys="StockMovement.from_location_id", back_populates="from_location")
    stock_movements_to = relationship("StockMovement", foreign_keys="StockMovement.to_location_id", back_populates="to_location")
    indents = relationship("Indent", foreign_keys="Indent.requested_from_location_id", back_populates="requested_from_location")
    indents_to = relationship("Indent", foreign_keys="Indent.requested_to_location_id", back_populates="requested_to_location")


# UOM Conversion (e.g., 1 kg = 1000 grams)
class UOMConversion(Base):
    __tablename__ = "uom_conversions"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    from_uom = Column(String, nullable=False)  # e.g., "kg"
    to_uom = Column(String, nullable=False)  # e.g., "g"
    conversion_factor = Column(Float, nullable=False)  # e.g., 1000 (1 kg = 1000 g)

    item = relationship("InventoryItem", back_populates="uom_conversions")


# Stock Level at each location
class StockLevel(Base):
    __tablename__ = "stock_levels"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    location_id = Column(Integer, ForeignKey("locations.id"), nullable=False)
    quantity = Column(Float, default=0.0)
    uom = Column(String, nullable=False)  # Unit of measurement for this stock
    expiry_date = Column(Date, nullable=True)  # For items with expiry
    batch_number = Column(String, nullable=True)  # For batch tracking
    last_updated = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    item = relationship("InventoryItem", back_populates="stock_levels")
    location = relationship("Location", back_populates="stock_levels")


# Room Inventory (Minibar Items - Payable)
class RoomInventoryItem(Base):
    __tablename__ = "room_inventory_items"

    id = Column(Integer, primary_key=True, index=True)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=False)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    par_stock = Column(Float, default=0.0)  # Standard quantity that should be in room
    current_stock = Column(Float, default=0.0)  # Current quantity found
    last_audit_date = Column(DateTime, nullable=True)
    last_audited_by = Column(Integer, ForeignKey("users.id"), nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    room = relationship("Room", backref="inventory_items")
    item = relationship("InventoryItem", back_populates="room_inventory_items")


# Room Inventory Audit Log
class RoomInventoryAudit(Base):
    __tablename__ = "room_inventory_audits"

    id = Column(Integer, primary_key=True, index=True)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=False)
    room_inventory_item_id = Column(Integer, ForeignKey("room_inventory_items.id"), nullable=False)
    expected_quantity = Column(Float, nullable=False)
    found_quantity = Column(Float, nullable=False)
    consumed_quantity = Column(Float, default=0.0)  # Auto-calculated: expected - found
    billed_amount = Column(Float, default=0.0)  # Amount added to room invoice
    audit_date = Column(DateTime, default=datetime.utcnow)
    audited_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    notes = Column(Text, nullable=True)

    room = relationship("Room", backref="inventory_audits")
    room_inventory_item = relationship("RoomInventoryItem", backref="audits")


# Room Assets (Fixed Assets with QR/Tag)
class RoomAsset(Base):
    __tablename__ = "room_assets"

    id = Column(Integer, primary_key=True, index=True)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=False)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    asset_id = Column(String, unique=True, nullable=False)  # Unique asset ID (e.g., TV-R101-Samsung)
    qr_code = Column(String, nullable=True)  # QR code data
    serial_number = Column(String, nullable=True)
    status = Column(String, default="good")  # good, damaged, missing, maintenance
    purchase_date = Column(Date, nullable=True)
    purchase_price = Column(Float, nullable=True)
    last_inspection_date = Column(Date, nullable=True)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    room = relationship("Room", backref="assets")
    item = relationship("InventoryItem", back_populates="room_assets")
    inspections = relationship("AssetInspection", back_populates="asset", cascade="all, delete-orphan")


# Asset Inspection Log
class AssetInspection(Base):
    __tablename__ = "asset_inspections"

    id = Column(Integer, primary_key=True, index=True)
    asset_id = Column(Integer, ForeignKey("room_assets.id"), nullable=False)
    inspection_date = Column(DateTime, default=datetime.utcnow)
    inspected_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    status = Column(String, default="good")  # good, damaged, missing
    damage_description = Column(Text, nullable=True)
    charge_to_guest = Column(Boolean, default=False)
    charge_amount = Column(Float, default=0.0)
    notes = Column(Text, nullable=True)

    asset = relationship("RoomAsset", back_populates="inspections")


# Linen Management (Circulating Assets)
class LinenStock(Base):
    __tablename__ = "linen_stocks"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    location_id = Column(Integer, ForeignKey("locations.id"), nullable=False)
    state = Column(Enum(StockState), nullable=False)  # in_room, in_closet, in_laundry, etc.
    quantity = Column(Integer, default=0)
    last_updated = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    item = relationship("InventoryItem", backref="linen_stocks")
    location = relationship("Location", backref="linen_stocks")


# Linen Movement Log
class LinenMovement(Base):
    __tablename__ = "linen_movements"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=True)
    from_state = Column(Enum(StockState), nullable=True)
    to_state = Column(Enum(StockState), nullable=False)
    quantity = Column(Integer, nullable=False)
    movement_date = Column(DateTime, default=datetime.utcnow)
    moved_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    notes = Column(Text, nullable=True)

    item = relationship("InventoryItem", backref="linen_movements")
    room = relationship("Room", backref="linen_movements")


# Recipe Management
class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    food_item_id = Column(Integer, ForeignKey("food_items.id"), nullable=True)  # Link to menu item
    servings = Column(Integer, default=1)  # Number of servings this recipe makes
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    food_item = relationship("FoodItem", backref="recipe")
    ingredients = relationship("RecipeIngredient", back_populates="recipe", cascade="all, delete-orphan")


# Recipe Ingredients
class RecipeIngredient(Base):
    __tablename__ = "recipe_ingredients"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"), nullable=False)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    quantity = Column(Float, nullable=False)
    uom = Column(String, nullable=False)  # Unit of measurement
    notes = Column(Text, nullable=True)

    recipe = relationship("Recipe", back_populates="ingredients")
    item = relationship("InventoryItem", back_populates="recipe_ingredients")


# Wastage Tracking
class WastageLog(Base):
    __tablename__ = "wastage_logs"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    location_id = Column(Integer, ForeignKey("locations.id"), nullable=False)
    quantity = Column(Float, nullable=False)
    uom = Column(String, nullable=False)
    reason = Column(String, nullable=False)  # dropped, spoiled, expired, etc.
    wastage_date = Column(DateTime, default=datetime.utcnow)
    logged_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    notes = Column(Text, nullable=True)

    item = relationship("InventoryItem", backref="wastage_logs")
    location = relationship("Location", backref="wastage_logs")


# Stock Movement (Transfers, Issues, Receipts)
class StockMovement(Base):
    __tablename__ = "stock_movements"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    movement_type = Column(String, nullable=False)  # transfer, issue, receipt, adjustment
    from_location_id = Column(Integer, ForeignKey("locations.id"), nullable=True)
    to_location_id = Column(Integer, ForeignKey("locations.id"), nullable=False)
    quantity = Column(Float, nullable=False)
    uom = Column(String, nullable=False)
    batch_number = Column(String, nullable=True)
    expiry_date = Column(Date, nullable=True)
    movement_date = Column(DateTime, default=datetime.utcnow)
    moved_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    reference_number = Column(String, nullable=True)  # For linking to indent, purchase, etc.
    notes = Column(Text, nullable=True)

    item = relationship("InventoryItem", back_populates="stock_movements")
    from_location = relationship("Location", foreign_keys=[from_location_id], back_populates="stock_movements_from")
    to_location = relationship("Location", foreign_keys=[to_location_id], back_populates="stock_movements_to")


# Indent System (Internal Requests)
class Indent(Base):
    __tablename__ = "indents"

    id = Column(Integer, primary_key=True, index=True)
    indent_number = Column(String, unique=True, nullable=False)
    requested_from_location_id = Column(Integer, ForeignKey("locations.id"), nullable=False)  # Who is requesting
    requested_to_location_id = Column(Integer, ForeignKey("locations.id"), nullable=False)  # From which store
    status = Column(Enum(IndentStatus), default=IndentStatus.PENDING)
    requested_by = Column(Integer, ForeignKey("users.id"), nullable=False)
    approved_by = Column(Integer, ForeignKey("users.id"), nullable=True)
    requested_date = Column(DateTime, default=datetime.utcnow)
    approved_date = Column(DateTime, nullable=True)
    fulfilled_date = Column(DateTime, nullable=True)
    notes = Column(Text, nullable=True)

    requested_from_location = relationship("Location", foreign_keys=[requested_from_location_id], back_populates="indents")
    requested_to_location = relationship("Location", foreign_keys=[requested_to_location_id], back_populates="indents_to")
    items = relationship("IndentItem", back_populates="indent", cascade="all, delete-orphan")


# Indent Items
class IndentItem(Base):
    __tablename__ = "indent_items"

    id = Column(Integer, primary_key=True, index=True)
    indent_id = Column(Integer, ForeignKey("indents.id"), nullable=False)
    item_id = Column(Integer, ForeignKey("inventory_items.id"), nullable=False)
    requested_quantity = Column(Float, nullable=False)
    approved_quantity = Column(Float, nullable=True)
    issued_quantity = Column(Float, default=0.0)
    uom = Column(String, nullable=False)
    notes = Column(Text, nullable=True)

    indent = relationship("Indent", back_populates="items")
    item = relationship("InventoryItem", back_populates="indents")

