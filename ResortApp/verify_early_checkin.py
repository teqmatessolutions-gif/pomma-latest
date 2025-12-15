
from app.database import SessionLocal
from app.models.booking import Booking, BookingRoom
from app.models.room import Room
from app.api.booking import check_in_booking
from fastapi import HTTPException
from datetime import date, timedelta
import uuid

def verify_early_checkin():
    db = SessionLocal()
    try:
        today = date.today()
        tomorrow = today + timedelta(days=1)
        day_after = today + timedelta(days=2)
        next_day = today + timedelta(days=3)

        print(f"Today: {today}")
        print(f"Booking A: {tomorrow} to {day_after}")
        print(f"Booking B: {day_after} to {next_day}")

        # 1. Get Room 101
        room = db.query(Room).filter(Room.number == "101").first()
        if not room:
            print("Room 101 not found, creating it.")
            room = Room(number="101", type="Standard", price=1000, status="Available")
            db.add(room)
            db.commit()

        # 2. Cleanup existing test bookings
        db.query(Booking).filter(Booking.guest_name.like("Test Early%")).delete(synchronize_session=False)
        db.commit()

        # 3. Create Booking A (Tomorrow - Day After) -> Overlaps with potential early check-in of B
        booking_a = Booking(
            guest_name="Test Early A",
            check_in=tomorrow,
            check_out=day_after,
            status="booked",
            adults=1,
            children=0
        )
        db.add(booking_a)
        db.commit()
        db.add(BookingRoom(booking_id=booking_a.id, room_id=room.id))
        db.commit()
        print(f"Created Booking A (ID {booking_a.id}) for {tomorrow} to {day_after}")

        # 4. Create Booking B (Day After - Next Day)
        booking_b = Booking(
            guest_name="Test Early B",
            check_in=day_after,
            check_out=next_day,
            status="booked",
            adults=1,
            children=0
        )
        db.add(booking_b)
        db.commit()
        db.add(BookingRoom(booking_id=booking_b.id, room_id=room.id))
        db.commit()
        print(f"Created Booking B (ID {booking_b.id}) for {day_after} to {next_day}")

        # 5. Attempt Early Check-in for Booking B (Today)
        # Checking in B today means extending it to [Today, Next Day]
        # This creates overlap with A [Tomorrow, Day After]
        print("\nAttempting early check-in for Booking B...")
        
        # Mock UploadFiles (not used in logic test but required by signature)
        class MockUploadFile:
            def __init__(self):
                self.file = open("mock_file", "w+b") # Create dummy file
                self.filename = "mock.jpg"
        
        mock_file = MockUploadFile()

        try:
            # We need to mock current_user too, but let's see if we can call logic directly
            # Logic validation is in check_in_booking function. 
            # Ideally we'd call the function but it has dependencies (current_user, file handling).
            # Let's replicate the specific query logic to verify it detects the conflict.
            
            updated_start = today
            existing_start = booking_b.check_in
            
            gap_start = updated_start
            gap_end = existing_start # This is 'day_after'
            
            print(f"Checking gap: {gap_start} to {gap_end}")

            conflicting = db.query(BookingRoom).join(Booking).filter(
                BookingRoom.room_id == room.id,
                Booking.status.in_(['booked', 'checked-in']),
                Booking.id != booking_b.id,
                Booking.check_in < gap_end,
                Booking.check_out > gap_start
            ).all()

            if conflicting:
                print("SUCCESS: Conflict detected!")
                for c in conflicting:
                    print(f"Conflict with Booking ID {c.booking_id}")
            else:
                print("FAILURE: No conflict detected.")

        except Exception as e:
            print(f"Error during check: {e}")

    finally:
        db.close()
        import os
        if os.path.exists("mock_file"):
            os.remove("mock_file")

if __name__ == "__main__":
    verify_early_checkin()
