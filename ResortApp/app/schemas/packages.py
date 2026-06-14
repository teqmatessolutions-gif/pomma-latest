from pydantic import BaseModel, Field, model_validator
from datetime import date, datetime
from typing import List, Optional


from app.schemas.room import RatePlanMappingOut

class PackageImageOut(BaseModel):
    id: int
    image_url: str

    class Config:
        from_attributes = True


class PackageOut(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    price: float
    booking_type: Optional[str] = "room_type"  # "whole_property" or "room_type"
    room_types: Optional[str] = None  # Comma-separated list of room types
    status: Optional[str] = "Available"
    priority: Optional[int] = None  # Display order priority (1 = first, 2 = second, etc. NULL = last)
    
    # Aiosell Fields
    channel_manager_id: str | None = None
    aiosell_room_code: str | None = None # Alias for frontend
    online_inventory: int | None = None
    min_stay: int = 1
    cta: bool = False
    ctd: bool = False

    images: List[PackageImageOut] = Field(default_factory=list)
    rate_plan_mappings: List[RatePlanMappingOut] = Field(default_factory=list)
    created_at: Optional[datetime] = None

    @model_validator(mode='after')
    def set_aiosell_room_code(self) -> 'PackageOut':
        self.aiosell_room_code = self.channel_manager_id
        return self

    class Config:
        from_attributes = True


# New schema to represent the Room model
class RoomOut(BaseModel):
    id: int
    number: str
    type: str

    class Config:
        from_attributes = True


# Updated schema to correctly nest the RoomOut model
class PackageBookingRoomOut(BaseModel):
    id: int
    room_id: int
    room: Optional[RoomOut] = None# ✅ match SQLAlchemy relationship

    class Config:
        from_attributes = True

class PackageBookingBase(BaseModel):
    package_id: int
    guest_name: str
    guest_email: Optional[str] = None
    guest_mobile: Optional[str] = None
    check_in: date
    check_out: date
    adults: int = 2
    children: int = 0
    class Config:
        from_attributes = True


class PackageBookingCreate(PackageBookingBase):
    room_ids: List[int]
    class Config:
        from_attributes = True


class PackageBookingUpdate(BaseModel):
    status: Optional[str] = None
    adults: Optional[int] = None
    children: Optional[int] = None
    class Config:
        from_attributes = True


class PackageBookingOut(PackageBookingBase):
    id: int
    display_id: Optional[str] = None  # Format: PK-000001
    status: str
    rooms: List[PackageBookingRoomOut] = Field(default_factory=list)
    package: Optional[PackageOut]
    total_amount: Optional[float] = 0.0
    
    @model_validator(mode='after')
    def set_display_id(self):
        """Auto-generate display_id if not provided"""
        if not self.display_id:
            self.display_id = f"PK-{str(self.id).zfill(6)}"
        return self

    class Config:
        from_attributes = True

class PackageBookingPaginationOut(BaseModel):
    items: List[PackageBookingOut]
    total: int
    page: int
    limit: int

    class Config:
        from_attributes = True
