from pydantic import BaseModel, model_validator
from typing import List

class RoomImage(BaseModel):
    id: int
    image_url: str

    model_config = {
        "from_attributes": True
    }
class RatePlanMappingBase(BaseModel):
    plan_name: str
    occupancy: int = 2
    channel_manager_id: str | None = None
    aiosell_id: str | None = None # Alias for frontend
    price_offset: float = 0.0
    offset_percentage: float = 0.0
    fixed_offset: float = 0.0

class RatePlanMappingCreate(RatePlanMappingBase):
    pass

class RatePlanMappingOut(RatePlanMappingBase):
    id: int
    
    @model_validator(mode='after')
    def set_aiosell_id(self) -> 'RatePlanMappingOut':
        self.aiosell_id = self.channel_manager_id
        return self

    model_config = {
        "from_attributes": True
    }

class RoomBase(BaseModel):
    number: str
    type: str
    price: float
    adults: int = 2
    children: int = 0
    # Room features/amenities
    air_conditioning: bool = False
    wifi: bool = False
    bathroom: bool = False
    living_area: bool = False
    terrace: bool = False
    parking: bool = False
    kitchen: bool = False
    family_room: bool = False
    bbq: bool = False
    garden: bool = False
    dining: bool = False
    breakfast: bool = False
    
    # Aiosell Fields
    channel_manager_id: str | None = None
    aiosell_room_code: str | None = None # Alias for frontend
    online_inventory: int | None = None
    min_stay: int = 1
    cta: bool = False
    ctd: bool = False

class RoomCreate(RoomBase):
    pass

class RoomOut(RoomBase):
    id: int
    status: str
    priority: int | None = None
    image_url: str | None = None
    images: List[RoomImage] = []
    rate_plan_mappings: List[RatePlanMappingOut] = []

    @model_validator(mode='after')
    def set_aiosell_room_code(self) -> 'RoomOut':
        self.aiosell_room_code = self.channel_manager_id
        return self

    model_config = {
        "from_attributes": True  # enables from_orm in Pydantic v2
    }

class RoomPaginatedResponse(BaseModel):
    total: int
    items: List[RoomOut]

class RoomBookingHistoryItem(BaseModel):
    id: int
    display_id: str  # e.g., "BK-000001" or "PK-000001"
    booking_type: str  # "room" or "package"
    guest_name: str
    guest_email: str | None
    guest_mobile: str | None
    check_in: str  # formated date string
    check_out: str # formated date string
    status: str
    adults: int
    children: int
    total_amount: float | None = 0.0
    package_name: str | None = None  # Only for package bookings

    model_config = {
        "from_attributes": True
    }
