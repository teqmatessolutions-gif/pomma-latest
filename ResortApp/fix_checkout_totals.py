import sys
from sqlalchemy import create_engine, text
import math

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

def fix_totals():
    with engine.connect() as conn:
        print("Checking for header mismatches...")
        checkouts = conn.execute(text("SELECT * FROM checkouts")).mappings().all()
        
        fixed_count = 0
        for c in checkouts:
            # Calculate actual totals from linked items
            food_sum = 0
            service_sum = 0
            
            # Get Food Sum
            if c.package_booking_id:
                res = conn.execute(text("SELECT SUM(amount) FROM food_orders WHERE package_booking_id = :pid"), {"pid": c.package_booking_id}).scalar()
                food_sum = res if res else 0
            elif c.booking_id:
                res = conn.execute(text("SELECT SUM(amount) FROM food_orders WHERE booking_id = :bid"), {"bid": c.booking_id}).scalar()
                food_sum = res if res else 0
            
            # Get Service Sum
            # Services need to join with service table for charges
            if c.package_booking_id:
                res = conn.execute(text("""
                    SELECT SUM(ser.charges) 
                    FROM assigned_services s 
                    JOIN services ser ON s.service_id = ser.id
                    WHERE s.package_booking_id = :pid
                """), {"pid": c.package_booking_id}).scalar()
                service_sum = res if res else 0
            elif c.booking_id:
                 res = conn.execute(text("""
                    SELECT SUM(ser.charges) 
                    FROM assigned_services s 
                    JOIN services ser ON s.service_id = ser.id
                    WHERE s.booking_id = :bid
                """), {"bid": c.booking_id}).scalar()
                 service_sum = res if res else 0
                 
            # Compare
            current_food = c.food_total or 0
            current_service = c.service_total or 0
            
            # Using small epsilon for float comparison logic, though DB is likely numeric/decimal
            # but getting back python Decimal or float.
            mismatch = False
            if abs(float(current_food) - float(food_sum)) > 0.01:
                mismatch = True
            if abs(float(current_service) - float(service_sum)) > 0.01:
                mismatch = True
                
            if mismatch:
                print(f"Checkout {c.id} Mismatch:")
                print(f"  Food: Stored={current_food}, Calc={food_sum}")
                print(f"  Service: Stored={current_service}, Calc={service_sum}")
                
                # Calculate Deltas
                delta_food = float(food_sum) - float(current_food)
                delta_service = float(service_sum) - float(current_service)
                
                # Calculate Tax Delta (Assuming 5% entirely on food. Service has no tax in code)
                # Note: Existing logic: food_gst = food_total * 0.05
                # So delta_tax = delta_food * 0.05
                delta_tax = delta_food * 0.05
                
                new_food_total = food_sum
                new_service_total = service_sum
                new_tax = (float(c.tax_amount or 0) + delta_tax)
                new_grand = (float(c.grand_total or 0) + delta_food + delta_service + delta_tax)
                
                print(f"  -> Updating: Tax += {delta_tax:.2f}, Grand += {delta_food + delta_service + delta_tax:.2f}")
                
                conn.execute(text("""
                    UPDATE checkouts 
                    SET food_total = :ft, service_total = :st, tax_amount = :tax, grand_total = :gt
                    WHERE id = :id
                """), {
                    "ft": new_food_total,
                    "st": new_service_total,
                    "tax": new_tax,
                    "gt": new_grand,
                    "id": c.id
                })
                fixed_count += 1
        
        conn.commit()
        print(f"Fixed {fixed_count} checkouts.")

if __name__ == "__main__":
    fix_totals()
