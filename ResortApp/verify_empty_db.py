from sqlalchemy import text
from app.database import SessionLocal

def verify_empty():
    db = SessionLocal()
    tables = [
        "rooms", "services", "food_items", "food_categories", "packages",
        "header_banner", "gallery", "reviews", "resort_info", "signature_experiences",
        "plan_weddings", "nearby_attractions", "payments", "expenses", "bookings", "checkouts"
    ]
    
    print("--- Database Verification ---")
    all_empty = True
    for table in tables:
        try:
            count = db.execute(text(f"SELECT COUNT(*) FROM {table}")).scalar()
            if count > 0:
                print(f"[!] {table}: {count} rows (NOT EMPTY)")
                all_empty = False
            else:
                print(f"[✓] {table}: 0 rows (Empty)")
        except Exception as e:
            print(f"[?] {table}: Could not check ({e})")
            
    if all_empty:
        print("\nSUCCESS: All operational tables are empty.")
    else:
        print("\nWARNING: Some tables still contain data.")
        
    db.close()

if __name__ == "__main__":
    verify_empty()
