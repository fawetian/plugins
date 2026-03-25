#!/usr/bin/env bash
# Run a single trigger test for one prompt
# Usage: ./run-single-trigger.sh <plugin_dir> <skill_name> <prompt> <expected> [timeout]
# expected: "true" or "false"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/test-helpers.sh"

PLUGIN_DIR="$1"
SKILL_NAME="$2"
PROMPT="$3"
EXPECTED="$4"
TIMEOUT="${5:-${TIMEOUT:-120}}"

TIMESTAMP=$(date +%s)
OUTPUT_DIR="/tmp/plugin-eval-tests/${TIMESTAMP}/${SKILL_NAME}"
mkdir -p "$OUTPUT_DIR"

LOG_FILE="$OUTPUT_DIR/claude-output.json"

# Run Claude with the plugin
cd "$OUTPUT_DIR"
run_claude_with_plugin "$PROMPT" "$PLUGIN_DIR" "$TIMEOUT" 3 > "$LOG_FILE" 2>&1 || true

# Check result based on expectation
if [ "$EXPECTED" = "true" ]; then
    assert_skill_triggered "$LOG_FILE" "$SKILL_NAME" "Trigger: $PROMPT"
else
    assert_skill_not_triggered "$LOG_FILE" "$SKILL_NAME" "No-trigger: $PROMPT"
fi
