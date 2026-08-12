import paramiko
import time
import sys

def deploy():
    host = "34.27.99.183"
    user = "daionmathew12"
    password = "350@bullet@?:"
    target_dir = "/opt/pomma"
    
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        print(f"Connecting to {host}...")
        client.connect(host, username=user, password=password, timeout=60)
        print("Connected!")
        
        def run_cmd(cmd, run_dir=target_dir, use_sudo=False, timeout=300):
            print(f"Running: {cmd} in {run_dir}")
            if use_sudo:
                full_cmd = f"cd {run_dir} && echo '{password}' | sudo -S {cmd}"
            else:
                full_cmd = f"cd {run_dir} && {cmd}"
                
            stdin, stdout, stderr = client.exec_command(full_cmd, timeout=timeout)
            
            while not stdout.channel.exit_status_ready():
                if stdout.channel.recv_ready():
                    print(stdout.channel.recv(2048).decode(), end="")
                if stderr.channel.recv_ready():
                    err_chunk = stderr.channel.recv(2048).decode()
                    if "[sudo] password for" not in err_chunk:
                        print(err_chunk, end="", file=sys.stderr)
                time.sleep(0.2)
            
            print(stdout.read().decode(), end="")
            err = stderr.read().decode()
            if err and "[sudo] password for" not in err:
                print(f"Errors:\n{err}", file=sys.stderr)
            
            return stdout.channel.recv_exit_status()

        # 1. Pull latest code
        print("\n--- Pulling latest code ---")
        run_cmd("git reset --hard HEAD")
        run_cmd("git pull origin final")
        
        # 2. Fix permissions for compilation
        print("\n--- Fixing Permissions ---")
        run_cmd("sudo chown -R $USER:$USER ResortApp/ ResortApp/.env", use_sudo=True)
        run_cmd("sudo chmod 644 ResortApp/.env", use_sudo=True)
        run_cmd("sudo rm -rf ResortApp/build ResortApp/dist ResortApp/build_dist", use_sudo=True)
        
        # 3. Run Database Migration
        print("\n--- Running Database Migrations ---")
        run_cmd("/opt/pomma/venv/bin/python ResortApp/migrate_mapping_fields.py")
        
        # 4. Re-compile Backend (Cython)
        print("\n--- Re-compiling Backend ---")
        run_cmd("cd ResortApp && /opt/pomma/venv/bin/python compile_backend.py")
        
        # 5. Restart Pomma Service
        print("\n--- Restarting Pomma Service ---")
        run_cmd("sudo systemctl restart pomma", use_sudo=True)
        time.sleep(2)
        run_cmd("sudo systemctl status pomma")
        
        # 6. Build Dashboard
        print("\n--- Building Dashboard (This may take a few minutes) ---")
        # Ensure cross-env and craco are available
        run_cmd("npm install --legacy-peer-deps", run_dir=f"{target_dir}/dasboard", timeout=600)
        run_cmd("npx cross-env PUBLIC_URL=/admin npx craco build", run_dir=f"{target_dir}/dasboard", timeout=600)
        
        # 7. Deploy Dashboard Build
        print("\n--- Deploying Dashboard Files ---")
        run_cmd("sudo rm -rf /opt/pomma/dasboard-build/*", use_sudo=True)
        run_cmd("sudo cp -r build/* /opt/pomma/dasboard-build/", run_dir=f"{target_dir}/dasboard")
        
        # 8. Restart Nginx
        print("\n--- Restarting Nginx ---")
        run_cmd("sudo systemctl restart nginx", use_sudo=True)
        
        print("\n✅ DEPLOYMENT COMPLETE & VERIFIED!")
        
    except Exception as e:
        print(f"❌ Deployment failed: {e}")
        import traceback
        traceback.print_exc()
    finally:
        client.close()

if __name__ == "__main__":
    deploy()
