#!/bin/bash
TITLE=$1
CATEGORY=$2
FILE_NAME="draft-$(date +%s).md"

# Orchestrate Pipeline with Logging
./.agents/skills/drafting.sh "$TITLE" "$CATEGORY" "$FILE_NAME" && ./.agents/skills/logger.sh "DraftingAgent" "Create_$FILE_NAME"
./.agents/skills/validator.sh "$FILE_NAME" && ./.agents/skills/logger.sh "DataArchitect" "Validate_$FILE_NAME"
./.agents/skills/auditor.sh "$FILE_NAME" && ./.agents/skills/logger.sh "QASAuditor" "Audit_$FILE_NAME"

# Promote
./scripts/promote-content.sh "$FILE_NAME" "content/$CATEGORY" && ./.agents/skills/logger.sh "DeployAgent" "Promote_$FILE_NAME"
