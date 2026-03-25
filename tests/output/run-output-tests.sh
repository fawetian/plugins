#!/usr/bin/env bash
# Layer 5: Output quality tests
# Runs prompts and checks output against expected patterns/descriptions

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
echo " Layer 5: Output Quality Tests"
echo "========================================"
echo ""

while IFS='|' read -r plugin_name skill_name eval_file plugin_dir; do
    # Apply filters
    if [ -n "$FILTER_PLUGIN" ] && [ "$plugin_name" != "$FILTER_PLUGIN" ]; then continue; fi
    if [ -n "$FILTER_SKILL" ] && [ "$skill_name" != "$FILTER_SKILL" ]; then continue; fi

    # Extract output evals
    output_evals=$(jq -c '.evals[] | select(.type == "output")' "$eval_file" 2>/dev/null || true)
    if [ -z "$output_evals" ]; then continue; fi

    echo "--- $plugin_name / $skill_name ---"

    while read -r eval_block; do
        eval_name=$(echo "$eval_block" | jq -r '.name')
        prompt=$(echo "$eval_block" | jq -r '.prompt')

        echo "  $eval_name"

        # Create temp dir
        TIMESTAMP=$(date +%s%N)
        TEST_DIR="/tmp/plugin-eval-tests/${TIMESTAMP}/output/${skill_name}"
        mkdir -p "$TEST_DIR"

        if [ "$VERBOSE" = "true" ]; then
            echo "    Prompt: $prompt"
        fi

        # Run Claude and get text output
        cd "$TEST_DIR"
        OUTPUT=$(run_claude_text "$prompt" "$plugin_dir" "$TIMEOUT" 5 2>&1 || true)

        # Run checks using temp file
        checks_file=$(mktemp)
        echo "$eval_block" | jq -c '.checks[]' > "$checks_file"

        while read -r check; do
            check_name=$(echo "$check" | jq -r '.name')
            check_desc=$(echo "$check" | jq -r '.description')
            pattern=$(echo "$check" | jq -r '.pattern // empty')

            if [ -n "$pattern" ]; then
                # Automated check with pattern
                assert_output_contains "$OUTPUT" "$pattern" "    $check_name: $check_desc" || true
            else
                # Manual review - just report
                echo -e "  ${YELLOW}[REVIEW]${NC} $check_name: $check_desc"
                TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
            fi
        done < "$checks_file"

        rm -f "$checks_file"

        if [ "$VERBOSE" = "true" ]; then
            echo "    Output (truncated):"
            echo "$OUTPUT" | head -c 500 | sed 's/^/      /'
            echo ""
        fi
    done <<< "$output_evals"

    echo ""
done < <(discover_all_evals "$PLUGINS_ROOT")

print_summary
