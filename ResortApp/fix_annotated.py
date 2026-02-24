import os
import re

def fix_annotated_syntax(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Match: name: Annotated[Any, Form(inside)] = outside
    # We want to extract 'inside' and 'outside'
    # Pattern explanation:
    # (\w+): variable name
    # \s*Annotated\[Any,\s*(Form|File)\(  : start of Annotated
    # (.*?) : non-greedy capture of Form arguments
    # \)\]\s*=\s* (.*) : closing brackets and capture of the default value
    pattern = r'(\w+):\s*Annotated\[Any,\s*(Form|File)\((.*?)\)\]\s*=\s*(.*)'

    def replacer(match):
        name = match.group(1)
        func_type = match.group(2)
        inside_args_str = match.group(3).strip()
        outside_val_str = match.group(4).strip()

        # Handle comma at the end of the line
        has_trailing_comma = outside_val_str.endswith(',')
        if has_trailing_comma:
            outside_val_str = outside_val_str[:-1].strip()

        # Split inside args to separate default from other settings (description, etc.)
        inside_args = [arg.strip() for arg in inside_args_str.split(',') if arg.strip()]
        
        default_val = outside_val_str
        remaining_args = []

        if inside_args:
            first_arg = inside_args[0]
            # Check if first arg is a positional default (not a kwarg)
            if '=' not in first_arg:
                if first_arg != '...' and first_arg != 'None':
                    default_val = first_arg
                remaining_args = inside_args[1:]
            else:
                remaining_args = inside_args

        # Reconstruct Form/File call
        new_func_call = f"{func_type}({', '.join(remaining_args)})"
        
        new_line = f"{name}: Annotated[Any, {new_func_call}] = {default_val}{',' if has_trailing_comma else ''}"
        return new_line

    new_content = re.sub(pattern, replacer, content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

def main():
    api_dir = 'app/api'
    fixed_count = 0
    for root, dirs, files in os.walk(api_dir):
        for file in files:
            if file.endswith('.py'):
                if fix_annotated_syntax(os.path.join(root, file)):
                    print(f"Fixed: {os.path.join(root, file)}")
                    fixed_count += 1
    
    # Also fix auth.py in utils as it might have similar issues if I touched it
    utils_auth = 'app/utils/auth.py'
    if os.path.exists(utils_auth):
        if fix_annotated_syntax(utils_auth):
            print(f"Fixed: {utils_auth}")
            fixed_count += 1

    print(f"Total files fixed: {fixed_count}")

if __name__ == "__main__":
    main()
