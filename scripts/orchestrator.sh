#!/bin/bash
JOB_FILE=$1
TITLE=$(grep "title:" "$JOB_FILE" | cut -d' ' -f2-)
TYPE=$(grep "type:" "$JOB_FILE" | cut -d' ' -f2-)
PROVIDER=$(grep "provider:" "$JOB_FILE" | cut -d' ' -f2-)
FILE_NAME="draft-$(date +%s).md"

echo "[KERNEL] Orchestrating: $TITLE | Type: $TYPE | Provider: $PROVIDER"

# Hand off to the Router
./scripts/router.sh "$TYPE" "$PROVIDER" "$TITLE" "$FILE_NAME"

# Validation Gates
python3 scripts/kernel.py saw-exec "validator.sh"
python3 scripts/kernel.py saw-exec "auditor.sh"