#!/bin/bash
# filter-files.sh - Filter scanned files, auto-mark translated files as completed
# Usage: ./filter-files.sh <project_path>
# Output: Creates english-files.json and updates progress-state.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

PROJECT_PATH="${1:-.}"

if [[ "$PROJECT_PATH" != /* ]]; then
    PROJECT_PATH="$(pwd)/$PROJECT_PATH"
fi

OUTPUT_DIR="$PROJECT_PATH/docs/code-translate"

# Check for scan result
if [[ ! -f "$OUTPUT_DIR/scan-result.json" ]]; then
    echo "Error: No scan result found at $OUTPUT_DIR/scan-result.json" >&2
    echo "Run scan-md.sh first." >&2
    exit 1
fi

# Check for detect-lang.sh
if [[ ! -f "$SCRIPT_DIR/detect-lang.sh" ]]; then
    echo "Error: detect-lang.sh not found at $SCRIPT_DIR/detect-lang.sh" >&2
    exit 1
fi

# Check for progress state
if [[ ! -f "$OUTPUT_DIR/progress-state.json" ]]; then
    echo "Error: Progress state not found. Run 'translate-progress.sh init' first." >&2
    exit 1
fi

echo "=========================================="
echo "Language Detection and Filtering"
echo "=========================================="
echo "Project: $PROJECT_PATH"
echo ""

# Create temporary files
TEMP_RESULTS=$(mktemp)
trap "rm -f $TEMP_RESULTS" EXIT

# Statistics counters
total_files=0
english_files=0
translated_files=0
unknown_files=0

# Process each file from scan result
echo "Analyzing files..."

if command -v jq &> /dev/null; then
    # Use jq for JSON processing
    while IFS= read -r entry; do
        path=$(echo "$entry" | jq -r '.path')
        total_files=$((total_files + 1))

        # Detect language
        lang=$(bash "$SCRIPT_DIR/detect-lang.sh" "$PROJECT_PATH/$path")

        case "$lang" in
            english)
                english_files=$((english_files + 1))
                echo "$entry" >> "$TEMP_RESULTS"
                ;;
            translated)
                translated_files=$((translated_files + 1))
                echo "  [SKIP] $path -> already translated"

                # Mark as completed in progress state
                bash "$SCRIPT_DIR/translate-progress.sh" complete "$PROJECT_PATH" "$path" 2>/dev/null || true
                ;;
            unknown)
                unknown_files=$((unknown_files + 1))
                # Default to english for unknown
                echo "$entry" >> "$TEMP_RESULTS"
                ;;
        esac
    done < <(jq -c '.[]' "$OUTPUT_DIR/scan-result.json")
else
    # Fallback to Python
    python3 -c "
import json
import subprocess
import os

script_dir = '$SCRIPT_DIR'
project_path = '$PROJECT_PATH'
output_dir = '$OUTPUT_DIR'

# Load scan result
with open(os.path.join(output_dir, 'scan-result.json'), 'r') as f:
    files = json.load(f)

english_files = []
translated_paths = []
unknown_files = []

for entry in files:
    path = entry['path']
    full_path = os.path.join(project_path, path)

    # Run detect-lang.sh
    result = subprocess.run(
        ['bash', os.path.join(script_dir, 'detect-lang.sh'), full_path],
        capture_output=True, text=True
    )
    lang = result.stdout.strip()

    if lang == 'english':
        english_files.append(entry)
    elif lang == 'translated':
        translated_paths.append(path)
        print(f'  [SKIP] {path} -> already translated')
        # Mark as completed
        subprocess.run(
            ['bash', os.path.join(script_dir, 'translate-progress.sh'), 'complete', project_path, path],
            capture_output=True
        )
    else:
        unknown_files.append(entry)

# Write english files
with open('$TEMP_RESULTS', 'w') as f:
    for entry in english_files + unknown_files:
        f.write(json.dumps(entry) + '\n')

# Print stats
print(f'TOTAL:{len(files)}')
print(f'ENGLISH:{len(english_files)}')
print(f'TRANSLATED:{len(translated_paths)}')
print(f'UNKNOWN:{len(unknown_files)}')
"

    # Parse stats from Python output
    stats=$(python3 -c "
import json
import subprocess
import os

script_dir = '$SCRIPT_DIR'
project_path = '$PROJECT_PATH'
output_dir = '$OUTPUT_DIR'

with open(os.path.join(output_dir, 'scan-result.json'), 'r') as f:
    files = json.load(f)

total = len(files)
english = 0
translated = 0
unknown = 0

for entry in files:
    path = entry['path']
    full_path = os.path.join(project_path, path)
    result = subprocess.run(
        ['bash', os.path.join(script_dir, 'detect-lang.sh'), full_path],
        capture_output=True, text=True
    )
    lang = result.stdout.strip()
    if lang == 'english':
        english += 1
    elif lang == 'translated':
        translated += 1
    else:
        unknown += 1

print(f'{total}|{english}|{translated}|{unknown}')
")
    IFS='|' read -r total_files english_files translated_files unknown_files <<< "$stats"
fi

# Build english-files.json from temp results
if command -v jq &> /dev/null; then
    # Convert line-delimited JSON to array
    jq -s '.' "$TEMP_RESULTS" > "$OUTPUT_DIR/english-files.json"
else
    python3 -c "
import json

files = []
with open('$TEMP_RESULTS', 'r') as f:
    for line in f:
        if line.strip():
            files.append(json.loads(line))

with open('$OUTPUT_DIR/english-files.json', 'w') as f:
    json.dump(files, f, indent=2)
"
fi

echo ""
echo "=========================================="
echo "Filtering Complete"
echo "=========================================="
echo "Total files scanned:    $total_files"
echo "English files:          $english_files"
echo "Already translated:     $translated_files"
echo "Unknown (as English):   $unknown_files"
echo "=========================================="
echo ""
echo "Output files:"
echo "  - $OUTPUT_DIR/english-files.json"
echo "  - $OUTPUT_DIR/progress-state.json (updated)"
