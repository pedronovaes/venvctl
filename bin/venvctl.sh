#!/bin/bash

# Script: venvctl.sh
# Author: Pedro Marcelino (pedronovaesmelo@gmail.com)
# Description:
#   Manage Python virtual environments in a fixed directory chosen at
#   installation time.

set -euo pipefail

# Load configuration if exists.
if [ -f /etc/venvctl.conf ]; then
    source /etc/venvctl.conf
fi

# Default directory if not set during installation.
BASE_DIR="${ENV_DIR:-$HOME/.venvs}"
mkdir -p "$BASE_DIR"

show_help() {
    cat << EOF
Usage: venvctl --name <env_name> [options]
Script to manage Python virtual environments.

Required flags:
  --name, -n <env_name>     name of the virtual environment to be created

Optional flags:
  --req, -r <file>          requirements.txt file containing libraries to be
                            installed
  --verbose, -v             show detailed messages during the process
  --list, -l                list all environments created in $BASE_DIR
  --delete <env_name>       delete the specified environment
  --help, -h                show this documentation

Notes:
  - Environments are stored in $BASE_DIR/<env_name>
  - To activate, run: venvctl --activate <env_name>
  - To deactivate, run: deactivate
EOF
}

# Initialize variables.
ENV_NAME=""
REQ_FILE=""
VERBOSE=false
LIST=false
ACTIVATE_ENV=""
DELETE_ENV=""

# Argument parsing.
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h) show_help; exit 0 ;;
        --name|-n) ENV_NAME="${2:-}"; shift 2 ;;
        --req|-r) REQ_FILE="${2:-}"; shift 2 ;;
        --list|-l) LIST=true; shift ;;
        --delete) DELETE_ENV="${2:-}"; shift 2 ;;
        --verbose|-v) VERBOSE=true; shift ;;
        *) echo "Unknown option: $1"; echo "Use 'venvctl --help'"; exit 1 ;;
    esac
done

# List environments.
if [ "$LIST" = true ]; then
    echo "Available environments in $BASE_DIR:"
    ls -1 "$BASE_DIR"
    exit 0
fi

# Delete environment.
if [ -n "$DELETE_ENV" ]; then
    TARGET_DIR="$BASE_DIR/$DELETE_ENV"
    if [ -d "$TARGET_DIR" ]; then
        rm -rf "$TARGET_DIR"
        echo "Environment '$DELETE_ENV' removed from $BASE_DIR"
    else
        echo "Environment '$DELETE_ENV' not found in $BASE_DIR"
    fi
    exit 0
fi

# Validation.
if [ -z "$ENV_NAME" ]; then
    echo "Error: you must provide --name <env_name>"
    echo "Use 'venvctl --help' for instructions."
    exit 1
fi

# Environment creation.
TARGET_DIR="$BASE_DIR/$ENV_NAME"
$VERBOSE && echo "[INFO] Creating virtual environment named '$ENV_NAME' in $TARGET_DIR ..."
virtualenv -p python3 "$TARGET_DIR"
source "$TARGET_DIR/bin/activate"
$VERBOSE && echo "[INFO] Done."

# Pip updating.
$VERBOSE && echo "[INFO] Updating pip ..."
pip install --upgrade pip
$VERBOSE && echo "[INFO] Done."

# Package installation.
if [ -n "$REQ_FILE" ]; then
    if [ -f "$REQ_FILE" ]; then
        $VERBOSE && echo "[INFO] Installing packages from $REQ_FILE ..."
        pip install -r "$REQ_FILE" --no-cache
        $VERBOSE && echo "[INFO] Packages sucessfully installed:"
        $VERBOSE && pip list
    else
        echo "Warning: file $REQ_FILE not found. No packages installed."
    fi
fi

# Finalization.
echo "Virtual environment created succesfully."
echo "To activate, run: source $TARGET_DIR/bin/activate"
echo "To deactivate, run: deactivate"
