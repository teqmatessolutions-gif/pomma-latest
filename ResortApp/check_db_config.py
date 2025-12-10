from app.database import engine
import sys

# Mask password for security in logs
url = str(engine.url)
if ":" in url and "@" in url:
    print(f"Current Database: {url.split('@')[1]}") 
else:
    print(f"Current Database: {url}")
