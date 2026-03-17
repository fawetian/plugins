#!/bin/bash
# detect-changes.sh - Detect file changes for incremental annotation
# Usage: ./detect-changes.sh <project_path> [output_dir]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

# Parse arguments
PROJECT_PATH="${1:-.}"
OUTPUT_DIR="${2:-docs/annotation}"

# Resolve absolute paths
if [[ "$PROJECT_PATH" != /* ]]; then
    PROJECT_PATH="$(cd "$PROJECT_PATH" 2>/dev/null && pwd)" || PROJECT_PATH="$(pwd)/$PROJECT_PATH"
fi

if [[ "$OUTPUT_DIR" != /* ]]; then
    OUTPUT_DIR="$PROJECT_PATH/$OUTPUT_DIR"
fi

cd "$PROJECT_PATH" 2>/dev/null || {
    echo "Error: Project directory not found: $PROJECT_PATH"
    exit 1
}

# Check for existing progress state
if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
    echo "Error: No existing progress state found. Use full annotation first."
    exit 1
fi

# Calculate file hash
calc_hash() {
    local file="$1"
    if command -v md5sum &> /dev/null; then
        md5sum "$file" 2>/dev/null | cut -c1-8
    elif command -v md5 &> /dev/null; then
        md5 -q "$file" 2>/dev/null | cut -c1-8
    else
        echo "unknown"
    fi
}

# Export environment variables for Python
export PROJECT_PATH OUTPUT_DIR

# Detect changes using Python (more reliable JSON handling)
python3 << 'PYEOF'
import json
import os
import sys
from datetime import datetime

output_dir = os.environ.get('OUTPUT_DIR', 'docs/annotation')
project_path = os.environ.get('PROJECT_PATH', '.')

# Load existing progress state
state_file = os.path.join(output_dir, 'progress-state.json')
with open(state_file, 'r') as f:
    state = json.load(f)

# Load scan result for new files
scan_file = os.path.join(output_dir, 'scan-result.json')
if not os.path.exists(scan_file):
    print("Error: scan-result.json not found. Run scan-files.sh first.", file=sys.stderr)
    sys.exit(1)

with open(scan_file, 'r') as f:
    current_files = {f['path']: f for f in json.load(f)}

# Build map of existing files from state
existing_files = {f['path']: f for f in state['files']}

new_files = []
changed_files = []
deleted_files = []

# Check for new and changed files
for path, info in current_files.items():
    if path not in existing_files:
        # New file
        new_files.append(path)
    else:
        # Check if hash changed
        old_hash = existing_files[path].get('hash', '')
        new_hash = info.get('hash', '')
        if old_hash != new_hash:
            changed_files.append(path)

# Check for deleted files
for path in existing_files:
    if path not in current_files:
        deleted_files.append(path)

# Determine mode
needs_annotation = len(new_files) + len(changed_files)
if needs_annotation == 0:
    mode = "up_to_date"
elif len(new_files) == 0 and len(changed_files) > 0 and len(deleted_files) == 0:
    mode = "incremental"
else:
    mode = "incremental"

# Update state for incremental processing
timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')

# Add new files to state
for path in new_files:
    info = current_files[path]
    state['files'].append({
        'path': path,
        'language': info['language'],
        'sloc': info['sloc'],
        'complexity': info['complexity'],
        'hash': info['hash'],
        'status': 'pending',
        'startedAt': None,
        'completedAt': None,
        'error': None,
        'isNew': True
    })

# Reset changed files to pending
for path in changed_files:
    for f in state['files']:
        if f['path'] == path:
            f['status'] = 'pending'
            f['hash'] = current_files[path]['hash']
            f['startedAt'] = None
            f['completedAt'] = None
            f['error'] = None
            f['isChanged'] = True
            break

# Update statistics
state['statistics']['total'] = len(state['files'])
state['statistics']['pending'] = sum(1 for f in state['files'] if f['status'] == 'pending')
state['statistics']['completed'] = sum(1 for f in state['files'] if f['status'] == 'completed')
state['statistics']['inProgress'] = sum(1 for f in state['files'] if f['status'] == 'in_progress')
state['statistics']['failed'] = sum(1 for f in state['files'] if f['status'] == 'failed')
state['mode'] = mode
state['updatedAt'] = timestamp

# Save updated state
with open(state_file, 'w') as f:
    json.dump(state, f, indent=2)

# Output changes report
changes = {
    'mode': mode,
    'timestamp': timestamp,
    'newFiles': new_files,
    'changedFiles': changed_files,
    'deletedFiles': deleted_files,
    'needsAnnotation': needs_annotation,
    'statistics': state['statistics']
}

with open(os.path.join(output_dir, 'changes.json'), 'w') as f:
    json.dump(changes, f, indent=2)

# Print summary
print('==========================================')
print('Change Detection Results')
print('==========================================')
print(f'Mode: {mode}')
print(f'New files: {len(new_files)}')
print(f'Changed files: {len(changed_files)}')
print(f'Deleted files: {len(deleted_files)}')
print(f'Files needing annotation: {needs_annotation}')
print('==========================================')

if new_files:
    print('\nNew files:')
    for f in new_files[:10]:
        print(f'  + {f}')
    if len(new_files) > 10:
        print(f'  ... and {len(new_files) - 10} more')

if changed_files:
    print('\nChanged files:')
    for f in changed_files[:10]:
        print(f'  ~ {f}')
    if len(changed_files) > 10:
        print(f'  ... and {len(changed_files) - 10} more')

if mode == 'up_to_date':
    print('\nNo changes detected. All annotations are up to date.')
PYEOF
