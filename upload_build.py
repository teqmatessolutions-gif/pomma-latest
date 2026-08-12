import paramiko
import os

def upload_and_extract():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        print("Connecting to server...")
        client.connect(host, username=user, password=password)
        
        print("Uploading build.tar.gz...")
        sftp = client.open_sftp()
        sftp.put("build.tar.gz", "/home/daionmathew12/build.tar.gz")
        sftp.close()
        
        print("Extracting and deploying on server...")
        commands = [
            f"echo '{password}' | sudo -S rm -rf /opt/pomma/dasboard-build/*",
            f"echo '{password}' | sudo -S tar -xzf /home/daionmathew12/build.tar.gz -C /opt/pomma/dasboard-build/ --strip-components=1",
            f"echo '{password}' | sudo -S chown -R www-data:www-data /opt/pomma/dasboard-build",
            f"echo '{password}' | sudo -S systemctl restart nginx",
            "rm /home/daionmathew12/build.tar.gz"
        ]
        
        for cmd in commands:
            stdin, stdout, stderr = client.exec_command(cmd)
            stdout.channel.recv_exit_status() # wait to finish
            
        print("Deployment successful!")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    upload_and_extract()
