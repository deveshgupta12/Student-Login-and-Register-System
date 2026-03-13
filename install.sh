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

# Remove existing venv if needed
if [ -d ".venv" ] && [ ! -f ".venv/bin/python" ]; then
  echo "[INFO] Removing incomplete virtual environment..."
  rm -rf .venv
fi

# Create virtual environment
if [ ! -f ".venv/bin/python" ]; then
  echo "[INFO] Creating virtual environment..."
  "$PY_CMD" -m venv .venv
  if [ ! -f ".venv/bin/python" ]; then
    echo "[ERROR] Failed to create virtual environment."
    echo "Try installing: sudo apt-get install python3-venv"
    exit 1
  fi
fi

# Bootstrap pip
echo "[INFO] Installing pip..."
.venv/bin/python -m ensurepip --default-pip 2>/dev/null || \
.venv/bin/python -m ensurepip 2>/dev/null || \
{
  echo "[WARNING] ensurepip failed, trying system pip..."
  "$PY_CMD" -m pip install --user --upgrade pip
  .venv/bin/python -m pip install --upgrade pip || {
    echo "[ERROR] Could not install pip. Try manually:"
    echo "  sudo apt-get install python3-pip"
    echo "  Then rerun this script"
    exit 1
  }
}

echo "[INFO] Upgrading pip..."
.venv/bin/python -m pip install --upgrade pip

echo "[INFO] Installing project dependencies..."
.venv/bin/pip install -r requirements.txt

echo
echo "[SUCCESS] Installation completed successfully."
echo "Run the app with: .venv/bin/python Main.py"
