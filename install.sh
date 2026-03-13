#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================="
echo "Student Login/Register - Linux CLI Installer"
echo "============================================="
echo

# Find Python command
if command -v python3 >/dev/null 2>&1; then
  PY_CMD="python3"
elif command -v python >/dev/null 2>&1; then
  PY_CMD="python"
else
  echo "[ERROR] Python was not found on this system."
  echo "Install Python 3 and rerun this script."
  exit 1
fi

echo "[INFO] Using: $PY_CMD"
echo "[INFO] Python version:"
"$PY_CMD" --version

# Check if python3-full is available (needed for venv with pip on Debian/Ubuntu)
if ! "$PY_CMD" -c "import venv" 2>/dev/null; then
  echo "[ERROR] venv module not available."
  echo "Try installing: sudo apt-get install python3-venv"
  exit 1
fi

# Remove existing venv if incomplete
if [ -d ".venv" ] && [ ! -f ".venv/bin/pip" ] && [ ! -f ".venv/bin/python" ]; then
  echo "[INFO] Removing incomplete virtual environment..."
  rm -rf .venv
fi

# Create virtual environment
if [ ! -f ".venv/bin/python" ]; then
  echo "[INFO] Creating virtual environment..."
  # Try with --upgrade-deps first (Python 3.9+)
  "$PY_CMD" -m venv .venv --upgrade-deps 2>/dev/null || \
  # Fallback: create with system-site-packages to access system pip
  "$PY_CMD" -m venv .venv --system-site-packages || \
  # Last resort: basic venv
  "$PY_CMD" -m venv .venv
  
  if [ ! -f ".venv/bin/python" ]; then
    echo "[ERROR] Failed to create virtual environment."
    echo "Try installing: sudo apt-get install python3-full"
    exit 1
  fi
fi

# Verify and install pip if needed
if ! .venv/bin/python -c "import pip" 2>/dev/null; then
  echo "[INFO] Pip not found, copying from system..."
  if command -v pip3 >/dev/null 2>&1; then
    # If system pip is available, upgrade it in venv
    pip3 install --target .venv/lib/python*/site-packages --upgrade pip 2>/dev/null || \
    .venv/bin/python -m ensurepip --upgrade 2>/dev/null || {
      echo "[ERROR] Could not bootstrap pip in venv."
      echo "Try installing: sudo apt-get install python3-full"
      exit 1
    }
  else
    .venv/bin/python -m ensurepip --upgrade || {
      echo "[ERROR] Could not bootstrap pip in venv."
      echo "Try installing: sudo apt-get install python3-full"
      exit 1
    }
  fi
fi

echo "[INFO] Upgrading pip..."
.venv/bin/python -m pip install --upgrade pip

echo "[INFO] Installing project dependencies..."
.venv/bin/pip install -r requirements.txt

echo
echo "[SUCCESS] Installation completed successfully."
echo "Run the app with: .venv/bin/python Main.py"
