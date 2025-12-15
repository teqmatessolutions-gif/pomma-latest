import urllib.request
import json
import ssl

BASE_URL = "http://localhost:8010/api"

def login(email, password):
    url = f"{BASE_URL}/auth/login"
    data = {"username": email, "password": password}  # FastAPI OAuth2PasswordRequestForm expects 'username'
    # Actually, verify_report_endpoints.py used JSON payload. Let's check auth.py.
    # auth.py expects OAuth2PasswordRequestForm unless overridden? 
    # Ah, viewed file `auth.py`: 
    # @router.post("/login", response_model=Token)
    # def login_for_access_token(user_data: LoginSchema, ...):
    # LoginSchema has email and password.
    
    data = {"email": email, "password": password}
    
    req = urllib.request.Request(url, data=json.dumps(data).encode('utf-8'), headers={'Content-Type': 'application/json'})
    
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    
    try:
        with urllib.request.urlopen(req, context=ctx) as response:
            if response.status == 200:
                return json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"Login failed: {e.code} {e.reason}")
        print(e.read().decode())
    return None

def verify_attendance_endpoint(token, employee_id):
    url = f"{BASE_URL}/attendance/work-logs/{employee_id}"
    req = urllib.request.Request(url, headers={'Authorization': f'Bearer {token}'})
    
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    
    try:
        with urllib.request.urlopen(req, context=ctx) as response:
            if response.status == 200:
                data = json.loads(response.read().decode())
                print(f"Fetched {len(data)} logs.")
                for log in data:
                    print(f"ID: {log.get('id')}, Date: {log.get('date')}, Duration Hours: {log.get('duration_hours')}")
            else:
                print(f"Failed to fetch logs: {response.status}")
    except urllib.error.HTTPError as e:
        print(f"Error fetching logs: {e.code} {e.reason}")
        print(e.read().decode())

if __name__ == "__main__":
    # 1. Login
    token_data = login("admin@resort.com", "admin123")
    if token_data:
        access_token = token_data['access_token']
        print("Login successful.")
        
        # 2. Need to find employee ID for 'basil'. 
        # I'll hardcode the ID if I can find it from previous output, 
        # but the previous output was truncated.
        # I'll just check specific employee ID 35 from previous task or try to list employees if needed.
        # Let's try ID from previous context or just guess it. 
        # Actually my debug script printed "Found Employee: basil (ID: 35)"... wait, did it?
        # The output was "Calculated Duration: 2.93..."
        # I'll check my previous step's output again. 
        # Wait, the previous output was "Calculated Duration: 2.93...".
        # I'll assume ID 35 is correct as per the truncated block in Step 907? No that was a different task.
        # I'll implement a look up.
        
        # Lookup employee id
        url = f"{BASE_URL}/employees"
        req = urllib.request.Request(url, headers={'Authorization': f'Bearer {access_token}'})
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        
        employee_id = None
        try:
            with urllib.request.urlopen(req, context=ctx) as response:
                employees = json.loads(response.read().decode())
                for emp in employees:
                    if 'basil' in emp['name'].lower():
                        employee_id = emp['id']
                        print(f"Found Basil with ID: {employee_id}")
                        break
        except Exception as e:
            print(e)

        if employee_id:
            verify_attendance_endpoint(access_token, employee_id)
        else:
            print("Could not find employee 'basil'")
