import paramiko

def check_status():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        client.connect(host, username=user, password=password)
        print("Connected!")
        
        cmds = [
            "ls -l /opt/pomma/ResortApp/dist/app | head -n 5",
            "ls -l /opt/pomma/dasboard/build/index.html",
            "sudo journalctl -u pomma -n 50 --no-pager"
            "free -m"
        ]
        
        for cmd in cmds:
            print(f"\n--- {cmd} ---")
            stdin, stdout, stderr = client.exec_command(cmd)
            print(stdout.read().decode())
            print(stderr.read().decode())
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    check_status()
