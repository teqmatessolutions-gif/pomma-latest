from sqlalchemy.orm import Session, joinedload
from typing import List
from datetime import date
from app.models.service import Service, AssignedService, ServiceImage
from app.models.booking import Booking, BookingRoom
from app.models.Package import PackageBooking, PackageBookingRoom
from app.schemas.service import ServiceCreate, AssignedServiceCreate, AssignedServiceUpdate

def create_service(db: Session, name: str, description: str, charges: float, image_urls: List[str] = None):
    db_service = Service(name=name, description=description, charges=charges)
    db.add(db_service)
    db.commit()
    db.refresh(db_service)
    
    if image_urls:
        for url in image_urls:
            img = ServiceImage(service_id=db_service.id, image_url=url)
            db.add(img)
        db.commit()
        db.refresh(db_service)
    
    # Load images relationship
    return db.query(Service).options(joinedload(Service.images)).filter(Service.id == db_service.id).first()

def get_services(db: Session, skip: int = 0, limit: int = 100):
    return db.query(Service).options(joinedload(Service.images)).offset(skip).limit(limit).all()

def delete_service(db: Session, service_id: int):
    service = db.query(Service).filter(Service.id == service_id).first()
    if service:
        db.delete(service)
        db.commit()
        return True
    return False

def create_assigned_service(db: Session, assigned: AssignedServiceCreate):
    # Create instance but don't add yet
    db_assigned = AssignedService(**assigned.dict())
    
    # Auto-link to active booking
    # Check regular booking
    active_booking = (
        db.query(Booking)
        .join(BookingRoom)
        .filter(BookingRoom.room_id == assigned.room_id)
        .filter(Booking.status.in_(['checked-in', 'booked'])) # Include booked for pre-arrival assignment
        .order_by(Booking.check_in.desc())
        .first()
    )
    
    # Check package booking
    active_pkg_booking = (
        db.query(PackageBooking)
        .join(PackageBookingRoom)
        .filter(PackageBookingRoom.room_id == assigned.room_id)
        .filter(PackageBooking.status.in_(['checked-in', 'booked']))
        .order_by(PackageBooking.check_in.desc())
        .first()
    )

    # Determine which one is "current" based on date if both exist, or just pick the one found
    # Prioritize 'checked-in' status if possible, but simplest is to pick the one that covers "today" or recent
    # For now, simplistic logic: linked if found.
    
    if active_booking:
        db_assigned.booking_id = active_booking.id
    elif active_pkg_booking:
        db_assigned.package_booking_id = active_pkg_booking.id

    db.add(db_assigned)
    db.commit()
    db.refresh(db_assigned)
    return db_assigned

def get_assigned_services(db: Session, skip: int = 0, limit: int = 100):
    """
    Get all assigned services, ordered by assignment date (newest first).
    """
    return db.query(AssignedService).options(
        joinedload(AssignedService.service),
        joinedload(AssignedService.employee),
        joinedload(AssignedService.room)
    ).order_by(AssignedService.assigned_at.desc()).offset(skip).limit(limit).all()

def update_assigned_service_status(db: Session, assigned_id: int, update_data: AssignedServiceUpdate):
    assigned = db.query(AssignedService).filter(AssignedService.id == assigned_id).first()
    if assigned:
        assigned.status = update_data.status
        db.commit()
        db.refresh(assigned)
        return assigned
    return None

def delete_assigned_service(db: Session, assigned_id: int):
    assigned = db.query(AssignedService).filter(AssignedService.id == assigned_id).first()
    if assigned:
        db.delete(assigned)
        db.commit()
        return True
    return False
