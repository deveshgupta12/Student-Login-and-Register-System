#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================="
echo "Student Login/Register - Linux CLI Installer"
echo "============================================="
echo

if command -v python3 >/dev/null 2>&1; then
  PY_CMD="python3"
elif command -v python >/dev/null 2>&1; then
  PY_CMD="python"
else
  echo "[ERROR] Python was not found on this system."
  echo "Install Python 3 and rerun this script."
  exit 1
fi

if [ ! -f ".venv/bin/python" ]; then
  echo "[INFO] Creating virtual environment..."
  "$PY_CMD" -m venv .venv
fi

echo "[INFO] Activating virtual environment..."
source .venv/bin/activate

echo "[INFO] Upgrading pip..."
python -m pip install --upgrade pip

echo "[INFO] Installing project dependencies..."
pip install -r requirements.txt

echo
echo "[SUCCESS] Installation completed successfully."
echo "Run the app with: .venv/bin/python Main.py"
