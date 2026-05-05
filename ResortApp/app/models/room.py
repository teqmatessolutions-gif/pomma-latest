from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Room(Base):
    __tablename__ = "rooms"

    id = Column(Integer, primary_key=True, index=True)
    number = Column(String, unique=True, nullable=False)
    type = Column(String)
    price = Column(Float)
    status = Column(String, default="Available")
    image_url = Column(String, nullable=True)
    adults = Column(Integer, default=2)      # max adults allowed
    children = Column(Integer, default=0)    # max children allowed
    priority = Column(Integer, nullable=True) # Priority for display order
    
    # Room features/amenities
    air_conditioning = Column(Boolean, default=False)
    wifi = Column(Boolean, default=False)
    bathroom = Column(Boolean, default=False)
    living_area = Column(Boolean, default=False)
    terrace = Column(Boolean, default=False)
    parking = Column(Boolean, default=False)
    kitchen = Column(Boolean, default=False)
    family_room = Column(Boolean, default=False)
    bbq = Column(Boolean, default=False)
    garden = Column(Boolean, default=False)
    dining = Column(Boolean, default=False)
    breakfast = Column(Boolean, default=False)

    # Association (one-to-many with BookingRoom)
    booking_rooms = relationship(
        "BookingRoom",
        back_populates="room",
        cascade="all, delete-orphan"
    )

    package_booking_rooms = relationship(
        "PackageBookingRoom",
        back_populates="room",
        cascade="all, delete-orphan"
    )

    food_orders = relationship(
        "FoodOrder",
        back_populates="room"
    )

    images = relationship(
        "RoomImage",
        back_populates="room",
        cascade="all, delete-orphan"
    )

    # Aiosell / Channel Manager Fields
    aiosell_room_code = Column(String, nullable=True) # e.g. DELUXE
    min_stay = Column(Integer, default=1)
    cta = Column(Boolean, default=False)
    ctd = Column(Boolean, default=False)

    rate_plan_mappings = relationship(
        "RatePlanMapping",
        back_populates="room",
        cascade="all, delete-orphan"
    )

class RatePlanMapping(Base):
    __tablename__ = "rate_plan_mappings"

    id = Column(Integer, primary_key=True, index=True)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=False)
    plan_name = Column(String, nullable=False) # e.g. Luxury Single CP
    occupancy = Column(Integer, default=2)
    aiosell_id = Column(String, nullable=False) # Rate Plan ID in Aiosell
    offset_percentage = Column(Float, default=0.0)
    fixed_offset = Column(Float, default=0.0)

    room = relationship("Room", back_populates="rate_plan_mappings")

class RoomImage(Base):
    __tablename__ = "room_images"

    id = Column(Integer, primary_key=True, index=True)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=False)
    image_url = Column(String, nullable=False)
    
    room = relationship("Room", back_populates="images")



    def __repr__(self):
        return f"<Room id={self.id} number={self.number} status={self.status}>"
