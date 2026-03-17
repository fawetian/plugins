#!/bin/bash
# translate-progress.sh - Manage translation progress state and directory syncing
# Usage: ./translate-progress.sh <command> <project> [args...]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

# Commands:
# init <project>                    - Initialize progress tracking
# init-incremental <project>        - Initialize for incremental translation
# next <project> [count]            - Get next batch of files to process
# start <project> <file>            - Mark file as in progress
# complete <project> <file>         - Mark file as completed
# fail <project> <file> [reason]    - Mark file as failed
# status <project>                  - Show progress status
# reset <project>                   - Reset all progress
# checkpoint <project>              - Save checkpoint
# sync-dirs <project>               - Sync directory structure to output

# Parse command
COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
    init)
        PROJECT="${1:-.}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        # Check for scan result
        if [[ ! -f "$OUTPUT_DIR/scan-result.json" ]]; then
            echo "Error: No scan result found. Run scan-md.sh first."
            exit 1
        fi

        mkdir -p "$OUTPUT_DIR"

        # Initialize progress state
        cat > "$OUTPUT_DIR/progress-state.json" << EOF
{
  "version": "1.0",
  "projectPath": "$PROJECT",
  "createdAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "updatedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "mode": "full",
  "statistics": {
    "total": 0,
    "completed": 0,
    "inProgress": 0,
    "pending": 0,
    "failed": 0
  },
  "files": []
}
EOF

        # Read scan result and initialize file states
        if command -v jq &> /dev/null; then
            # Use jq for JSON processing
            total=$(jq 'length' "$OUTPUT_DIR/scan-result.json")

            # Build files array
            jq -c '.[]' "$OUTPUT_DIR/scan-result.json" | while read -r entry; do
                path=$(echo "$entry" | jq -r '.path')
                words=$(echo "$entry" | jq -r '.wordCount')
                hash=$(echo "$entry" | jq -r '.hash')

                # Append to progress state
                jq --arg path "$path" \
                   --argjson words "$words" \
                   --arg hash "$hash" \
                   '.files += [{
                     "path": $path,
                     "wordCount": $words,
                     "hash": $hash,
                     "status": "pending",
                     "startedAt": null,
                     "completedAt": null,
                     "error": null
                   }]' "$OUTPUT_DIR/progress-state.json" > "$OUTPUT_DIR/progress-state.tmp.json"
                mv "$OUTPUT_DIR/progress-state.tmp.json" "$OUTPUT_DIR/progress-state.json"
            done

            # Update statistics
            jq --argjson total "$total" \
               '.statistics.total = $total | .statistics.pending = $total' \
               "$OUTPUT_DIR/progress-state.json" > "$OUTPUT_DIR/progress-state.tmp.json"
            mv "$OUTPUT_DIR/progress-state.tmp.json" "$OUTPUT_DIR/progress-state.json"
        else
            # Fallback without jq - use python3
            python3 -c "
import json
import sys
from datetime import datetime

with open('$OUTPUT_DIR/scan-result.json', 'r') as f:
    files = json.load(f)

state = {
    'version': '1.0',
    'projectPath': '$PROJECT',
    'createdAt': datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
    'updatedAt': datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
    'mode': 'full',
    'statistics': {
        'total': len(files),
        'completed': 0,
        'inProgress': 0,
        'pending': len(files),
        'failed': 0
    },
    'files': [
        {
            'path': f['path'],
            'wordCount': f['wordCount'],
            'hash': f['hash'],
            'status': 'pending',
            'startedAt': None,
            'completedAt': None,
            'error': None
        }
        for f in files
    ]
}

with open('$OUTPUT_DIR/progress-state.json', 'w') as f:
    json.dump(state, f, indent=2)

