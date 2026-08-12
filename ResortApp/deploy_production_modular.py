import paramiko
import time
import sys
import argparse

def run_cmd(client, cmd, run_dir="/opt/pomma", use_sudo=False, password=""):
    print(f"\nRunning: {cmd} in {run_dir}")
    if use_sudo:
        full_cmd = f"cd {run_dir} && echo '{password}' | sudo -S {cmd}"
    else:
        full_cmd = f"cd {run_dir} && {cmd}"
        
    stdin, stdout, stderr = client.exec_command(full_cmd)
    
    while not stdout.channel.exit_status_ready():
        if stdout.channel.recv_ready():
            print(stdout.channel.recv(2048).decode(), end="")
        if stderr.channel.recv_ready():
            err_chunk = stderr.channel.recv(2048).decode()
            if "[sudo] password for" not in err_chunk:
                print(err_chunk, end="", file=sys.stderr)
        time.sleep(0.5)
    
    print(stdout.read().decode(), end="")
    err = stderr.read().decode()
    if err and "[sudo] password for" not in err:
        print(f"Errors:\n{err}", file=sys.stderr)
    
    return stdout.channel.recv_exit_status()

def deploy(step=None):
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

        if step == "compile" or step is None:
            print("\n--- Re-compiling Backend ---")
            run_cmd(client, "sudo chown -R $USER:$USER ResortApp/", use_sudo=True, password=password)
            run_cmd(client, "cd ResortApp && /opt/pomma/venv/bin/python compile_backend.py")
        
        if step == "restart" or step is None:
            print("\n--- Fixing Permissions & Restarting ---")
            # Create required directories in dist
            run_cmd(client, "mkdir -p ResortApp/dist/uploads ResortApp/dist/static", use_sudo=False)
            # Give ownership to www-data
            run_cmd(client, "sudo chown -R www-data:www-data ResortApp/dist", use_sudo=True, password=password)
            run_cmd(client, "sudo chmod -R 775 ResortApp/dist", use_sudo=True, password=password)
            # Restart service
            run_cmd(client, "sudo systemctl restart pomma", use_sudo=True, password=password)
            time.sleep(2)
            run_cmd(client, "sudo systemctl status pomma")
        
        if step == "dashboard" or step is None:
            print("\n--- Building Dashboard ---")
            run_cmd(client, "npm install --legacy-peer-deps && npx cross-env PUBLIC_URL=/admin npx craco build", run_dir=f"{target_dir}/dasboard")
            print("\n--- Deploying Dashboard Files ---")
            run_cmd(client, "sudo rm -rf /opt/pomma/dasboard-build/*", use_sudo=True, password=password)
            run_cmd(client, "sudo cp -r build/* /opt/pomma/dasboard-build/", run_dir=f"{target_dir}/dasboard", use_sudo=True, password=password)
            run_cmd(client, "sudo systemctl restart nginx", use_sudo=True, password=password)
        
        print("\n✅ STEP/DEPLOYMENT COMPLETE!")
        
    except Exception as e:
        print(f"❌ Deployment failed: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--step", choices=["compile", "restart", "dashboard"])
    args = parser.parse_args()
    deploy(args.step)
