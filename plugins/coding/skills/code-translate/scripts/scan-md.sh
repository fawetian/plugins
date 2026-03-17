#!/bin/bash
# scan-md.sh - Scan markdown files and generate structured metadata
# Usage: ./scan-md.sh <project_path> [output_dir]

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

# Parse arguments
PROJECT_PATH="${1:-.}"
OUTPUT_DIR="${2:-docs/code-translate}"

# Resolve absolute paths
if [[ "$PROJECT_PATH" != /* ]]; then
    PROJECT_PATH="$(pwd)/$PROJECT_PATH"
fi

if [[ "$OUTPUT_DIR" != /* ]]; then
    OUTPUT_DIR="$(pwd)/$OUTPUT_DIR"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Temporary files
TEMP_SCAN=$(mktemp)
trap "rm -f $TEMP_SCAN" EXIT

# Exclusion patterns - directories to skip
EXCLUDE_DIRS=(
    "node_modules"
    "vendor"
    "dist"
    "build"
    "out"
    "target"
    "bin"
    "obj"
    ".next"
    ".nuxt"
    ".output"
    "__pycache__"
    ".cache"
    "packages"
    "pkg"
    ".git"
    ".svn"
    ".hg"
    ".idea"
    ".vscode"
    ".claude"
    "code-translate"
    "node_modules"
)

# Calculate file hash (first 8 chars of MD5)
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

# Detect language from file path
detect_language() {
    local path="$1"
    local lower_path=$(echo "$path" | tr '[:upper:]' '[:lower:]')

    # Check for translated patterns
    if [[ "$lower_path" =~ (zh-cn|zh_cn|zh-tw|zh_tw|zh-hans|zh-hant|ja-jp|ja_jp|ko-kr|ko_kr|ja/|ko/|i18n|locales|translations) ]]; then
        echo "translated"
        return 0
    fi

    # Check for language-specific file suffixes
    if [[ "$lower_path" =~ \.(zh|ja|ko|de|fr|es|ru)\.(md|mdx)$ ]]; then
        echo "translated"
        return 0
    fi

    echo "english"
}

# Count words in markdown file
# Simple word count: count non-empty lines and estimate words
count_words() {
    local file="$1"
    # Use wc -w for word count, fallback to counting lines if file is empty
    local words=$(wc -w < "$file" 2>/dev/null | tr -d ' ')
    echo "${words:-0}"
}

# Build find exclude arguments
build_find_excludes() {
    local args=""
    for dir in "${EXCLUDE_DIRS[@]}"; do
        args="$args -not -path '*/$dir/*'"
    done
    echo "$args"
}

echo "Scanning project for markdown files: $PROJECT_PATH"
echo "Output directory: $OUTPUT_DIR"

# Find all markdown files
cd "$PROJECT_PATH"

# Build exclude pattern
EXCLUDE_PATTERN=$(build_find_excludes)

# Find markdown files with exclusions
eval "find . -type f \( -name '*.md' -o -name '*.mdx' \) \
    $EXCLUDE_PATTERN \
    2>/dev/null | sort" > "$TEMP_SCAN"

# Start JSON array
echo "[" > "$OUTPUT_DIR/scan-result.json"

first=true
total_files=0
total_words=0

while IFS= read -r file; do
    # Remove leading ./
    rel_path="${file#./}"

    # Skip if empty
    [[ -z "$rel_path" ]] && continue

    # Skip output directory itself
    if [[ "$rel_path" == docs/code-translate/* ]]; then
        continue
    fi

    # Get word count
    words=$(count_words "$rel_path")

    # Get hash
    hash=$(calc_hash "$rel_path")

    # Detect language from path
    lang=$(detect_language "$rel_path")

    # Update totals
    ((total_files++))
    ((total_words+=words))

    # Write JSON entry
    if [[ "$first" == "true" ]]; then
        first=false
    else
        echo "," >> "$OUTPUT_DIR/scan-result.json"
    fi

    cat >> "$OUTPUT_DIR/scan-result.json" << EOF
  {
    "path": "$rel_path",
    "wordCount": $words,
    "hash": "$hash",
    "detectedLang": "$lang"
  }
EOF

done < "$TEMP_SCAN"

# Close JSON array
echo "" >> "$OUTPUT_DIR/scan-result.json"
echo "]" >> "$OUTPUT_DIR/scan-result.json"

# Generate summary
cat > "$OUTPUT_DIR/scan-summary.json" << EOF
{
  "projectPath": "$PROJECT_PATH",
  "scanTime": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "totalFiles": $total_files,
  "totalWords": $total_words,
  "outputFile": "scan-result.json"
}
EOF

echo ""
echo "=========================================="
echo "Scan Complete"
echo "=========================================="
echo "Total files: $total_files"
echo "Total words: $total_words"
echo "Output: $OUTPUT_DIR/scan-result.json"
echo "Summary: $OUTPUT_DIR/scan-summary.json"
