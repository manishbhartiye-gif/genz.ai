#!/bin/bash
FILE_NAME=$1
TARGET_DIR=$2
mkdir -p "$TARGET_DIR"
cp ".saw-workspace/drafts/$FILE_NAME" "$TARGET_DIR/$FILE_NAME"
git add "$TARGET_DIR/$FILE_NAME"
git commit -m "Auto-promoted: $FILE_NAME"
rm ".saw-workspace/drafts/$FILE_NAME"
echo "🎉 System Workflow Complete. Artifact deployed."
