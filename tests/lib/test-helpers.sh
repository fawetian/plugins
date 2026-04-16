#!/usr/bin/env bash
# Skill eval test helpers - assertion library and utilities
# Adapted from superpowers/tests/claude-code/test-helpers.sh

set -euo pipefail

# macOS compatibility: use gtimeout if timeout not available
if ! command -v timeout &> /dev/null; then
    if command -v gtimeout &> /dev/null; then
        timeout() { gtimeout "$@"; }
    else
        # Fallback: run without timeout (not ideal but works)
        timeout() { shift; "$@"; }
    fi
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters (global, accumulated across a test run)
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Get the project root (plugins/)
get_project_root() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    echo "$dir"
}

# Run Claude Code with a plugin directory in headless mode
# Usage: run_claude_with_plugin "prompt" "plugin_dir" [timeout] [max_turns]
# Returns: stream-json output in stdout
run_claude_with_plugin() {
    local prompt="$1"
    local plugin_dir="$2"
    local timeout="${3:-120}"
    local max_turns="${4:-3}"
    local output_file
    output_file=$(mktemp)

    if timeout "$timeout" claude -p "$prompt" \
        --plugin-dir "$plugin_dir" \
        --dangerously-skip-permissions \
        --max-turns "$max_turns" \
        --verbose \
        --output-format stream-json \
        > "$output_file" 2>&1; then
        cat "$output_file"
        rm -f "$output_file"
        return 0
    else
        local exit_code=$?
        cat "$output_file"
        rm -f "$output_file"
        return $exit_code
    fi
}

# Run Claude Code and capture plain text output
# Usage: run_claude_text "prompt" "plugin_dir" [timeout] [max_turns]
run_claude_text() {
    local prompt="$1"
    local plugin_dir="$2"
    local timeout="${3:-120}"
    local max_turns="${4:-3}"
    local output_file
    output_file=$(mktemp)

    if timeout "$timeout" claude -p "$prompt" \
        --plugin-dir "$plugin_dir" \
        --dangerously-skip-permissions \
        --max-turns "$max_turns" \
        > "$output_file" 2>&1; then
        cat "$output_file"
        rm -f "$output_file"
        return 0
    else
        local exit_code=$?
        cat "$output_file"
        rm -f "$output_file"
        return $exit_code
    fi
}

# Assert skill was triggered in stream-json output
# Usage: assert_skill_triggered "log_file" "skill_name" "test_name"
assert_skill_triggered() {
    local log_file="$1"
    local skill_name="$2"
    local test_name="${3:-trigger test}"
    local skill_pattern='"skill":"([^"]*:)?'"${skill_name}"'"'

    if grep -q '"name":"Skill"' "$log_file" && grep -qE "$skill_pattern" "$log_file"; then
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "    Expected skill '$skill_name' to be triggered"
        local triggered
        triggered=$(grep -o '"skill":"[^"]*"' "$log_file" 2>/dev/null | sort -u || true)
        if [ -n "$triggered" ]; then
            echo "    Skills actually triggered: $triggered"
        else
            echo "    No skills were triggered"
        fi
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Assert skill was NOT triggered in stream-json output
# Usage: assert_skill_not_triggered "log_file" "skill_name" "test_name"
assert_skill_not_triggered() {
    local log_file="$1"
    local skill_name="$2"
    local test_name="${3:-negative trigger test}"
    local skill_pattern='"skill":"([^"]*:)?'"${skill_name}"'"'

    if grep -q '"name":"Skill"' "$log_file" && grep -qE "$skill_pattern" "$log_file"; then
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "    Expected skill '$skill_name' NOT to be triggered, but it was"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    else
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    fi
}

# Assert no premature tool actions before Skill invocation
# Usage: assert_no_premature_action "log_file" "test_name"
assert_no_premature_action() {
    local log_file="$1"
    local test_name="${2:-no premature action}"

    local first_skill_line
    first_skill_line=$(grep -n '"name":"Skill"' "$log_file" | head -1 | cut -d: -f1)

    if [ -z "$first_skill_line" ]; then
        echo -e "  ${YELLOW}[SKIP]${NC} $test_name (no Skill invocation found)"
        TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
        return 0
    fi

    local premature_tools
    premature_tools=$(head -n "$first_skill_line" "$log_file" | \
        grep '"type":"tool_use"' | \
        grep -v '"name":"Skill"' | \
        grep -v '"name":"TodoWrite"' | \
        grep -v '"name":"TaskCreate"' || true)

    if [ -n "$premature_tools" ]; then
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "    Tools invoked before Skill:"
        echo "$premature_tools" | head -3 | sed 's/^/      /'
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    else
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    fi
}

# Assert output contains a pattern
# Usage: assert_output_contains "output" "pattern" "test_name"
assert_output_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-contains check}"

    if echo "$output" | grep -q "$pattern"; then
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "    Expected to find: $pattern"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Assert output does NOT contain a pattern
# Usage: assert_output_not_contains "output" "pattern" "test_name"
assert_output_not_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-not-contains check}"

    if echo "$output" | grep -q "$pattern"; then
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "    Did not expect to find: $pattern"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    else
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    fi
}

# Print test summary and return appropriate exit code
# Usage: print_summary
print_summary() {
    echo ""
    echo "========================================"
    echo " Test Results"
    echo "========================================"
    echo -e "  ${GREEN}Passed:${NC}  $TESTS_PASSED"
    echo -e "  ${RED}Failed:${NC}  $TESTS_FAILED"
    echo -e "  ${YELLOW}Skipped:${NC} $TESTS_SKIPPED"
    echo ""

    if [ "$TESTS_FAILED" -gt 0 ]; then
        echo -e "  ${RED}STATUS: FAILED${NC}"
        return 1
    else
        echo -e "  ${GREEN}STATUS: PASSED${NC}"
        return 0
    fi
}

# Export functions
export -f get_project_root
export -f run_claude_with_plugin
export -f run_claude_text
export -f assert_skill_triggered
export -f assert_skill_not_triggered
export -f assert_no_premature_action
export -f assert_output_contains
export -f assert_output_not_contains
export -f print_summary
