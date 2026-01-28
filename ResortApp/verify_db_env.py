import os
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

# 1. Try to load .env manually
env_path = Path(__file__).parent / ".env"
print(f"Checking for .env at: {env_path.absolute()}")
if env_path.exists():
    print(f".env file FOUND. Size: {env_path.stat().st_size} bytes")
    load_dotenv(dotenv_path=env_path)
else:
    print(".env file NOT FOUND at explicit path.")

# 2. Check environment variable
db_url = os.getenv("DATABASE_URL")
print(f"DATABASE_URL env var: {db_url}")

if not db_url:
    print("WARNING: DATABASE_URL not set after load_dotenv.")
    # Fallback to match database.py logic
    db_url = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
    print(f"Using fallback: {db_url}")

# 3. Try connecting
try:
    print("Attempting to connect to database...")
    engine = create_engine(db_url)
    with engine.connect() as conn:
        result = conn.execute(text("SELECT 1"))
        print(f"Connection SUCCESS! Result: {result.scalar()}")
except Exception as e:
    print(f"Connection FAILED: {e}")
