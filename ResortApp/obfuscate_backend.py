import os
import subprocess
import shutil

def obfuscate():
    """
    Obfuscates the backend code using PyArmor.
    """
    print("🚀 Starting backend obfuscation...")
    
    # 1. Cleanup old dist
    if os.path.exists('dist'):
        shutil.rmtree('dist')
    
    try:
        # 2. Run PyArmor
        # Trying direct command first, then 'python -m pyarmor' as fallback
        success = False
        commands = [
            ['pyarmor', 'gen', 'app'],
            ['python3', '-m', 'pyarmor.cli', 'gen', 'app']
        ]
        
        for cmd in commands:
            try:
                print(f"Executing: {' '.join(cmd)}")
                subprocess.run(cmd, check=True)
                success = True
                break
            except (subprocess.CalledProcessError, FileNotFoundError):
                continue

        if not success:
            print("❌ Error: PyArmor failed to run or was not found.")
            return

        print("✅ Obfuscation complete. Protected code is in 'dist/app'")
        
        # 3. Copy other necessary files to dist
        print("📦 Copying supplemental files to dist...")
        files_to_copy = ['requirements.txt', 'alembic.ini', '.env']
        for f in files_to_copy:
            if os.path.exists(f):
                shutil.copy(f, 'dist/')
        
        if os.path.exists('alembic'):
             shutil.copytree('alembic', 'dist/alembic', dirs_exist_ok=True)
             
        print("✨ Ready for deployment from the 'dist' directory.")
        
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}")

if __name__ == "__main__":
    obfuscate()
