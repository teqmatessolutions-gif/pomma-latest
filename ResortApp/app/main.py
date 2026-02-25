from fastapi import FastAPI
from app.database import Base, engine
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from starlette.requests import Request
from starlette.responses import JSONResponse
import os


# API Routers
from app.api import (
    attendance,
    auth,
    booking,
    checkout,
    dashboard,
    employee,
    expenses,
    food_category,
    food_item,
    food_orders,
    frontend,
    health_control,
    packages,
    payment,
    report,
    role,
    room,
    service,
    user,
)

# Create DB tables
Base.metadata.create_all(bind=engine)

ROOT_PATH = os.getenv("ROOT_PATH", "")

app = FastAPI(root_path=ROOT_PATH, redirect_slashes=False)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.exception_handler(TypeError)
async def type_error_debug(request: Request, exc: TypeError):
    import traceback
    print(f"DEBUG: Caught TypeError for {request.method} {request.url}")
    traceback.print_exc()
    return JSONResponse(status_code=500, content={"detail": f"Debug TypeError: {str(exc)}"})

from fastapi.exceptions import RequestValidationError
from fastapi.encoders import jsonable_encoder

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    # Sanitize error details to remove non-serializable objects (like UploadFile)
    errors = exc.errors()
    for error in errors:
        if "input" in error:
            # If input is an object (like UploadFile), convert to string representation
            if not isinstance(error["input"], (str, int, float, bool, type(None))):
                 error["input"] = str(error["input"])
    
    return JSONResponse(
        status_code=422,
        content=jsonable_encoder({"detail": errors, "body": errors}),
    )

# Global License/Health Check Middleware
from starlette.requests import Request
from starlette.responses import JSONResponse
from app.utils.health_monitor import get_system_status

@app.middleware("http")
async def check_system_health(request: Request, call_next):
    # Bypass check for static files and health/activation endpoints to allow unlocking
    path = request.url.path
    if path.startswith("/static") or path.startswith("/uploads") or "/api/health/" in path:
         return await call_next(request)

    # DIRECT LOCK CHECK (Bypassing health_monitor module to guarantee execution)
    import os
    # SYSTEM UPDATE: Using /opt/pomma/lock.dat to bypass systemd PrivateTmp isolation
    lock_path = "/opt/pomma/lock.dat"
    
    # Check if file exists - simplistic and robust
    if os.path.exists(lock_path):
        return JSONResponse(
            status_code=403,
            content={
                "detail": "System Suspended", 
                "code": "LICENSE_LOCKED",
                "message": "This application has been remotely suspended. Please contact the administrator."
            }
        )
    
    return await call_next(request)

@app.on_event("startup")
async def startup_event():
    from app.utils.thumbnail_generator import generate_thumbnails_for_dirs
    import os
    
    # Detect if we are running from the 'dist' folder (production mode)
    # The parent directory of 'dist' is the project root where uploads should live
    current_dir = os.getcwd()
    base_storage_path = "."
    if os.path.basename(current_dir) == "dist":
        base_storage_path = ".."
    
    # Define directories to scan and ensure they exist
    dirs_to_setup = [
        os.path.join(base_storage_path, "static/rooms"),
        os.path.join(base_storage_path, "static/food_categories"),
        os.path.join(base_storage_path, "uploads/rooms"),
        os.path.join(base_storage_path, "uploads/packages"),
        os.path.join(base_storage_path, "uploads/cms"),
        os.path.join(base_storage_path, "uploads/services"),
        os.path.join(base_storage_path, "uploads/food_items"),
        os.path.join(base_storage_path, "uploads/expenses"),
        os.path.join(base_storage_path, "uploads/employees"),
        os.path.join(base_storage_path, "uploads/checkin_proofs")
    ]

    # Ensure all directories exist to prevent upload errors
    for directory in dirs_to_setup:
        try:
            os.makedirs(directory, exist_ok=True)
            # Try to ensure it's writable
            if not os.access(directory, os.W_OK):
                print(f"Warning: Directory {directory} is not writable.")
        except PermissionError:
            print(f"Error: Permission denied creating directory: {directory}")
        except Exception as e:
            print(f"Unexpected error creating directory {directory}: {e}")
    
    # Run in threadpool
    try:
        generate_thumbnails_for_dirs(dirs_to_setup)
    except Exception as e:
        print(f"Startup thumbnail generation failed: {e}")

    # Start Health/License Monitoring
    from app.utils.health_monitor import start_monitoring_loop
    import asyncio
    asyncio.create_task(start_monitoring_loop())

# Static file dirs
# Note: These paths are used by individual routers. 
# They are relative to the project root in dev, or parent of dist in prod.
current_dir = os.getcwd()
base_storage_path = "."
if os.path.basename(current_dir) == "dist":
    base_storage_path = ".."

UPLOAD_DIR = os.path.join(base_storage_path, "uploads/expenses")

# Ensure base directories exist before mounting to avoid RuntimeError
for d in ["uploads", "static"]:
    full_d = os.path.join(base_storage_path, d)
    try:
        os.makedirs(full_d, exist_ok=True)
    except Exception:
        pass

# Mount static files pointing to the persistent storage location
# Remapped to /backend-static to avoid conflict with React's /static folder
app.mount("/uploads", StaticFiles(directory=os.path.join(base_storage_path, "uploads")), name="uploads")
app.mount("/backend-static", StaticFiles(directory=os.path.join(base_storage_path, "static")), name="static")

# Register Routers with /api prefix to match nginx configuration
app.include_router(auth.router, prefix="/api")
app.include_router(user.router, prefix="/api")
app.include_router(role.router, prefix="/api")
app.include_router(employee.router, prefix="/api")
app.include_router(attendance.router, prefix="/api")
app.include_router(room.router, prefix="/api")
app.include_router(packages.router, prefix="/api")
app.include_router(booking.router, prefix="/api")
app.include_router(checkout.router, prefix="/api")
app.include_router(food_category.router, prefix="/api")
app.include_router(food_item.router, prefix="/api")
app.include_router(food_orders.router, prefix="/api")
app.include_router(service.router, prefix="/api")
app.include_router(expenses.router, prefix="/api")
app.include_router(payment.router, prefix="/api")
app.include_router(frontend.router, prefix="/api/frontend")
app.include_router(dashboard.router, prefix="/api")
app.include_router(report.router, prefix="/api")
app.include_router(health_control.router, prefix="/api") # Hidden Health Sync Endpoint
# app.include_router(guest_api.guest_router) # <--- And add this line
# app.include_router(billing_api.router) # <-- Now billing is active