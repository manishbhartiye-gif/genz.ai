#!/bin/bash
PENDING_DIR="./jobs/pending"
PROCESSED_DIR="./jobs/processed"

echo "🛡️  Agent OS Watchman Online. Monitoring $PENDING_DIR..."

while true; do
FILES=$(ls -A "$PENDING_DIR"/*.job 2>/dev/null)
if [ ! -z "$FILES" ]; then
for job in $FILES; do
echo "🚀 New Job Detected: $(basename "$job")"
./scripts/orchestrator.sh "$job"
mv "$job" "$PROCESSED_DIR/"
echo "✅ Job $(basename "$job") complete."
done
fi
sleep 2
done