print(f'Initialized {len(files)} files')
"
        fi

        echo "Translation progress tracking initialized for: $PROJECT"
        echo "State file: $OUTPUT_DIR/progress-state.json"
        ;;

    init-incremental)
        PROJECT="${1:-.}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        # Check for scan result
        if [[ ! -f "$OUTPUT_DIR/scan-result.json" ]]; then
            echo "Error: No scan result found. Run scan-md.sh first."
            exit 1
        fi

        mkdir -p "$OUTPUT_DIR"

        # Load existing progress if available
        if [[ -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "Existing progress found. Checking for new/changed files..."

            if command -v python3 &> /dev/null; then
                python3 -c "
import json
from datetime import datetime

# Load scan result
with open('$OUTPUT_DIR/scan-result.json', 'r') as f:
    scanned_files = {s['path']: s for s in json.load(f)}

# Load existing progress
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)

existing_files = {f['path']: f for f in state['files']}

# Find new and changed files
new_files = []
changed_files = []

for path, scan_data in scanned_files.items():
    if path not in existing_files:
        new_files.append(scan_data)
    elif existing_files[path]['hash'] != scan_data['hash']:
        changed_files.append(scan_data)

# Update state
for f in new_files:
    state['files'].append({
        'path': f['path'],
        'wordCount': f['wordCount'],
        'hash': f['hash'],
        'status': 'pending',
        'startedAt': None,
        'completedAt': None,
        'error': None
    })

for f in changed_files:
    for ef in state['files']:
        if ef['path'] == f['path']:
            ef['hash'] = f['hash']
            ef['status'] = 'pending'
            ef['error'] = None
            break

# Update statistics
state['statistics']['total'] = len(state['files'])
state['statistics']['pending'] = sum(1 for f in state['files'] if f['status'] == 'pending')
state['updatedAt'] = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
state['mode'] = 'incremental'

with open('$OUTPUT_DIR/progress-state.json', 'w') as f:
    json.dump(state, f, indent=2)

print(f'Found {len(new_files)} new files and {len(changed_files)} changed files')
print(f'Total pending: {state[\"statistics\"][\"pending\"]}')
"
            else
                echo "Error: Python3 required for incremental mode"
                exit 1
            fi
        else
            # No existing progress, do full init
            echo "No existing progress found. Running full initialization..."
            bash "$0" init "$PROJECT"
        fi
        ;;

    next)
        PROJECT="${1:-.}"
        COUNT="${2:-5}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "Error: Progress state not found. Run 'init' first."
            exit 1
        fi

        # Get next pending files
        if command -v jq &> /dev/null; then
            jq -r --argjson count "$COUNT" \
                '.files | map(select(.status == "pending")) | sort_by(.wordCount) | .[:$count] | .[].path' \
                "$OUTPUT_DIR/progress-state.json"
        else
            python3 -c "
import json
count = $COUNT
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)
pending = sorted([f for f in state['files'] if f['status'] == 'pending'], key=lambda x: x['wordCount'])[:count]
for f in pending:
    print(f['path'])
"
        fi
        ;;

    start)
        PROJECT="${1:-.}"
        FILE="$2"
        OUTPUT_DIR="docs/code-translate"

        if [[ -z "$FILE" ]]; then
            echo "Error: File path required"
            exit 1
        fi

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "Error: Progress state not found"
            exit 1
        fi

        # Mark file as in progress
        if command -v jq &> /dev/null; then
            timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
            jq --arg file "$FILE" \
               --arg ts "$timestamp" \
               '(.files[] | select(.path == $file)) |= (
                   .status = "in_progress",
                   .startedAt = $ts
               ) |
               .statistics.inProgress = ([.files[] | select(.status == "in_progress")] | length) |
               .statistics.pending = ([.files[] | select(.status == "pending")] | length) |
               .updatedAt = "'"$timestamp"'"' \
               "$OUTPUT_DIR/progress-state.json" > "$OUTPUT_DIR/progress-state.tmp.json"
            mv "$OUTPUT_DIR/progress-state.tmp.json" "$OUTPUT_DIR/progress-state.json"
        else
            python3 -c "
import json
from datetime import datetime
file_path = '$FILE'
timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)
for f in state['files']:
    if f['path'] == file_path:
        f['status'] = 'in_progress'
        f['startedAt'] = timestamp
        break
state['statistics']['inProgress'] = sum(1 for f in state['files'] if f['status'] == 'in_progress')
state['statistics']['pending'] = sum(1 for f in state['files'] if f['status'] == 'pending')
state['updatedAt'] = timestamp
with open('$OUTPUT_DIR/progress-state.json', 'w') as f:
    json.dump(state, f, indent=2)
"
        fi
        echo "Started: $FILE"
        ;;

    complete)
        PROJECT="${1:-.}"
        FILE="$2"
        OUTPUT_DIR="docs/code-translate"

        if [[ -z "$FILE" ]]; then
            echo "Error: File path required"
            exit 1
        fi

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "Error: Progress state not found"
            exit 1
        fi

        # Mark file as completed
        if command -v jq &> /dev/null; then
            timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
            jq --arg file "$FILE" \
               --arg ts "$timestamp" \
               '(.files[] | select(.path == $file)) |= (
                   .status = "completed",
                   .completedAt = $ts
               ) |
               .statistics.completed = ([.files[] | select(.status == "completed")] | length) |
               .statistics.inProgress = ([.files[] | select(.status == "in_progress")] | length) |
               .updatedAt = "'"$timestamp"'"' \
               "$OUTPUT_DIR/progress-state.json" > "$OUTPUT_DIR/progress-state.tmp.json"
            mv "$OUTPUT_DIR/progress-state.tmp.json" "$OUTPUT_DIR/progress-state.json"
        else
            python3 -c "
