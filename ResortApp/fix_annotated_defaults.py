import os
import re

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern to find Annotated[Any, Dependency(DEFAULT, ...)] = DEFAULT
    # We want to remove the redundant DEFAULT from inside the parentheses.
    
    # We'll target Query, Form, File, Path, Body, Header
    dependencies = ['Query', 'Form', 'File', 'Path', 'Body', 'Header']
    
    modified = False
    for dep in dependencies:
        # Match: Annotated[Any, dep(default_val, ...)] = outside_val
        # We look for None, empty strings, numbers, etc.
        # This pattern is more targeted to avoid complex cases but catch the common ones.
        
        # Pattern components:
        # 1. Annotated[Any, dep(
        # 2. default_val (None, "", [], etc.)
        # 3. possible comma and other args
        # 4. )]
        # 5. = outside_val
        
        # Simple case: dep(None, ...) -> dep(...)
        pattern = rf'(Annotated\[Any,\s*{dep}\()None,\s*'
        content, count = re.subn(pattern, r'\1', content)
        if count > 0: modified = True
        
        # Case: dep(None) -> dep()
        pattern = rf'(Annotated\[Any,\s*{dep}\()None\)'
        content, count = re.subn(pattern, r'\1)', content)
        if count > 0: modified = True

        # Case: dep("") -> dep() with extra assignment check
        # Only if followed by = ""
        pattern = rf'(Annotated\[Any,\s*{dep}\("")\)\]\s*=\s*""'
        content, count = re.subn(pattern, rf'\1)] = ""', content) # Wait, this pattern is tricky
        
    # Let's do a more robust one specifically for report.py first since it's the main culprit
    if "report.py" in filepath:
        # Specifically fix the ones I introduced
        content = content.replace('Query(None, description=', 'Query(description=')
        content = content.replace('Query(None)', 'Query()')
        modified = True

    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {filepath}")

if __name__ == "__main__":
    api_dir = r"d:\resort_oc_10\Resortwithlandingpage\pomma-latest\ResortApp\app\api"
    for filename in os.listdir(api_dir):
        if filename.endswith(".py"):
            fix_file(os.path.join(api_dir, filename))
