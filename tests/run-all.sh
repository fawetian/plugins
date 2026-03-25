#!/usr/bin/env bash
# Main test runner for plugin skill evaluations
# Usage: ./tests/run-all.sh [options]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Defaults
RUN_STRUCTURE=false
RUN_TRIGGER=false
RUN_EXPLICIT=false
RUN_OUTPUT=false
RUN_ALL=true
FILTER_PLUGIN=""
FILTER_SKILL=""
VERBOSE=false
TIMEOUT=120
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --structure)   RUN_STRUCTURE=true; RUN_ALL=false; shift ;;
        --trigger)     RUN_TRIGGER=true; RUN_ALL=false; shift ;;
        --explicit)    RUN_EXPLICIT=true; RUN_ALL=false; shift ;;
        --output)      RUN_OUTPUT=true; RUN_ALL=false; shift ;;
        --plugin)      FILTER_PLUGIN="$2"; shift 2 ;;
        --skill)       FILTER_SKILL="$2"; shift 2 ;;
        --verbose|-v)  VERBOSE=true; shift ;;
        --timeout)     TIMEOUT="$2"; shift 2 ;;
        --dry-run)     DRY_RUN=true; shift ;;
        --help|-h)
            cat <<EOF
Usage: $0 [options]

Options:
  --structure       Run plugin structure validation only (fast, no Claude)
  --trigger         Run trigger tests only (positive + negative)
  --explicit        Run explicit skill request tests only
  --output          Run output quality tests only
  --plugin NAME     Filter to a specific plugin
  --skill NAME      Filter to a specific skill
  --verbose, -v     Show detailed output
  --timeout SEC     Timeout per test (default: 120s)
  --dry-run         List tests without running them
  --help, -h        Show this help

Examples:
  $0                          # Run all tests
  $0 --structure              # Quick structure check
  $0 --trigger --skill git-ops  # Test git-ops triggering
  $0 --dry-run                # See what would run
EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1 (use --help for usage)"
            exit 1
            ;;
    esac
done

echo "========================================"
echo " Plugin Skill Evaluation Suite"
echo "========================================"
echo ""
echo "Project: $PROJECT_ROOT"
echo "Time:    $(date)"
echo ""

# Check dependencies
if ! command -v jq &>/dev/null; then
    echo "ERROR: jq is required. Install with: brew install jq"
    exit 1
fi

if ! command -v claude &>/dev/null; then
    echo "WARNING: Claude CLI not found. Only structure tests will work."
    echo ""
fi

# Export settings for child scripts
export FILTER_PLUGIN FILTER_SKILL VERBOSE TIMEOUT DRY_RUN PROJECT_ROOT

OVERALL_EXIT=0

# Layer 1: Structure validation
if [ "$RUN_ALL" = true ] || [ "$RUN_STRUCTURE" = true ]; then
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: structure/validate-plugins.sh"
    else
        if bash "$SCRIPT_DIR/structure/validate-plugins.sh"; then
            :
        else
            OVERALL_EXIT=1
        fi
    fi
fi

# Layer 2+3: Trigger tests (positive + negative)
if [ "$RUN_ALL" = true ] || [ "$RUN_TRIGGER" = true ]; then
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: triggering/run-trigger-tests.sh"
        # Show discovered evals
        source "$SCRIPT_DIR/lib/plugin-discovery.sh"
        echo "  Discovered evals:"
        discover_all_evals "$PROJECT_ROOT/plugins" | while IFS='|' read -r pn sn ef pd; do
            if [ -n "$FILTER_PLUGIN" ] && [ "$pn" != "$FILTER_PLUGIN" ]; then continue; fi
            if [ -n "$FILTER_SKILL" ] && [ "$sn" != "$FILTER_SKILL" ]; then continue; fi
            trigger_count=$(jq '[.evals[] | select(.type == "trigger")] | length' "$ef" 2>/dev/null || echo 0)
            echo "    $pn/$sn: $trigger_count trigger eval(s)"
        done
    else
        if bash "$SCRIPT_DIR/triggering/run-trigger-tests.sh"; then
            :
        else
            OVERALL_EXIT=1
        fi
    fi
fi

# Layer 4: Explicit request tests
if [ "$RUN_ALL" = true ] || [ "$RUN_EXPLICIT" = true ]; then
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: explicit/run-explicit-tests.sh"
    else
        if bash "$SCRIPT_DIR/explicit/run-explicit-tests.sh"; then
            :
        else
            OVERALL_EXIT=1
        fi
    fi
fi

# Layer 5: Output quality tests
if [ "$RUN_ALL" = true ] || [ "$RUN_OUTPUT" = true ]; then
    echo ""
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: output/run-output-tests.sh"
        source "$SCRIPT_DIR/lib/plugin-discovery.sh"
        echo "  Discovered output evals:"
        discover_all_evals "$PROJECT_ROOT/plugins" | while IFS='|' read -r pn sn ef pd; do
            if [ -n "$FILTER_PLUGIN" ] && [ "$pn" != "$FILTER_PLUGIN" ]; then continue; fi
            if [ -n "$FILTER_SKILL" ] && [ "$sn" != "$FILTER_SKILL" ]; then continue; fi
            output_count=$(jq '[.evals[] | select(.type == "output")] | length' "$ef" 2>/dev/null || echo 0)
            if [ "$output_count" -gt 0 ]; then
                echo "    $pn/$sn: $output_count output eval(s)"
            fi
        done
    else
        if bash "$SCRIPT_DIR/output/run-output-tests.sh"; then
            :
        else
            OVERALL_EXIT=1
        fi
    fi
fi

echo ""
echo "========================================"
if [ "$DRY_RUN" = true ]; then
    echo " Dry run complete"
else
    if [ "$OVERALL_EXIT" -eq 0 ]; then
        echo " All test layers passed"
    else
        echo " Some test layers failed"
    fi
fi
echo "========================================"

exit $OVERALL_EXIT
