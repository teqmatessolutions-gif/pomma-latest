import paramiko
import sys

def test_connection():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        print(f"Connecting to {host}...")
        client.connect(host, username=user, password=password)
        print("Connected!")
        
        stdin, stdout, stderr = client.exec_command("ls -d /opt/pomma /var/www/resort/Resort_first 2>/dev/null")
        dirs = stdout.read().decode().split()
        print(f"Found directories: {dirs}")
        
        if dirs:
            target_dir = dirs[0]
            print(f"Target directory: {target_dir}")
            
            # Check current branch
            stdin, stdout, stderr = client.exec_command(f"cd {target_dir} && git branch --show-current")
            branch = stdout.read().decode().strip()
            print(f"Current branch on server: {branch}")
        else:
            print("Could not find standard project directories.")
            stdin, stdout, stderr = client.exec_command("find / -maxdepth 3 -name 'ResortApp' 2>/dev/null")
            find_res = stdout.read().decode().split()
            print(f"Search results for ResortApp: {find_res}")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    test_connection()