import json
from datetime import datetime
file_path = '$FILE'
timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)
for f in state['files']:
    if f['path'] == file_path:
        f['status'] = 'completed'
        f['completedAt'] = timestamp
        break
state['statistics']['completed'] = sum(1 for f in state['files'] if f['status'] == 'completed')
state['statistics']['inProgress'] = sum(1 for f in state['files'] if f['status'] == 'in_progress')
state['updatedAt'] = timestamp
with open('$OUTPUT_DIR/progress-state.json', 'w') as f:
    json.dump(state, f, indent=2)
"
        fi
        echo "Completed: $FILE"
        ;;

    fail)
        PROJECT="${1:-.}"
        FILE="$2"
        REASON="${3:-Unknown error}"
        OUTPUT_DIR="docs/code-translate"

        if [[ -z "$FILE" ]]; then
            echo "Error: File path required"
            exit 1
        fi

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "Error: Progress state not found"
            exit 1
        fi

        # Mark file as failed
        if command -v jq &> /dev/null; then
            timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
            jq --arg file "$FILE" \
               --arg reason "$REASON" \
               --arg ts "$timestamp" \
               '(.files[] | select(.path == $file)) |= (
                   .status = "failed",
                   .error = $reason
               ) |
               .statistics.failed = ([.files[] | select(.status == "failed")] | length) |
               .statistics.inProgress = ([.files[] | select(.status == "in_progress")] | length) |
               .updatedAt = "'"$timestamp"'"' \
               "$OUTPUT_DIR/progress-state.json" > "$OUTPUT_DIR/progress-state.tmp.json"
            mv "$OUTPUT_DIR/progress-state.tmp.json" "$OUTPUT_DIR/progress-state.json"
        else
            python3 -c "
import json
from datetime import datetime
file_path = '$FILE'
reason = '''$REASON'''
timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)
for f in state['files']:
    if f['path'] == file_path:
        f['status'] = 'failed'
        f['error'] = reason
        break
state['statistics']['failed'] = sum(1 for f in state['files'] if f['status'] == 'failed')
state['statistics']['inProgress'] = sum(1 for f in state['files'] if f['status'] == 'in_progress')
state['updatedAt'] = timestamp
with open('$OUTPUT_DIR/progress-state.json', 'w') as f:
    json.dump(state, f, indent=2)
"
        fi
        echo "Failed: $FILE - $REASON"
        ;;

    status)
        PROJECT="${1:-.}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "No progress state found. Run 'init' first."
            exit 0
        fi

        # Display status
        if command -v jq &> /dev/null; then
            stats=$(jq -r '.statistics' "$OUTPUT_DIR/progress-state.json")
            total=$(echo "$stats" | jq -r '.total')
            completed=$(echo "$stats" | jq -r '.completed')
            in_progress=$(echo "$stats" | jq -r '.inProgress')
            pending=$(echo "$stats" | jq -r '.pending')
            failed=$(echo "$stats" | jq -r '.failed')

            percent=0
            if [[ "$total" -gt 0 ]]; then
                percent=$((completed * 100 / total))
            fi

            echo "=========================================="
            echo "Translation Progress"
            echo "=========================================="
            echo "Total:       $total"
            echo "Completed:   $completed ($percent%)"
            echo "In Progress: $in_progress"
            echo "Pending:     $pending"
            echo "Failed:      $failed"
            echo "=========================================="

            if [[ "$failed" -gt 0 ]]; then
                echo ""
                echo "Failed files:"
                jq -r '.files[] | select(.status == "failed") | "  - \(.path): \(.error)"' "$OUTPUT_DIR/progress-state.json"
            fi
        else
            python3 -c "
import json
with open('$OUTPUT_DIR/progress-state.json', 'r') as f:
    state = json.load(f)
