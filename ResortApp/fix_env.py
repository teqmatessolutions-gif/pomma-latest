import paramiko
import re

def fix_env():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        client.connect(host, username=user, password=password)
        
        # Read the current .env
        stdin, stdout, stderr = client.exec_command("sudo cat /opt/pomma/ResortApp/.env")
        current_env = stdout.read().decode()
        
        # We will append the new values and comment out old ones if needed
        # But wait, it's easier to just append them at the end. In Python's dotenv or most parsers, 
        # the last occurrence of a key wins. To be clean, let's just append them.
        new_env_content = current_env + """
# Added by AI
AIOSELL_ACTIVE=true
AIOSELL_HOTEL_CODE=81479296f2
AIOSELL_PARTNER_ID=teqmates-hospitality
AIOSELL_API_URL=https://live.aiosell.com/api/v2/cm/update
AIOSELL_USERNAME=teqmates-hospitality
AIOSELL_PASSWORD=1zdv6udu
AIOSELL_WEBHOOK_USERNAME=admin@teqmates.com
AIOSELL_WEBHOOK_PASSWORD=teqmates@5412!
"""
        # Save it to a temporary file locally
        with open("temp_env.txt", "w") as f:
            f.write(new_env_content)
        
        # Upload it
        sftp = client.open_sftp()
        sftp.put("temp_env.txt", "/home/daionmathew12/temp_env.txt")
        sftp.close()
        
        # Move it to /opt/pomma/ResortApp/.env
        client.exec_command(f"echo '{password}' | sudo -S mv /home/daionmathew12/temp_env.txt /opt/pomma/ResortApp/.env")
        client.exec_command(f"echo '{password}' | sudo -S chown www-data:www-data /opt/pomma/ResortApp/.env")
        
        # Restart backend
        client.exec_command(f"echo '{password}' | sudo -S systemctl restart pomma")
        print("Updated .env and restarted pomma service.")
        
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    fix_env()
