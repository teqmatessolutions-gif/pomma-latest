"""
clear_server_data.py
---------------------
Standalone script — NO app imports required.
Works with the compiled backend at /opt/pomma/ResortApp/dist

Connects directly to PostgreSQL using the DATABASE_URL from .env
and clears all operational/transactional data.

Tables CLEARED:
  checkouts
  food_order_items
  food_orders
  assigned_services
  package_checkin_documents
  package_booking_rooms
  package_bookings
  checkin_documents
  booking_rooms
  bookings

Tables PRESERVED (NOT touched):
  rooms, room_images
  packages, package_images
  services, service_images
  food_items, food_categories
  users, employees
  expenses, suggestions, frontend / CMS tables
"""

import sys
import os
import re

# ── Get DATABASE_URL (multiple fallback methods) ──────────────
#
# Priority:
#  1. Command-line argument:  python3 clear_server_data.py "postgresql://..."
#  2. Environment variable:   DATABASE_URL=postgresql://... python3 clear_server_data.py
#  3. .env file (auto-search)
#  4. Interactive prompt

DATABASE_URL = ""

# 1. CLI argument
if len(sys.argv) > 1:
    DATABASE_URL = sys.argv[1]
    print(f"✅  Using DATABASE_URL from command-line argument.")

# 2. Environment variable
if not DATABASE_URL:
    DATABASE_URL = os.environ.get("DATABASE_URL", "")
    if DATABASE_URL:
        print(f"✅  Using DATABASE_URL from environment variable.")

# 3. .env file search
if not DATABASE_URL:
    SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
    ENV_CANDIDATES = [
        os.path.join(SCRIPT_DIR, ".env"),
        os.path.join(SCRIPT_DIR, "..", ".env"),
        os.path.join(SCRIPT_DIR, "..", "..", ".env"),
        "/opt/pomma/ResortApp/.env",
        "/opt/pomma/ResortApp/dist/.env",
        "/opt/pomma/.env",
        os.path.expanduser("~/.env"),
    ]
    for candidate in ENV_CANDIDATES:
        candidate = os.path.normpath(candidate)
        if os.path.exists(candidate):
            with open(candidate) as f:
                for line in f:
                    line = line.strip()
                    if line.startswith("DATABASE_URL="):
                        DATABASE_URL = line.partition("=")[2].strip()
                        print(f"✅  Using .env at: {candidate}")
                        break
            if DATABASE_URL:
                break

# 4. Interactive prompt
if not DATABASE_URL:
    print("\n⚠️   Could not find .env file. Please enter the DATABASE_URL manually.")
    print("    Format: postgresql://user:password@host:port/dbname")
    print("    (You can find this in your server's app config)\n")
    DATABASE_URL = input("    DATABASE_URL: ").strip()

if not DATABASE_URL:
    print("❌  No DATABASE_URL provided. Cannot continue.")
    sys.exit(1)



# ── Parse DATABASE_URL ────────────────────────────────────────
# Format: postgresql://user:password@host:port/dbname
def parse_db_url(url):
    pattern = r"postgresql(?:\+\w+)?://([^:]+):([^@]+)@([^:/]+):?(\d+)?/(\S+)"
    m = re.match(pattern, url)
    if not m:
        raise ValueError(f"Cannot parse DATABASE_URL: {url}")
    return {
        "user":     m.group(1),
        "password": m.group(2),
        "host":     m.group(3),
        "port":     int(m.group(4)) if m.group(4) else 5432,
        "dbname":   m.group(5),
    }

try:
    db_params = parse_db_url(DATABASE_URL)
except ValueError as e:
    print(f"❌  {e}")
    sys.exit(1)

# ── Import psycopg2 ───────────────────────────────────────────
try:
    import psycopg2
    from psycopg2 import sql
except ImportError:
    print("❌  psycopg2 is not installed.")
    print("    Install it with:  pip install psycopg2-binary")
    sys.exit(1)


# Ordered: children first so FK constraints don't block deletion
TABLES_TO_CLEAR = [
    "checkouts",                   # references bookings & package_bookings
    "food_order_items",            # child of food_orders
    "food_orders",                 # references bookings, package_bookings, rooms
    "assigned_services",           # references bookings, package_bookings, rooms
    "package_checkin_documents",   # child of package_bookings
    "package_booking_rooms",       # join table for package_bookings
    "package_bookings",            # parent package booking
    "checkin_documents",           # child of bookings
    "booking_rooms",               # join table for bookings
    "bookings",                    # root booking record
]


def get_count(cursor, table):
    try:
        cursor.execute(f"SELECT COUNT(*) FROM {table};")
        return cursor.fetchone()[0]
    except Exception:
        return "N/A"


def clear_data():
    print("=" * 60)
    print("  RESORT OPERATIONAL DATA CLEANUP")
    print("=" * 60)
    print(f"\n  DB Host : {db_params['host']}")
    print(f"  DB Name : {db_params['dbname']}")
    print(f"  DB User : {db_params['user']}")

    try:
        conn = psycopg2.connect(**db_params)
        conn.autocommit = False
        cur = conn.cursor()
    except Exception as e:
        print(f"\n❌  Cannot connect to database: {e}")
        sys.exit(1)

    try:
        # ── Before counts ──────────────────────────────────────
        print("\n📊  Current record counts BEFORE cleanup:")
        before = {}
        for table in TABLES_TO_CLEAR:
            cnt = get_count(cur, table)
            before[table] = cnt
            print(f"    {table:<35} {cnt:>6}")

        total = sum(v for v in before.values() if isinstance(v, int))

        if total == 0:
            print("\n✅  All tables are already empty. Nothing to delete.")
            return

        # ── Confirmation ───────────────────────────────────────
        print(f"\n⚠️   This will permanently delete {total} record(s).")
        print("    Rooms, Packages, Services, Food Items, Users &")
        print("    Employees will NOT be touched.\n")
        confirm = input("    Type  YES  to proceed: ").strip()
        if confirm != "YES":
            print("\n❌  Aborted. No data was deleted.")
            return

        print("\n🗑️   Clearing tables...\n")

        # ── Truncate in order ──────────────────────────────────
        for table in TABLES_TO_CLEAR:
            try:
                cur.execute(
                    f"TRUNCATE TABLE {table} RESTART IDENTITY CASCADE;"
                )
                print(f"    ✔ Cleared: {table}")
            except psycopg2.errors.UndefinedTable:
                conn.rollback()   # need to rollback after error in psycopg2
                print(f"    ⚠  Skipped (table not found): {table}")
                # re-open transaction
                cur = conn.cursor()
            except Exception as e:
                conn.rollback()
                print(f"    ✘ Error on {table}: {e}")
                cur = conn.cursor()

        conn.commit()

        # ── After counts ───────────────────────────────────────
        print("\n📊  Record counts AFTER cleanup:")
        for table in TABLES_TO_CLEAR:
            cnt = get_count(cur, table)
            print(f"    {table:<35} {cnt:>6}")

        print("\n✅  Cleanup completed successfully!")
        print("    Preserved: Rooms, Packages, Services, Food Items,")
        print("    Users, Employees, CMS content.\n")

    except Exception as e:
        conn.rollback()
        print(f"\n❌  FATAL ERROR: {e}")
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    clear_data()
