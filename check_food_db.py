from sqlalchemy.orm import Session
import sys
import os
sys.path.append(os.path.join(os.getcwd(), "ResortApp"))
from app.database import SessionLocal
from app.models.food_item import FoodItem, FoodItemImage

def check_food_images():
    db: Session = SessionLocal()
    try:
        images = db.query(FoodItemImage).all()
        for img in images:
            if "5fb87d276ae049659a312074a7ea475a" in str(img.image_url):
                print(f"MATCH: {img.image_url}")
    finally:
        db.close()

if __name__ == "__main__":
    check_food_images()
