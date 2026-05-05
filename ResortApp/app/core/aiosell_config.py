import os
from dotenv import load_dotenv
from pathlib import Path

# Load .env from ResortApp/.env
env_path = Path(__file__).parent.parent.parent / ".env"
load_dotenv(dotenv_path=env_path)

AIOSELL_USERNAME = os.getenv("AIOSELL_USERNAME", "aiosell")
AIOSELL_PASSWORD = os.getenv("AIOSELL_PASSWORD", "AIOsell@123")
AIOSELL_HOTEL_CODE = os.getenv("AIOSELL_HOTEL_CODE", "SANDBOX-PMS")
AIOSELL_BASE_URL = os.getenv("AIOSELL_BASE_URL", "https://live.aiosell.com/api/v2/cm/update/sample-pms")

# Rate Push Endpoint: {BASE_URL}/rates
# Inventory Push Endpoint: {BASE_URL}/inventory
# Restrictions Push Endpoint: {BASE_URL}/restrictions
