from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional, Annotated, Any
from app.schemas.foodorder import FoodOrderCreate, FoodOrderOut, FoodOrderUpdate, FoodOrderPaginationOut
from app.curd import foodorder as crud  # ✅ Correct import
from app.utils.auth import get_db, get_current_user
from app.models.user import User

router = APIRouter(prefix="/food-orders", tags=["Food Orders"])

def _create_order_impl(order: FoodOrderCreate, db: Session, current_user: User):
    """Helper function for create_order"""
    return crud.create_food_order(db, order)

@router.post("", response_model=FoodOrderOut)
def create_order(order: FoodOrderCreate, db: Annotated[Any, Depends(get_db)] = None):
    """Create a new food order (publicly accessible for QR guests)"""
    return crud.create_food_order(db, order)

@router.post("/", response_model=FoodOrderOut)  # Handle trailing slash
def create_order_slash(order: FoodOrderCreate, db: Annotated[Any, Depends(get_db)] = None):
    """Create a new food order (publicly accessible for QR guests)"""
    return crud.create_food_order(db, order)

@router.options("/") 
def options_order_slash():
    """Explicitly handle OPTIONS for preflight"""
    return {}

@router.options("")
def options_order():
    """Explicitly handle OPTIONS for preflight"""
    return {}

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
    
    # Calculate Total Count
    total = query.count()

    # Fetch Items with Pagination
    items = query.order_by(FoodOrder.id.desc()).offset(skip).limit(limit).all()

    # Populate guest names manually for these items (logic copied from crud.get_food_orders)
    # Ideally, we should unify this logic, but for now we apply the same enhancement
    for order in items:
        # Priority 1: Check linked regular booking
        if order.booking:
             order.guest_name = order.booking.guest_name
        # Priority 2: Check linked package booking
        elif order.package_booking:
             order.guest_name = order.package_booking.guest_name
    # Priority 3: Fallback using historical lookup if guest attribute is missing
        elif hasattr(order, 'room_id') and order.room_id:
            # First try current active guest (existing logic)
            guest_name = crud.get_guest_for_room(order.room_id, db)
            
            # If not found (e.g. guest checked out), try historical lookup using order creation time
            if not guest_name and order.created_at:
                 guest_name = crud.get_historical_guest_for_room(db, order.room_id, order.created_at)
            
            if guest_name:
                order.guest_name = guest_name

    return {"items": items, "total": total}

@router.get("", response_model=FoodOrderPaginationOut)
def get_orders(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20, from_date: Optional[str] = None, to_date: Optional[str] = None, fromDate: Optional[str] = None, toDate: Optional[str] = None):
    data = _get_orders_impl(db, skip, limit, from_date, to_date, fromDate, toDate)
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }

@router.get("/", response_model=FoodOrderPaginationOut)  # Handle trailing slash
def get_orders_slash(db: Annotated[Any, Depends(get_db)] = None, skip: int = 0, limit: int = 20, from_date: Optional[str] = None, to_date: Optional[str] = None, fromDate: Optional[str] = None, toDate: Optional[str] = None):
    data = _get_orders_impl(db, skip, limit, from_date, to_date, fromDate, toDate)
    page = (skip // limit) + 1 if limit > 0 else 1
    return {
        "items": data["items"],
        "total": data["total"],
        "page": page,
        "limit": limit
    }

@router.delete("/{order_id}")
def delete_order(order_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    deleted = crud.delete_food_order(db, order_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Order not found")
    return {"message": "Deleted successfully"}

@router.patch("/{order_id}/cancel")
def cancel_order(order_id: int, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    order = crud.update_food_order_status(db, order_id, status="cancelled")
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return {"message": "Order cancelled"}

@router.put("/{order_id}", response_model=FoodOrderOut)
def update_order(order_id: int, order_update: FoodOrderUpdate, db: Annotated[Any, Depends(get_db)] = None, current_user: Annotated[Any, Depends(get_current_user)] = None):
    updated = crud.update_food_order(db, order_id, order_update)
    if not updated:
        raise HTTPException(status_code=404, detail="Order not found")
    return updated
