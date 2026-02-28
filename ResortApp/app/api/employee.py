# app/api/employee.py

from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException, status
from typing import Annotated, Any
from sqlalchemy.orm import Session, joinedload
from app.database import SessionLocal
from app.schemas.employee import Employee, LeaveCreate, LeaveOut, EmployeeStatusOverview, EmployeePaginationOut
from app.schemas.user import UserCreate
# ✅ Corrected imports to point to the crud modules
from app.curd import employee as crud_employee
from app.curd import user as crud_user
from app.models.employee import Employee as EmployeeModel, Leave as LeaveModel, WorkingLog as WorkingLogModel
from app.models.user import User
from app.utils.auth import get_current_user
import os
import shutil
from datetime import date 

router = APIRouter(prefix="/employees", tags=["Employees"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Create upload directory if it doesn't exist
UPLOAD_DIR = "uploads/employees"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure directory exists at startup

@router.post("", response_model=Employee)
def add_employee(
    db: Annotated[Any, Depends(get_db)] = None,
    name: Annotated[Any, Form()] = None,
    role: Annotated[Any, Form()] = None,
    salary: Annotated[Any, Form()] = None,
    join_date: Annotated[Any, Form()] = None,
    email: Annotated[Any, Form()] = None,
    phone: Annotated[Any, Form()] = None,
    password: Annotated[Any, Form()] = None,
    image: Annotated[Any, File()] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None,
):
    image_url = None
    if image and image.filename:
        upload_folder = "uploads"
        os.makedirs(upload_folder, exist_ok=True)
        file_path = os.path.join(upload_folder, image.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        image_url = file_path.replace("\\", "/")

    existing_user = crud_user.get_user_by_email(db, email=email)
    if existing_user:
        # If the existing user already has an employee record, block the creation
        if existing_user.employee:
            raise HTTPException(status_code=400, detail="Email already registered as an employee")
        # Otherwise it's a guest account auto-created from a booking — we'll reuse it below

    role = role.strip() if role else role  # Remove trailing/leading whitespace from role name
    role_obj = crud_employee.get_role_by_name(db, role_name=role)
    if not role_obj:
        raise HTTPException(status_code=404, detail=f"Role '{role}' not found")
        
    from app.utils.auth import get_password_hash
    if existing_user:
        # Reuse the existing guest account — upgrade it to an employee account
        existing_user.name = name
        existing_user.role_id = role_obj.id
        existing_user.is_active = True
        if phone:
            existing_user.phone = phone
        if password:
            existing_user.hashed_password = get_password_hash(password)
        db.commit()
        db.refresh(existing_user)
        new_user = existing_user
    else:
        user_data = UserCreate(
            email=email,
            password=password,
            name=name,
            phone=phone,
            role_id=role_obj.id,
        )
        new_user = crud_user.create_user(db=db, user=user_data)

    try:
        parsed_join_date = date.fromisoformat(join_date)
    except ValueError:
        raise HTTPException(
            status_code=422,
            detail="Invalid date format. Use YYYY-MM-DD."
        )

    new_employee = crud_employee.create_employee_with_image(
        db,
        name=name,
        role=role,
        salary=float(salary) if salary else 0.0,  # Convert string to float
        join_date=parsed_join_date,
        image_url=image_url,
        user_id=new_user.id,
    )
    print(f"✅ Employee created successfully: ID={new_employee.id}, Name={new_employee.name}")
    return new_employee

def _list_employees_impl(db: Session, current_user: User, skip: int = 0, limit: int = 20):
    """Helper function for list_employees"""
    return crud_employee.get_employees(db, skip=skip, limit=limit)

@router.get("", response_model=None)
def list_employees(
    db: Annotated[Any, Depends(get_db)], 
    current_user: Annotated[Any, Depends(get_current_user)], 
    skip: int = 0, 
    limit: int = 20
):
    data = _list_employees_impl(db, current_user, skip, limit)
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }

@router.get("/", response_model=None)  # Handle trailing slash
def list_employees_slash(
    db: Annotated[Any, Depends(get_db)], 
    current_user: Annotated[Any, Depends(get_current_user)], 
    skip: int = 0, 
    limit: int = 20
):
    data = _list_employees_impl(db, current_user, skip, limit)
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }
    
@router.get("/status-overview", response_model=EmployeeStatusOverview)
def get_employee_status_overview(
    db: Annotated[Any, Depends(get_db)] = None, 
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    today = date.today()
    
    # Fetch all employees with their user relationship to check is_active
    all_employees_with_user = db.query(EmployeeModel).options(joinedload(EmployeeModel.user)).all()

    # Query for employees currently on approved leave
    on_leave_query = db.query(EmployeeModel.id, LeaveModel.leave_type).join(LeaveModel).filter(
        LeaveModel.status == 'approved',
        LeaveModel.from_date <= today,
        LeaveModel.to_date >= today
    )
    
    on_leave_data = on_leave_query.all()
    on_leave_ids = {emp_id for emp_id, _ in on_leave_data}

    # Find employees who are currently clocked in (have an open working log)
    clocked_in_ids = {
        log.employee_id for log in db.query(WorkingLogModel)
        .filter(WorkingLogModel.check_out_time == None)
        .all()
    }

    # Categorize employees based on the new logic
    active_employees = [emp for emp in all_employees_with_user if emp.id in clocked_in_ids and emp.id not in on_leave_ids]
    inactive_employees = [emp for emp in all_employees_with_user if not (emp.user and emp.user.is_active)]
    
    on_paid_leave = [emp for emp in all_employees_with_user if emp.id in {emp_id for emp_id, l_type in on_leave_data if l_type == 'Paid'}]
    on_sick_leave = [emp for emp in all_employees_with_user if emp.id in {emp_id for emp_id, l_type in on_leave_data if l_type == 'Sick'}]
    on_unpaid_leave = [emp for emp in all_employees_with_user if emp.id in {emp_id for emp_id, l_type in on_leave_data if l_type == 'Unpaid'}]

    return EmployeeStatusOverview(
        active_employees=active_employees, inactive_employees=inactive_employees,
        on_paid_leave=on_paid_leave, on_sick_leave=on_sick_leave, on_unpaid_leave=on_unpaid_leave
    )

@router.put("/{employee_id}")
def update_employee(
    employee_id: int,
    db: Annotated[Any, Depends(get_db)] = None,
    name: Annotated[Any, Form()] = None,
    role: Annotated[Any, Form()] = None,
    salary: Annotated[Any, Form()] = None,
    join_date: Annotated[Any, Form()] = None,
    email: Annotated[Any, Form()] = None,
    phone: Annotated[Any, Form()] = None,
    password: Annotated[Any, Form()] = None,
    is_active: Annotated[Any, Form()] = None,
    image: Annotated[Any, File()] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None,
):
    """Update employee details. Admin can change password and is_active status."""
    if current_user.role.name.lower() != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only admin can update employees")
    
    employee = db.query(EmployeeModel).options(joinedload(EmployeeModel.user)).filter(EmployeeModel.id == employee_id).first()
    if not employee:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Employee not found")
    
    if not employee.user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Employee user account not found")
    
    # Update employee fields
    if name is not None:
        employee.name = name
        employee.user.name = name
    if role is not None:
        role = role.strip()  # Remove trailing/leading whitespace
        role_obj = crud_employee.get_role_by_name(db, role_name=role)
        if not role_obj:
            raise HTTPException(status_code=404, detail=f"Role '{role}' not found")
        employee.role = role
        employee.user.role_id = role_obj.id
    if salary is not None:
        employee.salary = salary
    if join_date is not None:
        try:
            parsed_join_date = date.fromisoformat(join_date)
            employee.join_date = parsed_join_date
        except ValueError:
            raise HTTPException(status_code=422, detail="Invalid date format. Use YYYY-MM-DD.")
    if email is not None:
        # Check if email is already taken by another user
        existing_user = crud_user.get_user_by_email(db, email=email)
        if existing_user and existing_user.id != employee.user_id:
            raise HTTPException(status_code=400, detail="Email already registered")
        employee.user.email = email
    if phone is not None:
        employee.user.phone = phone
    if password is not None and password.strip():
        # Update password
        from app.utils.auth import get_password_hash
        employee.user.hashed_password = get_password_hash(password)
    if is_active is not None:
        # Handle boolean conversion for Form data (can come as string "true"/"false" or boolean)
        if isinstance(is_active, str):
            is_active = is_active.lower() in ('true', '1', 'yes')
        employee.user.is_active = bool(is_active)
    
    # Handle image update
    if image and image.filename:
        upload_folder = "uploads"
        os.makedirs(upload_folder, exist_ok=True)
        file_path = os.path.join(upload_folder, image.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        employee.image_url = file_path.replace("\\", "/")
    
    db.commit()
    db.refresh(employee)
    return employee

@router.delete("/{employee_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_employee(
    employee_id: int, 
    db: Annotated[Any, Depends(get_db)] = None, 
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    if current_user.role.name.lower() != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only admin can delete employees")
    
    deleted_employee = crud_employee.delete_employee(db, employee_id)
    if not deleted_employee:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Employee not found")

@router.post("/leave", response_model=LeaveOut)
def apply_leave(
    leave: Annotated[Any, Depends()] = None, # leave object is LeaveCreate schema
    db: Annotated[Any, Depends(get_db)] = None, 
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    # If leave is passed as a JSON body, we should keep its type hint but Cython might fail.
    # However, standard JSON body is usually fine. It's Form/File/Depends that fail.
    # But for safety, I applied Depends() or similar? 
    # Actually, LeaveCreate is a Pydantic model. Usually these are fine.
    # But let's use the most robust pattern.
    return crud_employee.create_leave(db, leave)

@router.get("/leave/{employee_id}", response_model=list[LeaveOut])
def view_leaves(
    employee_id: int, 
    db: Annotated[Any, Depends(get_db)] = None, 
    current_user: Annotated[Any, Depends(get_current_user)] = None, 
    skip: int = 0, 
    limit: int = 100
):
    return crud_employee.get_employee_leaves(db, employee_id, skip=skip, limit=limit)

@router.get("/leave") # List all leaves for admin
@router.get("/leave/")
def list_all_leaves(
    db: Annotated[Any, Depends(get_db)] = None, 
    current_user: Annotated[Any, Depends(get_current_user)] = None, 
    skip: int = 0, 
    limit: int = 100
):
     return crud_employee.get_all_leaves(db, skip=skip, limit=limit)

@router.put("/leave/{leave_id}/status/{status}", response_model=LeaveOut)
def update_leave_status(
    leave_id: int, 
    status: str, 
    db: Annotated[Any, Depends(get_db)] = None, 
    current_user: Annotated[Any, Depends(get_current_user)] = None
):
    return crud_employee.update_leave_status(db, leave_id, status)
