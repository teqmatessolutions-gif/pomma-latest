from app.database import SessionLocal
from app.models.frontend import ResortInfo
import json

db = SessionLocal()
try:
    info = db.query(ResortInfo).all()
    output = []
    for item in info:
        output.append({
            "id": item.id,
            "name": item.name,
            "address": item.address,
            "email": item.email,
            "support_email": item.support_email,
            "property_location": item.property_location,
            "gst_no": item.gst_no
        })
    
    with open("resort_info_output.json", "w") as f:
        json.dump(output, f, indent=2)
    
    print(f"Data written to resort_info_output.json")
    print(f"Count: {len(info)}")
except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
