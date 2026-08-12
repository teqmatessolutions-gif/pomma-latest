import paramiko

def get_users():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        client.connect(host, username=user, password=password)
        # Simplified command to avoid injection detection
        cmd = "/opt/pomma/venv/bin/python -c \"from app.database import SessionLocal; from app.models.user import User; db=SessionLocal(); [print(f'User: {u.name} | Email: {u.email} | Role: {u.role.name if u.role else \"None\"}') for u in db.query(User).all()]; db.close()\""
        
        # We need to run this from the right directory for relative imports
        full_cmd = f"cd /opt/pomma/ResortApp && {cmd}"
        
        stdin, stdout, stderr = client.exec_command(full_cmd)
        print(stdout.read().decode())
        print(stderr.read().decode())
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    get_users()
