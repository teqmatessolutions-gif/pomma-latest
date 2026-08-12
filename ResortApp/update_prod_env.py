import paramiko

def update_env():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        client.connect(host, username=user, password=password)
        
        # Safely append to the .env file
        cmd = "echo '\n# Aiosell Push Authentication\nAIOSELL_USERNAME=teqmates-hospitality\nAIOSELL_PASSWORD=********' | sudo tee -a /opt/pomma/ResortApp/.env"
        
        stdin, stdout, stderr = client.exec_command(cmd)
        print(stdout.read().decode())
        print(stderr.read().decode())
        
        # Restart the backend service to pick up the new env variables
        client.exec_command("sudo systemctl restart pomma")
        print("Backend service restarted.")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    update_env()
