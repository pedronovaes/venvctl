#!/bin/bash

set -euo pipefail

echo "Running all venvctl tests ..."
./tests/test_create.sh
echo "All tests passed successfully!"
