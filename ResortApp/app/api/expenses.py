from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import Optional, Annotated, Any
from app.curd import expenses as expense_crud
from app.utils.auth import get_db, get_current_user
from app.schemas.expenses import ExpenseOut, ExpensePaginationOut
from app.models.user import User
from app.models.employee import Employee
import os
import shutil
from fastapi.responses import FileResponse
import uuid

router = APIRouter(prefix="/expenses", tags=["Expenses"])

UPLOAD_DIR = "uploads/expenses"


@router.post("", response_model=ExpenseOut)
async def create_expense(
    category: Annotated[Any, Form()] = None,
    amount: Annotated[Any, Form()] = None,
    date: Annotated[Any, Form()] = None,
    description: Annotated[Any, Form()] = None,
    employee_id: Annotated[Any, Form()] = None,
    image: Annotated[Any, File()] = None,
    current_user: Annotated[Any, Depends(get_current_user)] = None,
    db: Annotated[Any, Depends(get_db)] = None,
):
    image_path = None
    if image:
        # Safe filename using UUID
        filename = f"{employee_id}_{uuid.uuid4().hex}_{image.filename}"
        file_location = os.path.join(UPLOAD_DIR, filename)
        with open(file_location, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        
        # Path to be used by frontend (relative to /uploads/)
        image_path = f"uploads/expenses/{filename}"

    # Store expense in DB using ExpenseCreate schema
    from app.schemas.expenses import ExpenseCreate
    from datetime import datetime
    
    expense_data = ExpenseCreate(
        category=category,
        amount=amount,
        date=datetime.strptime(date, "%Y-%m-%d").date() if isinstance(date, str) else date,
        description=description,
        employee_id=employee_id,
    )

    created = expense_crud.create_expense(db, data=expense_data, image_path=image_path)

    # Add employee name in the response
    employee = db.query(Employee).filter(Employee.id == employee_id).first()
    return {
        **created.__dict__,
        "employee_name": employee.name if employee else "N/A"
    }

@router.get("", response_model=None)
def get_expenses(
    db: Annotated[Any, Depends(get_db)] = None, 
    skip: int = 0, 
    limit: int = 20,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    fromDate: Optional[str] = None,
    toDate: Optional[str] = None
):
    from app.models.expense import Expense
    from datetime import datetime
    
    query = db.query(Expense)
    
    # Date filtering
    final_start = from_date or fromDate
    final_end = to_date or toDate
    
    try:
        if final_start:
            if len(final_start) == 10 and "-" in final_start:
                dt_start = datetime.strptime(final_start, "%Y-%m-%d")
                dt_start = dt_start.replace(hour=0, minute=0, second=0, microsecond=0)
                query = query.filter(Expense.date >= dt_start.date())
            
        if final_end:
            if len(final_end) == 10 and "-" in final_end:
                dt_end = datetime.strptime(final_end, "%Y-%m-%d")
                query = query.filter(Expense.date <= dt_end.date())
                
    except Exception as e:
        print(f"ERROR parsing dates in expenses: {e}")
    
    # Calculate Total
    total = query.count()

    expenses = query.order_by(Expense.id.desc()).offset(skip).limit(limit).all()
    
    result = []
    for exp in expenses:
        emp = db.query(Employee).filter(Employee.id == exp.employee_id).first()
        result.append({
            **exp.__dict__,
            "employee_name": emp.name if emp else "N/A"
        })
    
    # Calculate page number
    page = (skip // limit) + 1 if limit > 0 else 1

    return {
        "items": result,
        "total": total,
        "page": page,
        "limit": limit
    }

@router.get("/image/{filename}")
def get_expense_image(filename: str):
    filepath = os.path.join(UPLOAD_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Image not found")
    return FileResponse(filepath)

@router.delete("/{expense_id}")
def delete_expense(expense_id: int, current_user: Annotated[Any, Depends(get_current_user)] = None, db: Annotated[Any, Depends(get_db)] = None):
    expense = expense_crud.get_expense_by_id(db, expense_id)
    if not expense:
        raise HTTPException(status_code=404, detail=f"Expense with ID {expense_id} not found")
    
    if expense.image:
        try:
            image_filename = expense.image.split("/")[-1] if "/" in expense.image else expense.image
            image_path = os.path.join(UPLOAD_DIR, image_filename)
            if os.path.exists(image_path):
                os.remove(image_path)
        except Exception as e:
            print(f"Warning: Failed to delete image file: {str(e)}")
    
    expense_crud.delete_expense(db, expense_id)
    return {"message": f"Expense {expense_id} deleted successfully"}