
from app.database import SessionLocal
from app.models.checkout import Checkout
from app.models.service import AssignedService
from datetime import datetime

def fix_checkout_15():
    db = SessionLocal()
    try:
        # 1. Fetch Checkout 15
        checkout = db.query(Checkout).filter(Checkout.id == 15).first()
        if not checkout:
            print("Checkout 15 not found.")
            return

        print(f"Before Fix: Total={checkout.grand_total}, Service={checkout.service_total}")
        
        # 2. Reset the Service Charge (remove the invalid 5000)
        # We know ID 19 (Massage) caused this.
        if checkout.service_total >= 5000:
            checkout.service_total -= 5000
            checkout.grand_total -= 5000
            print(f"Adjusted: Total={checkout.grand_total}, Service={checkout.service_total}")
        else:
            print("Service total < 5000, skipping adjustment.")

        # 3. Reset the Service ID 19 (Orphan it fully)
        service = db.query(AssignedService).filter(AssignedService.id == 19).first()
        if service:
            print(f"Service 19 status was: {service.billing_status}")
            service.billing_status = 'pending'
            service.booking_id = None
            service.package_booking_id = None
            # Keep the date as 12-11 (invalid for this booking)
            print("Reset Service 19 to 'pending' and unlinked.")

        # 4. Fix Check-out Date (Set to a valid naive datetime)
        # Using today's date for simplicity or keeping existing if valid
        # Let's just ensure it's a standard datetime
        if not checkout.checkout_date:
             checkout.checkout_date = datetime.now()
             print("Set missing checkout_date.")
        else:
             print(f"Existing checkout_date: {checkout.checkout_date}")

        db.commit()
        print("Fix committed successfully.")

    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    fix_checkout_15()
