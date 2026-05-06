#!/bin/bash
# ============================================================
#  run_clear_on_server.sh
#  Uploads clear_server_data.py to ~ (home dir, always writable)
#  then moves it to /opt/pomma/ResortApp/dist with sudo,
#  and executes it.
#
#  Usage (from Git Bash / WSL on your local machine):
#    bash run_clear_on_server.sh <server_ip> [ssh_user]
#
#  Examples:
#    bash run_clear_on_server.sh 123.456.789.0
#    bash run_clear_on_server.sh 123.456.789.0 root
#    bash run_clear_on_server.sh 123.456.789.0 ubuntu
# ============================================================

SERVER_IP="${1}"
SSH_USER="${2:-root}"
REMOTE_DIR="/opt/pomma/ResortApp/dist"
SCRIPT_NAME="clear_server_data.py"

# ── Validate ─────────────────────────────────────────────────
if [ -z "$SERVER_IP" ]; then
    echo ""
    echo "❌  Error: Server IP is required."
    echo "    bash run_clear_on_server.sh <server_ip> [ssh_user]"
    echo ""
    exit 1
fi

echo "============================================================"
echo "  RESORT SERVER DATA CLEANUP"
echo "============================================================"
echo "  Server  : $SSH_USER@$SERVER_IP"
echo "  Path    : $REMOTE_DIR"
echo ""

# ── Step 1: Upload to home dir (always writable) ─────────────
echo "📤  Uploading $SCRIPT_NAME to ~/ (home directory)..."
scp "$SCRIPT_NAME" "$SSH_USER@$SERVER_IP:~/$SCRIPT_NAME"

if [ $? -ne 0 ]; then
    echo "❌  Upload failed. Check SSH connection / server IP."
    exit 1
fi
echo "✅  Upload to home directory successful."
echo ""

# ── Step 2: Move to target dir and run ───────────────────────
echo "🚀  Moving script and running on server..."
echo ""

ssh -t "$SSH_USER@$SERVER_IP" "
    # Move script from home to the target directory
    sudo cp ~/$SCRIPT_NAME $REMOTE_DIR/$SCRIPT_NAME

    cd $REMOTE_DIR

    # Detect python: prefer venv, fall back to system python3
    if [ -f /opt/pomma/ResortApp/venv/bin/python ]; then
        PYTHON=/opt/pomma/ResortApp/venv/bin/python
    elif [ -f ../venv/bin/python ]; then
        PYTHON=../venv/bin/python
    else
        PYTHON=python3
    fi

    echo \"Using Python: \$PYTHON\"
    echo ''

    sudo \$PYTHON $REMOTE_DIR/$SCRIPT_NAME

    # Clean up script from server after run
    sudo rm -f $REMOTE_DIR/$SCRIPT_NAME
    rm -f ~/$SCRIPT_NAME
    echo ''
    echo 'Script removed from server.'
"

echo ""
echo "============================================================"
echo "  Done. SSH session closed."
echo "============================================================"
