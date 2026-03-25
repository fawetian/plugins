#!/usr/bin/env bash
# Layer 2+3: Run trigger tests (positive + negative) from evals.json
# Reads all evals.json files, extracts trigger type evals, runs each prompt

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
echo " Layer 2+3: Trigger Tests"
echo "========================================"
echo ""

while IFS='|' read -r plugin_name skill_name eval_file plugin_dir; do
    # Apply filters
    if [ -n "$FILTER_PLUGIN" ] && [ "$plugin_name" != "$FILTER_PLUGIN" ]; then continue; fi
    if [ -n "$FILTER_SKILL" ] && [ "$skill_name" != "$FILTER_SKILL" ]; then continue; fi

    # Extract trigger evals
    trigger_evals=$(jq -c '.evals[] | select(.type == "trigger")' "$eval_file" 2>/dev/null || true)
    if [ -z "$trigger_evals" ]; then continue; fi

    echo "--- $plugin_name / $skill_name ---"

    while read -r eval_block; do
        eval_name=$(echo "$eval_block" | jq -r '.name')
        eval_desc=$(echo "$eval_block" | jq -r '.description // ""')

        if [ -n "$eval_desc" ]; then
            echo "  $eval_name: $eval_desc"
        else
            echo "  $eval_name"
        fi

        # Iterate prompts using temp file to avoid subshell
        prompts_file=$(mktemp)
        echo "$eval_block" | jq -c '.prompts[]' > "$prompts_file"

        while read -r prompt_obj; do
            input=$(echo "$prompt_obj" | jq -r '.input')
            expected=$(echo "$prompt_obj" | jq -r '.expected')
            reason=$(echo "$prompt_obj" | jq -r '.reason // ""')

            if [ "$VERBOSE" = "true" ]; then
                echo "    Prompt: $input"
                echo "    Expected: $expected"
                [ -n "$reason" ] && echo "    Reason: $reason"
            fi

            # Create temp dir for this test
            TIMESTAMP=$(date +%s%N)
            TEST_DIR="/tmp/plugin-eval-tests/${TIMESTAMP}/${skill_name}"
            mkdir -p "$TEST_DIR"
            LOG_FILE="$TEST_DIR/claude-output.json"

            # Run Claude
            cd "$TEST_DIR"
            run_claude_with_plugin "$input" "$plugin_dir" "$TIMEOUT" 3 > "$LOG_FILE" 2>&1 || true

            # Assert
            if [ "$expected" = "true" ]; then
                assert_skill_triggered "$LOG_FILE" "$skill_name" "    [+] $input" || true
            else
                assert_skill_not_triggered "$LOG_FILE" "$skill_name" "    [-] $input" || true
            fi

            if [ "$VERBOSE" = "true" ]; then
                echo "    Log: $LOG_FILE"
            fi
        done < "$prompts_file"

        rm -f "$prompts_file"
    done <<< "$trigger_evals"

    echo ""
done < <(discover_all_evals "$PLUGINS_ROOT")

print_summary
