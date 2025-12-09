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
            address, 
            facebook,
            instagram,
            twitter,
            linkedin,
            is_active
        ) VALUES (
            'Pomma Holidays Resort',
            '123 Beach Road, Coastal City, Kerala, India 000000',
            'https://facebook.com/pommaholidays',
            'https://instagram.com/pommaholidays',
            'https://twitter.com/pommaholidays',
            'https://linkedin.com/company/pommaholidays',
            true
        )
    """))
    conn.commit()
    
    print("SUCCESS! Resort info inserted")
    
    # Verify
    result = conn.execute(text("SELECT id, name, address FROM resort_info"))
    resort = result.fetchone()
    print(f"\nResort ID: {resort[0]}")
    print(f"Name: {resort[1]}")
    print(f"Address: {resort[2]}")

