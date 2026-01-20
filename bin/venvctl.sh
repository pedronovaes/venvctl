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
  --list                    list all environments created in $BASE_DIR
  --activate <env_name>     activate the specified environment
  --delete <env_name>       delete the specified environment
  --help, -h                show this documentation

Notes:
  - Environments are stored in $BASE_DIR/<env_name>
  - To activate, run: venvctl --activate <env_name>
  - To deactivate, run: deactivate
EOF
}
