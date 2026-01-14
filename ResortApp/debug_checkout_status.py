
from app.database import SessionLocal
from app.models.room import Room
from app.models.booking import Booking, BookingRoom
from app.models.checkout import Checkout
from app.models.Package import PackageBooking, PackageBookingRoom
from sqlalchemy import func
from datetime import date

db = SessionLocal()
room_number = "101"

print(f"--- Debugging Checkout Status for Room {room_number} ---")

# 1. Check Room
room = db.query(Room).filter(Room.number == room_number).first()
if not room:
    print(f"Room {room_number} not found.")
else:
    print(f"Room ID: {room.id}, Status: {room.status}")

# 2. Check Active Bookings
today = date.today()
print(f"Today: {today}")

# Check Regular Booking
booking_link = (db.query(BookingRoom)
                .join(Booking)
                .filter(BookingRoom.room_id == room.id)
                .order_by(Booking.id.desc()).first())

if booking_link:
    booking = booking_link.booking
    print(f"Latest Regular Booking ID: {booking.id}")
    print(f"  Status: {booking.status}")
    print(f"  Check-in: {booking.check_in}, Check-out: {booking.check_out}")
    print(f"  Guest: {booking.guest_name}")
else:
    print("No Regular Booking found.")

# Check Package Booking
package_link = (db.query(PackageBookingRoom)
                .join(PackageBooking)
                .filter(PackageBookingRoom.room_id == room.id)
                .order_by(PackageBooking.id.desc()).first())

if package_link:
    pkg_booking = package_link.package_booking
    print(f"Latest Package Booking ID: {pkg_booking.id}")
    print(f"  Status: {pkg_booking.status}")
    print(f"  Check-in: {pkg_booking.check_in}, Check-out: {pkg_booking.check_out}")
    print(f"  Guest: {pkg_booking.guest_name}")
else:
    print("No Package Booking found.")

# 3. Check for Existing Checkouts Today
existing_checkout = db.query(Checkout).filter(
    Checkout.room_number == room_number,
    func.date(Checkout.checkout_date) == today
).first()

if existing_checkout:
    print(f"CONFLICT DETECTED: Checkout already exists for today!")
    print(f"  Checkout ID: {existing_checkout.id}")
    print(f"  Date: {existing_checkout.checkout_date}")
else:
    print("No checkout record found for today.")

db.close()
