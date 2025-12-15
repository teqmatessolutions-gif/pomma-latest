from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import List, Optional

class FoodOrderItemCreate(BaseModel):
    food_item_id: int
    quantity: int

class FoodOrderCreate(BaseModel):
    room_id: int
    amount: float
    assigned_employee_id: int
    items: List[FoodOrderItemCreate]
    billing_status: Optional[str] = "unbilled" 

class FoodOrderItemOut(BaseModel):
    id: int
    food_item_id: int
    quantity: int
    food_item_name: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

from app.schemas.room import RoomOut
from app.schemas.employee import Employee

class FoodOrderOut(BaseModel):
    id: int
    room_id: int
    amount: float
    status: str
    assigned_employee_id: int
    billing_status: str
    created_at: Optional[datetime] = None
    items: List[FoodOrderItemOut]
    guest_name: Optional[str] = None
    
    # Relationships
    room: Optional[RoomOut] = None
    employee: Optional[Employee] = None

    model_config = ConfigDict(from_attributes=True)

class FoodOrderUpdate(BaseModel):
    room_id: Optional[int] = None
    amount: Optional[float] = None
    assigned_employee_id: Optional[int] = None
    status: Optional[str] = None
    billing_status: Optional[str] = None
    items: Optional[List[FoodOrderItemCreate]] = None
