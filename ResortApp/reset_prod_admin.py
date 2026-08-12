import paramiko
import sys

def reset_password():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    new_app_password = "PommaAdmin#123"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        client.connect(host, username=user, password=password)
        
        script = f"""
from app.database import SessionLocal
from app.models.user import User
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
db = SessionLocal()
u = db.query(User).filter(User.email == 'admin@pomma.com').first()
if u:
    u.hashed_password = pwd_context.hash('{new_app_password}')
    db.commit()
    print('Password reset successfully for admin@pomma.com')
else:
    print('Admin user not found')
db.close()
"""
        
        # We can echo this script into python
        full_cmd = f"cd /opt/pomma/ResortApp && /opt/pomma/venv/bin/python -c \"{script.replace('\"', '\\\"').replace('$', '\\$')}\""
        
        stdin, stdout, stderr = client.exec_command(full_cmd)
        out = stdout.read().decode()
        err = stderr.read().decode()
        print(out)
        print(err)
        
        if "successfully" in out.lower() or "successfully" in err.lower():
            print(f"\nYour new login credentials are:\nEmail: admin@pomma.com\nPassword: {new_app_password}")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    reset_password()
