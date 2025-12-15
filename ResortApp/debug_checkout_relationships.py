
from app.database import SessionLocal
from app.models.checkout import Checkout
from app.models.booking import Booking
from app.models.Package import PackageBooking

def test_relationships():
    db = SessionLocal()
    try:
        checkout_id = 16
        checkout = db.query(Checkout).filter(Checkout.id == checkout_id).first()
        if not checkout:
            print(f"Checkout {checkout_id} not found")
            return

        print(f"Checkout {checkout.id} found.")
        print(f"Booking ID: {checkout.booking_id}")
        print(f"Package Booking ID: {checkout.package_booking_id}")

        print("Accessing checkout.booking...")
        if checkout.booking:
            print(f"Booking linked: ID {checkout.booking.id}, Check-in: {checkout.booking.check_in}")
        else:
            print("checkout.booking is None")

        print("Accessing checkout.package_booking...")
        if checkout.package_booking:
            print(f"Package Booking linked: ID {checkout.package_booking.id}, Check-in: {checkout.package_booking.check_in}")
        else:
            print("checkout.package_booking is None")
            
    except Exception as e:
        print(f"Error accessing relationships: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    test_relationships()