stats = state['statistics']
total = stats['total']
completed = stats['completed']
percent = (completed * 100 // total) if total > 0 else 0
print('==========================================')
print('Translation Progress')
print('==========================================')
print(f'Total:       {total}')
print(f'Completed:   {completed} ({percent}%)')
print(f'In Progress: {stats[\"inProgress\"]}')
print(f'Pending:     {stats[\"pending\"]}')
print(f'Failed:      {stats[\"failed\"]}')
print('==========================================')
if stats['failed'] > 0:
    print()
    print('Failed files:')
    for f in state['files']:
        if f['status'] == 'failed':
            print(f'  - {f[\"path\"]}: {f[\"error\"]}')
"
        fi
        ;;

    reset)
        PROJECT="${1:-.}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ -f "$OUTPUT_DIR/progress-state.json" ]]; then
            rm "$OUTPUT_DIR/progress-state.json"
            echo "Progress state reset"
        fi
        ;;

    checkpoint)
        PROJECT="${1:-.}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
            echo "No progress state to checkpoint"
            exit 0
        fi

        # Create checkpoint copy
        timestamp=$(date +"%Y%m%d_%H%M%S")
        cp "$OUTPUT_DIR/progress-state.json" "$OUTPUT_DIR/checkpoint-$timestamp.json"
        echo "Checkpoint saved: checkpoint-$timestamp.json"
        ;;

    filter)
        PROJECT="${1:-.}"
        bash "$SCRIPT_DIR/filter-files.sh" "$PROJECT"
        ;;

    batch)
        PROJECT="${1:-.}"
        shift || true
        bash "$SCRIPT_DIR/batch-translate.sh" "$PROJECT" "$@"
        ;;

    sync-dirs)
        PROJECT="${1:-.}"
        OUTPUT_DIR="docs/code-translate"

        if [[ "$PROJECT" != /* ]]; then
            PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || PROJECT="$(pwd)/$PROJECT"
        fi

        cd "$PROJECT" 2>/dev/null || {
            echo "Error: Project directory not found: $PROJECT"
            exit 1
        }

        echo "Syncing directory structure to output..."

        # Find all directories containing .md files and recreate them in output
        if command -v python3 &> /dev/null; then
            python3 -c "
import os
import shutil

project_path = '$PROJECT'
output_dir = os.path.join(project_path, '$OUTPUT_DIR')

# Find all directories containing .md files
md_dirs = set()
for root, dirs, files in os.walk(project_path):
    # Skip excluded directories
    dirs[:] = [d for d in dirs if d not in {
        'node_modules', 'vendor', 'dist', 'build', 'out', 'target',
        'bin', 'obj', '.next', '.nuxt', '.output', '__pycache__',
        '.cache', '.git', '.svn', '.hg', '.idea', '.vscode', '.claude',
        'code-translate', 'annotation'
    } and not d.startswith('.')]

    # Skip output directory itself
    if root.startswith(output_dir):
        continue

    # Check if this directory contains .md files (directly or indirectly)
    has_md = any(f.endswith('.md') or f.endswith('.mdx') for f in files)
    if has_md:
        rel_dir = os.path.relpath(root, project_path)
        md_dirs.add(rel_dir)

    # Also check subdirectories
    for d in dirs:
        subdir = os.path.join(root, d)
        for subroot, subdirs, subfiles in os.walk(subdir):
            if any(f.endswith('.md') or f.endswith('.mdx') for f in subfiles):
                rel_dir = os.path.relpath(root, project_path)
                md_dirs.add(rel_dir)
                break

# Create directories in output
for rel_dir in md_dirs:
    target_dir = os.path.join(output_dir, rel_dir)
    if not os.path.exists(target_dir):
        os.makedirs(target_dir, exist_ok=True)
        print(f'Created: {rel_dir}')

print(f'Synced {len(md_dirs)} directories')
"
        else
            # Fallback using find
            find . -type f \( -name '*.md' -o -name '*.mdx' \) \
                -not -path "*/node_modules/*" \
                -not -path "*/$OUTPUT_DIR/*" \
                -not -path '*/.git/*' \
                2>/dev/null | while read -r file; do
                dir=$(dirname "$file")
                target_dir="$OUTPUT_DIR/$dir"
                if [[ ! -d "$target_dir" ]]; then
                    mkdir -p "$target_dir"
                    echo "Created: $dir"
                fi
            done
            echo "Directory sync complete"
        fi
        ;;

    help|--help|-h)
        echo "Usage: $0 <command> <project> [args...]"
        echo ""
        echo "Commands:"
        echo "  init <project>                    Initialize progress tracking"
        echo "  init-incremental <project>        Initialize for incremental translation"
        echo "  filter <project>                  Filter translated files (auto-mark as completed)"
        echo "  batch <project> [--max-agents=N]  Run batch translation with concurrency control"
        echo "  next <project> [count=5]          Get next batch of pending files"
        echo "  start <project> <file>            Mark file as in progress"
        echo "  complete <project> <file>         Mark file as completed"
        echo "  fail <project> <file> [reason]    Mark file as failed"
        echo "  status <project>                  Show progress status"
        echo "  reset <project>                   Reset all progress"
        echo "  checkpoint <project>              Save checkpoint"
        echo "  sync-dirs <project>               Sync directory structure to output"
        ;;

    *)
        echo "Unknown command: $COMMAND"
        echo "Run '$0 help' for usage"
        exit 1
        ;;
esac
