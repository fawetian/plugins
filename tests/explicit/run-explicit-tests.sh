#!/usr/bin/env bash
# Layer 4: Explicit skill request tests
# Tests that when a user explicitly names a skill, it triggers AND no premature actions occur

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/test-helpers.sh"
source "$SCRIPT_DIR/../lib/plugin-discovery.sh"

PROJECT_ROOT="${PROJECT_ROOT:-$(get_project_root)}"
PLUGINS_ROOT="$PROJECT_ROOT/plugins"
FILTER_PLUGIN="${FILTER_PLUGIN:-}"
FILTER_SKILL="${FILTER_SKILL:-}"
TIMEOUT="${TIMEOUT:-120}"
VERBOSE="${VERBOSE:-false}"

echo "========================================"
echo " Layer 4: Explicit Skill Request Tests"
echo "========================================"
echo ""

while IFS='|' read -r plugin_name skill_name eval_file plugin_dir; do
    # Apply filters
    if [ -n "$FILTER_PLUGIN" ] && [ "$plugin_name" != "$FILTER_PLUGIN" ]; then continue; fi
    if [ -n "$FILTER_SKILL" ] && [ "$skill_name" != "$FILTER_SKILL" ]; then continue; fi

    # Extract positive trigger prompts that explicitly name the skill
    prompts_file=$(mktemp)
    jq -c --arg skill "$skill_name" \
        '.evals[] | select(.type == "trigger") | .prompts[] | select(.expected == true) | select(.input | test($skill; "i"))' \
        "$eval_file" > "$prompts_file" 2>/dev/null || true

    prompt_count=$(wc -l < "$prompts_file" | tr -d ' ')
    if [ "$prompt_count" -eq 0 ]; then
        rm -f "$prompts_file"
        continue
    fi

    echo "--- $plugin_name / $skill_name ($prompt_count explicit prompts) ---"

    while read -r prompt_obj; do
        input=$(echo "$prompt_obj" | jq -r '.input')

        # Create temp dir
        TIMESTAMP=$(date +%s%N)
        TEST_DIR="/tmp/plugin-eval-tests/${TIMESTAMP}/explicit/${skill_name}"
        mkdir -p "$TEST_DIR"
        LOG_FILE="$TEST_DIR/claude-output.json"

        if [ "$VERBOSE" = "true" ]; then
            echo "  Prompt: $input"
        fi

        # Run Claude
        cd "$TEST_DIR"
        run_claude_with_plugin "$input" "$plugin_dir" "$TIMEOUT" 3 > "$LOG_FILE" 2>&1 || true

        # Assert skill triggered
        assert_skill_triggered "$LOG_FILE" "$skill_name" "    Triggered: $input" || true

        # Assert no premature action
        assert_no_premature_action "$LOG_FILE" "    No premature action: $input" || true

        if [ "$VERBOSE" = "true" ]; then
            echo "    Log: $LOG_FILE"
        fi
    done < "$prompts_file"

    rm -f "$prompts_file"
    echo ""
done < <(discover_all_evals "$PLUGINS_ROOT")

print_summary
