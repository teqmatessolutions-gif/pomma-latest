import sys
sys.path.insert(0, 'D:\\resort_oc_10\\Resortwithlandingpage\\pomma-latest\\ResortApp')

from sqlalchemy import create_engine, text

DATABASE_URL = "postgresql://postgres:qwerty123@localhost:5432/pommadb"
engine = create_engine(DATABASE_URL)

with engine.connect() as conn:
    # Insert basic resort info
    conn.execute(text("""
        INSERT INTO resort_info (
            name, 
            tagline, 
            about, 
            email, 
            phone, 
            address, 
            city, 
            state, 
            country, 
            zip_code,
            check_in_time,
            check_out_time,
            cancellation_policy
        ) VALUES (
            'Pomma Holidays',
            'Your Perfect Getaway Destination',
            'Welcome to Pomma Holidays, a premium resort offering world-class amenities and unforgettable experiences.',
            'info@pommaholidays.com',
            '+91-1234567890',
            'Pomma Resort, Beach Road',
            'Coastal City',
            'Kerala',
            'India',
            '000000',
            '14:00',
            '11:00',
            'Cancellations must be made 48 hours in advance for a full refund.'
        )
        ON CONFLICT DO NOTHING
    """))
    conn.commit()
    
    print("Resort info inserted successfully!")
    
    # Verify
    result = conn.execute(text("SELECT name, email, phone FROM resort_info LIMIT 1"))
    resort = result.fetchone()
    if resort:
        print(f"\nResort Name: {resort[0]}")
        print(f"Email: {resort[1]}")
        print(f"Phone: {resort[2]}")
    else:
        print("No resort info found!")

