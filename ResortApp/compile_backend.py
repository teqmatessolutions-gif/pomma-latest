import os
import sys
import shutil
from setuptools import setup, Extension
from Cython.Build import cythonize

def compile_backend():
    """
    Compiles the Python backend into binary (.so) files using Cython.
    This makes the code completely unreadable as it becomes machine code.
    """
    print("🚀 Starting Binary Compilation (Cython)...")
    
    # 1. Cleanup old build directories
    build_dir = "build_dist"
    if os.path.exists(build_dir):
        shutil.rmtree(build_dir)
    os.makedirs(build_dir)

    # 2. Identify files to compile
    # We want to compile everything in 'app/' except __init__.py and alembic folder
    # Note: __init__.py is often better kept as source or handled carefully
    to_compile = []
    for root, dirs, files in os.walk("app"):
        if "alembic" in root: continue # Skip migrations
        for file in files:
            if file.endswith(".py") and file != "__init__.py":
                full_path = os.path.join(root, file)
                to_compile.append(full_path)

    print(f"📦 Found {len(to_compile)} files to compile.")

    # 3. Running Cythonize
    try:
        # We use 'ext_modules' to compile them into shared objects (.so)
        setup(
            ext_modules = cythonize(to_compile, 
                                   compiler_directives={'language_level': "3"},
                                   build_dir=build_dir),
            script_args = ['build_ext', '--inplace']
        )
        
        # 4. Cleanup and move binaries to a 'dist' folder
        dist_dir = "dist"
        if os.path.exists(dist_dir):
            shutil.rmtree(dist_dir)
        
        # We will copy the structure but only keep .so files and __init__.py
        shutil.copytree("app", os.path.join(dist_dir, "app"), 
                        ignore=shutil.ignore_patterns("*.py"))
        
        # Copy back the original __init__.py and other non-py files
        for root, dirs, files in os.walk("app"):
            rel_path = os.path.rel_path(root, "app")
            target_root = os.path.join(dist_dir, "app", rel_path)
            for file in files:
                if file == "__init__.py" or not file.endswith(".py"):
                    shutil.copy2(os.path.join(root, file), target_root)
        
        # Move the compiled .so files from app/ into dist/app/
        for root, dirs, files in os.walk("app"):
            for file in files:
                if file.endswith(".so"):
                    rel_dir = os.path.rel_path(root, "app")
                    shutil.move(os.path.join(root, file), os.path.join(dist_dir, "app", rel_dir, file))

        # Copy supplemental config files
        files_to_copy = ['requirements.txt', 'alembic.ini', '.env']
        for f in files_to_copy:
            if os.path.exists(f):
                shutil.copy(f, dist_dir)
        
        if os.path.exists('alembic'):
            shutil.copytree('alembic', os.path.join(dist_dir, 'alembic'), dirs_exist_ok=True)

        print("✅ Compilation complete! Protected binary code is in 'dist/'")
        print("✨ Native binary modules (.so) are unreadable by humans.")

    except Exception as e:
        print(f"❌ Compilation failed: {e}")

if __name__ == "__main__":
    compile_backend()
