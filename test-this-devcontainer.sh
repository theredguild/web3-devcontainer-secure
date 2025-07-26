#!/bin/bash
# Quick test script for web3-devcontainer-secure only
# This script tests only this devcontainer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVCONTAINER_NAME="web3-devcontainer-secure"

echo "🧪 Testing $DEVCONTAINER_NAME"
echo "=============================="

if [ -f "./test-individual-devcontainer.sh" ]; then
    ./test-individual-devcontainer.sh "$DEVCONTAINER_NAME"
else
    echo "❌ test-individual-devcontainer.sh not found"
    echo "Please run: make setup"
    exit 1
fi
