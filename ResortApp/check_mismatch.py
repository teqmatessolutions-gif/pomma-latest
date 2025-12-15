import sys
from sqlalchemy import create_engine, text
import os

# Load env safely
db_url = None
try:
    with open(".env", "r", encoding="utf-8-sig") as f:
        for line in f:
            if line.startswith("DATABASE_URL="):
                db_url = line.strip().split("=", 1)[1]
                break
except:
    pass

if not db_url:
    print("Error: DATABASE_URL not found")
    sys.exit(1)

engine = create_engine(db_url)

def check_mismatch():
    with engine.connect() as conn:
        print("--- Checking Mismatch for Checkout 9 ---")
        checkout = conn.execute(text("SELECT * FROM checkouts WHERE id = 9")).mappings().first()
        if not checkout:
             print("Checkout 9 not found")
             return

        print(f"Checkout Stored Totals:")
        print(f"  Food Total: {checkout.food_total}")
        print(f"  Service Total: {checkout.service_total}")
        print(f"  Grand Total: {checkout.grand_total}")
        
        # Calculate from linked items
        print("\nCalculated from Linked Items:")
        
        # Food
        food_sum = 0
        if checkout.package_booking_id:
            orders = conn.execute(text("SELECT * FROM food_orders WHERE package_booking_id = :pid"), {"pid": checkout.package_booking_id}).mappings().all()
            print(f"  Found {len(orders)} Food Orders linked to PBID {checkout.package_booking_id}")
            for o in orders:
                print(f"    - Order {o.id}: {o.amount}")
                food_sum += o.amount
        elif checkout.booking_id:
             orders = conn.execute(text("SELECT * FROM food_orders WHERE booking_id = :bid"), {"bid": checkout.booking_id}).mappings().all()
             print(f"  Found {len(orders)} Food Orders linked to BID {checkout.booking_id}")
             for o in orders:
                print(f"    - Order {o.id}: {o.amount}")
                food_sum += o.amount
        
        print(f"  -> Sum of Food Items: {food_sum}")
        print(f"  -> Mismatch (Food): {food_sum - (checkout.food_total or 0)}")

        # Services
        service_sum = 0
        if checkout.package_booking_id:
            services = conn.execute(text("""
                SELECT s.id, s.service_id, ser.charges 
                FROM assigned_services s 
                JOIN services ser ON s.service_id = ser.id
                WHERE s.package_booking_id = :pid
            """), {"pid": checkout.package_booking_id}).mappings().all()
            print(f"  Found {len(services)} Services linked to PBID {checkout.package_booking_id}")
            for s in services:
                 print(f"    - Service {s.id}: {s.charges}")
                 service_sum += s.charges
        elif checkout.booking_id:
             services = conn.execute(text("""
                SELECT s.id, s.service_id, ser.charges 
                FROM assigned_services s 
                JOIN services ser ON s.service_id = ser.id
                WHERE s.booking_id = :bid
            """), {"bid": checkout.booking_id}).mappings().all()
             print(f"  Found {len(services)} Services linked to BID {checkout.booking_id}")
             for s in services:
                 print(f"    - Service {s.id}: {s.charges}")
                 service_sum += s.charges

        print(f"  -> Sum of Service Items: {service_sum}")
        print(f"  -> Mismatch (Service): {service_sum - (checkout.service_total or 0)}")

if __name__ == "__main__":
    check_mismatch()
