#!/bin/bash
# batch-translate.sh - Automated batch translation with concurrency control
# Usage: ./batch-translate.sh <project_path> [--max-agents=N]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

PROJECT_PATH="${1:-.}"
MAX_AGENTS=5

# Parse arguments
shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --max-agents=*)
            MAX_AGENTS="${1#*=}"
            shift
            ;;
        --max-agents)
            MAX_AGENTS="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ "$PROJECT_PATH" != /* ]]; then
    PROJECT_PATH="$(pwd)/$PROJECT_PATH"
fi

OUTPUT_DIR="$PROJECT_PATH/docs/code-translate"

# Check prerequisites
if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
    echo "Error: Progress state not found. Run phases 1-2 first." >&2
    exit 1
fi

# Function to get pending file count
get_pending_count() {
    if command -v jq &> /dev/null; then
        jq '[.files[] | select(.status == "pending")] | length' "$OUTPUT_DIR/progress-state.json"
    else
        python3 -c "
import json
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)
print(sum(1 for f in state['files'] if f['status'] == 'pending'))
"
    fi
}

# Function to get next batch of files
get_next_batch() {
    local count="$1"
    bash "$SCRIPT_DIR/translate-progress.sh" next "$PROJECT_PATH" "$count"
}

# Function to calculate optimal concurrency
calculate_concurrency() {
    local pending="$1"

    if [[ "$pending" -lt 50 ]]; then
        echo "1"
    elif [[ "$pending" -lt 200 ]]; then
        echo "3"
    else
        echo "$MAX_AGENTS"
    fi
}

# Function to calculate batch size per agent
calculate_batch_size() {
    local pending="$1"
    local agents="$2"

    local size=$((pending / agents))
    if [[ "$size" -lt 5 ]]; then
        echo "5"
    elif [[ "$size" -gt 20 ]]; then
        echo "20"
    else
        echo "$size"
    fi
}

echo "=========================================="
echo "Batch Translation Controller"
echo "=========================================="
echo "Project: $PROJECT_PATH"
echo "Max Agents: $MAX_AGENTS"
echo ""

# Main translation loop
iteration=0
while true; do
    iteration=$((iteration + 1))

    # Get current pending count
    pending=$(get_pending_count)

    echo "--- Iteration $iteration ---"
    echo "Pending files: $pending"

    if [[ "$pending" -eq 0 ]]; then
        echo ""
        echo "=========================================="
        echo "All files translated!"
        echo "=========================================="
        bash "$SCRIPT_DIR/translate-progress.sh" status "$PROJECT_PATH"
        break
    fi

    # Calculate concurrency
    agents=$(calculate_concurrency "$pending")
    batch_size=$(calculate_batch_size "$pending" "$agents")

    echo "Agents: $agents, Batch size: $batch_size"
    echo ""

    # Get next batch of files
    files_to_process=$(get_next_batch "$((agents * batch_size))")

    if [[ -z "$files_to_process" ]]; then
        echo "No more files to process"
        break
    fi

    # For single agent (small projects), process sequentially
    if [[ "$agents" -eq 1 ]]; then
        echo "Processing files sequentially..."
        echo "$files_to_process" | while read -r file; do
            echo "  Translating: $file"
            # Mark as started
            bash "$SCRIPT_DIR/translate-progress.sh" start "$PROJECT_PATH" "$file" 2>/dev/null || true
        done
    else
        echo "Processing files with $agents concurrent agents..."
        # Note: Actual parallel processing would be handled by the AI system
        # This script just prepares the batches and marks files as started

        # Split files into batches for each agent
        file_array=($files_to_process)
        total_files=${#file_array[@]}
        files_per_agent=$(( (total_files + agents - 1) / agents ))

        for ((i=0; i<agents; i++)); do
            start_idx=$((i * files_per_agent))
            end_idx=$((start_idx + files_per_agent))
            if [[ "$end_idx" -gt "$total_files" ]]; then
                end_idx=$total_files
            fi

            if [[ "$start_idx" -lt "$total_files" ]]; then
                batch_files=(${file_array[@]:start_idx:end_idx-start_idx})
                echo "  Agent $i: ${#batch_files[@]} files"

                # Mark all files in this batch as started
                for file in "${batch_files[@]}"; do
                    bash "$SCRIPT_DIR/translate-progress.sh" start "$PROJECT_PATH" "$file" 2>/dev/null || true
                done
            fi
        done
    fi

    echo ""
    echo "Files marked for translation. Ready for AI agents to process."
    echo ""

    # Show current status
    bash "$SCRIPT_DIR/translate-progress.sh" status "$PROJECT_PATH"

    echo ""
    read -p "Press Enter to continue to next batch (or Ctrl+C to stop)..."
done
