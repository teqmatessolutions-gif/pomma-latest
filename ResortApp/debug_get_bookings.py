
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.user import User
from app.schemas.booking import BookingOut, RoomOut
from sqlalchemy.orm import joinedload
from pydantic import ValidationError
import sys

def debug_get_bookings():
    # Redirect stdout to file
    with open("debug_output.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        sys.stderr = f
        
        db = SessionLocal()
        try:
            print("Querying bookings with joins...")
            query = db.query(Booking).options(
                joinedload(Booking.booking_rooms).joinedload(BookingRoom.room),
                joinedload(Booking.user).joinedload(User.role)
            ).order_by(Booking.id.desc()).limit(20)
            
            bookings = query.all()
            print(f"Fetched {len(bookings)} bookings.")
            
            for i, booking in enumerate(bookings):
                print(f"Validating Booking ID {booking.id}...")
                try:
                    # Replicating logic from app/api/booking.py
                    booking_out = BookingOut(
                        id=booking.id,
                        guest_name=booking.guest_name,
                        guest_mobile=booking.guest_mobile,
                        guest_email=booking.guest_email,
                        status=booking.status,
                        check_in=booking.check_in,
                        check_out=booking.check_out,
                        adults=booking.adults,
                        children=booking.children,
                        id_card_image_url=getattr(booking, 'id_card_image_url', None),
                        guest_photo_url=getattr(booking, 'guest_photo_url', None),
                        user=booking.user,
                        is_package=False,
                        total_amount=booking.total_amount,
                        rooms=[br.room for br in booking.booking_rooms if br.room]
                    )
                    print(f"  OK")
                except ValidationError as e:
                    print(f"  VALIDATION ERROR for Booking ID {booking.id}:")
                    print(e)
                    break
                except Exception as e:
                    print(f"  RUNTIME ERROR for Booking ID {booking.id}:")
                    print(e)
                    import traceback
                    traceback.print_exc()
                    break

        except Exception as e:
            print(f"Critical Error: {e}")
            import traceback
            traceback.print_exc()
        finally:
            db.close()

if __name__ == "__main__":
    debug_get_bookings()
