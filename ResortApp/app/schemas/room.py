from pydantic import BaseModel
from typing import List

class RoomImage(BaseModel):
    id: int
    image_url: str

    model_config = {
        "from_attributes": True
    }
class RoomBase(BaseModel):
    number: str
    type: str
    price: float
    adults: int = 2      # new field
    children: int = 0    # new field
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

class RoomCreate(RoomBase):
    pass

class RoomOut(RoomBase):
    id: int
    status: str
    priority: int | None = None
    image_url: str | None = None
    images: List[RoomImage] = []

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
