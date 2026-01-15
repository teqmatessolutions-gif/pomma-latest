from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from app.schemas.foodorder import FoodOrderCreate, FoodOrderOut, FoodOrderUpdate
from app.curd import foodorder as crud  # ✅ Correct import
from app.utils.auth import get_db, get_current_user
from app.models.user import User

router = APIRouter(prefix="/food-orders", tags=["Food Orders"])

def _create_order_impl(order: FoodOrderCreate, db: Session, current_user: User):
    """Helper function for create_order"""
    return crud.create_food_order(db, order)

@router.post("", response_model=FoodOrderOut)
def create_order(order: FoodOrderCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return _create_order_impl(order, db, current_user)

@router.post("/", response_model=FoodOrderOut)  # Handle trailing slash
def create_order_slash(order: FoodOrderCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return _create_order_impl(order, db, current_user)

def _get_orders_impl(db: Session, skip: int = 0, limit: int = 20, from_date: Optional[str] = None, to_date: Optional[str] = None, fromDate: Optional[str] = None, toDate: Optional[str] = None):
    """Helper function for get_orders"""
    from app.models.foodorder import FoodOrder
    from datetime import datetime
    
    query = db.query(FoodOrder)
    
    # Date filtering
    final_start = from_date or fromDate
    final_end = to_date or toDate
    
    try:
        if final_start:
            if len(final_start) == 10 and "-" in final_start:
                dt_start = datetime.strptime(final_start, "%Y-%m-%d")
                dt_start = dt_start.replace(hour=0, minute=0, second=0, microsecond=0)
                query = query.filter(FoodOrder.created_at >= dt_start)
            
        if final_end:
            if len(final_end) == 10 and "-" in final_end:
                dt_end = datetime.strptime(final_end, "%Y-%m-%d")
                dt_end = dt_end.replace(hour=23, minute=59, second=59, microsecond=999999)
                query = query.filter(FoodOrder.created_at <= dt_end)
                
    except Exception as e:
        print(f"ERROR parsing dates in food orders: {e}")
    
    return query.order_by(FoodOrder.id.desc()).offset(skip).limit(limit).all()

@router.get("", response_model=List[FoodOrderOut])
def get_orders(db: Session = Depends(get_db), skip: int = 0, limit: int = 20, from_date: Optional[str] = None, to_date: Optional[str] = None, fromDate: Optional[str] = None, toDate: Optional[str] = None):
    return _get_orders_impl(db, skip, limit, from_date, to_date, fromDate, toDate)

@router.get("/", response_model=List[FoodOrderOut])  # Handle trailing slash
def get_orders_slash(db: Session = Depends(get_db), skip: int = 0, limit: int = 20, from_date: Optional[str] = None, to_date: Optional[str] = None, fromDate: Optional[str] = None, toDate: Optional[str] = None):
    return _get_orders_impl(db, skip, limit, from_date, to_date, fromDate, toDate)

@router.delete("/{order_id}")
def delete_order(order_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    deleted = crud.delete_food_order(db, order_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Order not found")
    return {"message": "Deleted successfully"}

@router.patch("/{order_id}/cancel")
def cancel_order(order_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    order = crud.update_food_order_status(db, order_id, status="cancelled")
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return {"message": "Order cancelled"}

@router.put("/{order_id}", response_model=FoodOrderOut)
def update_order(order_id: int, order_update: FoodOrderUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    updated = crud.update_food_order(db, order_id, order_update)
    if not updated:
        raise HTTPException(status_code=404, detail="Order not found")
    return updated
