#!/bin/bash
# Router logic: Matches metadata (type/provider) to specific scripts in .agents/skills/
TYPE=$1
PROVIDER=$2
TITLE=$3
FILE_NAME=$4

# Path to the Registry
REGISTRY=".agents/registry.json"

# Resolve script name from JSON
SCRIPT_NAME=$(python3 -c "import json; data=json.load(open('$REGISTRY')); print(data['$TYPE']['$PROVIDER'])")

if [ -z "$SCRIPT_NAME" ]; then
    echo "[ROUTER] Agent not found. Routing to fallback..."
    FALLBACK=$(python3 -c "import json; data=json.load(open('$REGISTRY')); print(data['default_fallback'])")
    SCRIPT_NAME="drafting-$FALLBACK.sh"
fi

echo "[ROUTER] Dispatching to: $SCRIPT_NAME"
# Pass to kernel for execution
python3 scripts/kernel.py saw-exec "$SCRIPT_NAME" "$TITLE" "$FILE_NAME"