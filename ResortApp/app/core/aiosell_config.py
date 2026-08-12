import os
from dotenv import load_dotenv
from pathlib import Path

# Load .env from ResortApp/.env
env_path = Path(__file__).parent.parent.parent / ".env"
load_dotenv(dotenv_path=env_path)

# Phase 1: Environment Configuration
# Force enabled for production
AIOSELL_ACTIVE = True
AIOSELL_HOTEL_CODE = os.getenv("AIOSELL_HOTEL_CODE", "81479296f2")
AIOSELL_PARTNER_ID = os.getenv("AIOSELL_PARTNER_ID")

# Global Outbound Credentials
AIOSELL_USERNAME = os.getenv("AIOSELL_USERNAME")
AIOSELL_PASSWORD = os.getenv("AIOSELL_PASSWORD")

# Webhook Inbound Credentials
WEBHOOK_USER = os.getenv("WEBHOOK_USER", "admin@teqmates.com")
WEBHOOK_PASS = os.getenv("WEBHOOK_PASS", "teqmates@5412!")

# Base URL Construction
# Inventory Endpoint: .../v2/cm/update/{PARTNER_ID}
# Rates Endpoint: .../v2/cm/update-rates/{PARTNER_ID}
AIOSELL_BASE_URL = os.getenv("AIOSELL_BASE_URL", "https://live.aiosell.com/api/v2/cm")

def get_inventory_url():
    return f"{AIOSELL_BASE_URL}/update/{AIOSELL_PARTNER_ID}"

def get_rates_url():
    return f"{AIOSELL_BASE_URL}/update-rates/{AIOSELL_PARTNER_ID}"
