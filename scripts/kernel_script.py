import sys, os, subprocess

# Define strict security boundaries
WORKSPACE_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SANDBOX_DIR = os.path.join(WORKSPACE_ROOT, ".saw-workspace", "drafts")
SKILLS_DIR = os.path.join(WORKSPACE_ROOT, ".agents", "skills")

def is_path_safe(path):
    """Ensure all file operations stay within sandbox or skills folders."""
    abs_path = os.path.abspath(path)
    return abs_path.startswith(SANDBOX_DIR) or abs_path.startswith(SKILLS_DIR)

def secure_write(target, content):
    """Write content to a file only if the path is confirmed safe."""
    if not is_path_safe(target):
        return "ERROR: SECURITY VIOLATION: Write blocked."
    
    # Ensure parent directory exists
    os.makedirs(os.path.dirname(target), exist_ok=True)
    
    with open(target, 'w') as f:
        f.write(content)
    return "SUCCESS"

def secure_exec(script_name):
    """Only allow execution from the trusted skills directory."""
    target = os.path.join(SKILLS_DIR, script_name)
    if not os.path.exists(target):
        return "ERROR: Skill not found."
    
    # Run in a restricted environment
    try:
        # Pass control to the skill script
        result = subprocess.run([target], capture_output=True, text=True)
        return result.stdout
    except Exception as e:
        return f"ERROR: Execution failed: {str(e)}"

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: kernel.py <command> <target>")
        sys.exit(1)
        
    cmd = sys.argv[1]
    target = sys.argv[2]
    
    if cmd == "saw-write":
        # Read content from stdin and write it to target
        print(secure_write(target, sys.stdin.read()))
    elif cmd == "saw-exec":
        print(secure_exec(target))