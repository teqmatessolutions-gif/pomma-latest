import os
import sys
import uvicorn

# Manually load .env
print("Loading .env file...")
try:
    with open(".env", "r", encoding="utf-8-sig") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, value = line.split("=", 1)
                # Only set if not already set (or overwrite? usually .env overwrites or provides defaults. Let's overwrite)
                os.environ[key] = value
                if key == "DATABASE_URL":
                     print("DATABASE_URL loaded.")
except Exception as e:
    print(f"Warning: Could not load .env file: {e}")

if __name__ == "__main__":
    # Ensure DATABASE_URL is set
    if "DATABASE_URL" not in os.environ:
         print("Error: DATABASE_URL not set in environment or .env file.")
         sys.exit(1)
         
    print("Starting Uvicorn server on port 8010...")
    # Run uvicorn programmatically
    try:
        uvicorn.run("app.main:app", host="0.0.0.0", port=8010, reload=True)
    except Exception as e:
        print(f"Server crashed: {e}")
