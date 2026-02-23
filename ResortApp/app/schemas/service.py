from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from enum import Enum

class ServiceBase(BaseModel):
    name: str
    description: Optional[str] = None
    charges: float

class ServiceCreate(ServiceBase):
    pass

class ServiceUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    charges: Optional[float] = None



class ServiceImageOut(BaseModel):
    id: int
    image_url: str

    class Config:
        from_attributes = True


class ServiceOut(ServiceBase):
    id: int
    created_at: datetime
    images: List[ServiceImageOut] = []

    class Config:
        from_attributes = True

# For employee and room resolution
class EmployeeOut(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True

class RoomOut(BaseModel):
    id: int
    number: str

    class Config:
        from_attributes = True

class ServiceStatus(str, Enum):
    pending = "pending"
    in_progress = "in_progress"
    completed = "completed"
    cancelled = "cancelled"

class AssignedServiceBase(BaseModel):
    service_id: int
    employee_id: Optional[int] = None
    room_id: Optional[int] = None

class AssignedServiceCreate(AssignedServiceBase):
    status: Optional[ServiceStatus] = ServiceStatus.pending

class AssignedServiceUpdate(BaseModel):
    status: ServiceStatus

class AssignedServiceOut(BaseModel):
    id: int
    service: ServiceOut
    employee: Optional[EmployeeOut] = None
    room: Optional[RoomOut] = None
    assigned_at: datetime
    status: ServiceStatus

    class Config:
        from_attributes = True

class AssignedServicePaginationOut(BaseModel):
    items: List[AssignedServiceOut]
    total: int
    page: int
    limit: int

    class Config:
        from_attributes = True
