import os
import sys
import shutil
from setuptools import setup, Extension
from Cython.Build import cythonize

def compile_backend():
    """
    Revised compilation script that explicitly handles package structures.
    Compiles Python files into binary (.so) modules while preserving the 'app' hierarchy.
    """
    print("🚀 Starting Professional Binary Compilation (Cython)...")
    
    # 1. Cleanup old build directories
    for folder in ["build", "build_dist", "dist"]:
        if os.path.exists(folder):
            try:
                shutil.rmtree(folder)
            except PermissionError:
                print(f"❌ Permission denied while trying to delete '{folder}'.")
                print(f"👉 Please run manually: sudo rm -rf {folder}")
                return
    
    # 2. Identify files and construct Extension objects
    # We map 'app/models/booking.py' -> Extension('app.models.booking', ['app/models/booking.py'])
    extensions = []
    for root, dirs, files in os.walk("app"):
        if "alembic" in root or "__pycache__" in root:
            continue
        for file in files:
            if file.endswith(".py") and file != "__init__.py":
                file_path = os.path.join(root, file)
                # Convert path to module name: app/models/booking.py -> app.models.booking
                module_name = file_path.replace(os.path.sep, ".").rsplit(".", 1)[0]
                extensions.append(Extension(module_name, [file_path]))

    print(f"📦 Found {len(extensions)} modules to compile.")

    # 3. Running Setup
    try:
        setup(
            ext_modules = cythonize(extensions, 
                                   compiler_directives={
                                       'language_level': "3",
                                       'binding': True,
                                       'embedsignature': True
                                   }),
            script_args = ['build_ext', '--inplace']
        )
        
        # 4. Collection phase: Move everything to 'dist' folder
        print("🚚 Collecting binaries into 'dist/'...")
        dist_dir = "dist"
        # Create full structure in dist
        shutil.copytree("app", os.path.join(dist_dir, "app"), 
                        ignore=shutil.ignore_patterns("*.py", "__pycache__"))
        
        # Copy back __init__.py and non-py files
        for root, dirs, files in os.walk("app"):
            rel_path = os.path.relpath(root, "app")
            target_root = os.path.join(dist_dir, "app", rel_path)
            os.makedirs(target_root, exist_ok=True)
            for file in files:
                if file == "__init__.py" or not file.endswith((".py", ".c", ".so")):
                    shutil.copy2(os.path.join(root, file), target_root)
        
        # Find all compiled .so files and move them to dist
        # Since we used --inplace, they are scattered in the 'app/' folder
        count = 0
        for root, dirs, files in os.walk("app"):
            for file in files:
                if file.endswith(".so"):
                    rel_path = os.path.relpath(root, "app")
                    dest_path = os.path.join(dist_dir, "app", rel_path)
                    os.makedirs(dest_path, exist_ok=True)
                    shutil.move(os.path.join(root, file), os.path.join(dest_path, file))
                    count += 1

        # Copy supplemental config files
        files_to_copy = ['requirements.txt', 'alembic.ini', '.env']
        for f in files_to_copy:
            if os.path.exists(f):
                shutil.copy(f, dist_dir)
        
        # Create empty base directories needed for StaticFiles
        os.makedirs(os.path.join(dist_dir, "uploads"), exist_ok=True)
        os.makedirs(os.path.join(dist_dir, "static"), exist_ok=True)
        
        if os.path.exists('alembic'):
            shutil.copytree('alembic', os.path.join(dist_dir, 'alembic'), dirs_exist_ok=True)

        print(f"✅ Success! {count} binary modules created in 'dist/app'.")
        print("✨ Your original source code is safe, only 'dist/' needs to be deployed.")

    except Exception as e:
        print(f"❌ Compilation failed: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    compile_backend()
