"""
clear_operational_data.py
--------------------------
Clears all operational/transactional data from the resort database:
  - Checkouts
  - Food Order Items
  - Food Orders
  - Assigned Services
  - Package Check-In Documents
  - Package Booking Rooms
  - Package Bookings
  - Check-In Documents
  - Booking Rooms
  - Bookings

PRESERVES (not touched):
  - Rooms & Room Images
  - Packages & Package Images
  - Services & Service Images
  - Food Items & Food Categories
  - Users / Employees
  - CMS / Frontend content
  - Expenses / Suggestions

Usage:
    python clear_operational_data.py
"""

import sys
import os
from sqlalchemy.orm import Session

# Resolve paths relative to THIS script, not the CWD
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, SCRIPT_DIR)

from dotenv import load_dotenv
# Explicitly point to the .env file next to this script
load_dotenv(os.path.join(SCRIPT_DIR, ".env"))

from app.database import SessionLocal
from app.models.checkout import Checkout
from app.models.foodorder import FoodOrder, FoodOrderItem
from app.models.service import AssignedService
from app.models.Package import PackageBooking, PackageBookingRoom, PackageCheckInDocument
from app.models.booking import Booking, BookingRoom, CheckInDocument


def count_records(db: Session) -> dict:
    """Return current row counts for all tables that will be cleared."""
    return {
        "Checkouts":                  db.query(Checkout).count(),
        "Food Order Items":           db.query(FoodOrderItem).count(),
        "Food Orders":                db.query(FoodOrder).count(),
        "Assigned Services":          db.query(AssignedService).count(),
        "Package Check-In Documents": db.query(PackageCheckInDocument).count(),
        "Package Booking Rooms":      db.query(PackageBookingRoom).count(),
        "Package Bookings":           db.query(PackageBooking).count(),
        "Check-In Documents":         db.query(CheckInDocument).count(),
        "Booking Rooms":              db.query(BookingRoom).count(),
        "Bookings":                   db.query(Booking).count(),
    }


def clear_operational_data():
    print("=" * 60)
    print("  RESORT OPERATIONAL DATA CLEANUP SCRIPT")
    print("=" * 60)

    db: Session = SessionLocal()

    try:
        # ── Show counts before cleanup ──────────────────────────────
        print("\n📊  Current record counts BEFORE cleanup:")
        before = count_records(db)
        for table, cnt in before.items():
            print(f"    {table:<30} {cnt:>6} row(s)")

        total_before = sum(before.values())
        if total_before == 0:
            print("\n✅  Nothing to delete – all tables are already empty.")
            return

        # ── Confirmation prompt ─────────────────────────────────────
        print(f"\n⚠️   This will permanently delete {total_before} record(s).")
        print("    Rooms, Packages, Services, Food Items, Users "
              "and Employees will NOT be affected.\n")
        confirm = input("    Type  YES  to proceed: ").strip()
        if confirm != "YES":
            print("\n❌  Aborted. No data was deleted.")
            return

        print("\n🗑️   Deleting records...\n")

        # ── Deletion order (children before parents) ────────────────

        # 1. Checkouts first (FK references bookings / package_bookings)
        cnt = db.query(Checkout).delete(synchronize_session=False)
        print(f"    ✔ Checkouts deleted              : {cnt}")

        # 2. Food Order Items (child of FoodOrder)
        cnt = db.query(FoodOrderItem).delete(synchronize_session=False)
        print(f"    ✔ Food Order Items deleted        : {cnt}")

        # 3. Food Orders
        cnt = db.query(FoodOrder).delete(synchronize_session=False)
        print(f"    ✔ Food Orders deleted             : {cnt}")

        # 4. Assigned Services
        cnt = db.query(AssignedService).delete(synchronize_session=False)
        print(f"    ✔ Assigned Services deleted       : {cnt}")

        # 5. Package Check-In Documents
        cnt = db.query(PackageCheckInDocument).delete(synchronize_session=False)
        print(f"    ✔ Package Check-In Docs deleted   : {cnt}")

        # 6. Package Booking Rooms (join table)
        cnt = db.query(PackageBookingRoom).delete(synchronize_session=False)
        print(f"    ✔ Package Booking Rooms deleted   : {cnt}")

        # 7. Package Bookings
        cnt = db.query(PackageBooking).delete(synchronize_session=False)
        print(f"    ✔ Package Bookings deleted        : {cnt}")

        # 8. Check-In Documents (child of Booking)
        cnt = db.query(CheckInDocument).delete(synchronize_session=False)
        print(f"    ✔ Check-In Documents deleted      : {cnt}")

        # 9. Booking Rooms (join table)
        cnt = db.query(BookingRoom).delete(synchronize_session=False)
        print(f"    ✔ Booking Rooms deleted           : {cnt}")

        # 10. Bookings
        cnt = db.query(Booking).delete(synchronize_session=False)
        print(f"    ✔ Bookings deleted                : {cnt}")

        # ── Commit ─────────────────────────────────────────────────
        db.commit()

        # ── Verify after cleanup ───────────────────────────────────
        print("\n📊  Record counts AFTER cleanup:")
        after = count_records(db)
        for table, cnt in after.items():
            print(f"    {table:<30} {cnt:>6} row(s)")

        print("\n✅  Cleanup completed successfully!")
        print("    Preserved: Rooms, Packages, Services, Food Items, "
              "Users, Employees, CMS content.\n")

    except Exception as exc:
        db.rollback()
        print(f"\n❌  Error during cleanup: {exc}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    clear_operational_data()
