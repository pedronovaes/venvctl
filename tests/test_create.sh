#!/bin/bash

set -euo pipefail

# Resolve ENV_DIR from config or fallback to default.
get_env_dir() {
    if [ -f /etc/venvctl.conf ]; then
        source /etc/venvctl.conf
        echo "$ENV_DIR"
    else
        echo "$HOME/.venvs"
    fi
}

ENV_DIR=$(get_env_dir)

echo "Testing environment creation ..."
venvctl --name test_env

if [ -d "$ENV_DIR/test_env" ]; then
    echo "Environment created successfully in $ENV_DIR."
    venvctl --delete test_env
else
    echo "Environment creation failed."
fi
