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
    
    # 2. Run PyArmor
    # Note: 'gen app' obfuscates the entire app directory
    # 'dist' is the default output directory
    try:
        subprocess.run(['pyarmor', 'gen', 'app'], check=True)
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
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Error during obfuscation: {e}")
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}")

if __name__ == "__main__":
    obfuscate()
