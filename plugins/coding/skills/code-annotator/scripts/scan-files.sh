#!/bin/bash
# scan-files.sh - Scan source files and generate structured metadata
# Usage: ./scan-files.sh <project_path> [output_dir]

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

# Parse arguments
PROJECT_PATH="${1:-.}"
OUTPUT_DIR="${2:-docs/annotation}"

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

# Language detection by extension
declare -A LANG_MAP=(
    ["rs"]="rust"
    ["py"]="python"
    ["js"]="javascript"
    ["ts"]="typescript"
    ["tsx"]="typescript"
    ["jsx"]="javascript"
    ["go"]="go"
    ["java"]="java"
    ["kt"]="kotlin"
    ["kts"]="kotlin"
    ["scala"]="scala"
    ["c"]="c"
    ["cpp"]="cpp"
    ["cc"]="cpp"
    ["cxx"]="cpp"
    ["h"]="c"
    ["hpp"]="cpp"
    ["cs"]="csharp"
    ["rb"]="ruby"
    ["php"]="php"
    ["swift"]="swift"
    ["m"]="objective-c"
    ["mm"]="objective-cpp"
    ["sh"]="shell"
    ["bash"]="shell"
    ["zsh"]="shell"
    ["lua"]="lua"
    ["r"]="r"
    ["sql"]="sql"
    ["vue"]="vue"
    ["svelte"]="svelte"
)

# Exclusion patterns
EXCLUDE_PATTERNS=(
    # Test files
    "*_test.*" "*_spec.*" "test_*.*" "*Test.*" "*Spec.*"
    "__tests__" "tests" "test" "spec" "__mocks__"

    # Dependencies and build
    "node_modules" "vendor" "dist" "build" "out" "target" "bin" "obj" "packages"
    ".next" ".nuxt" ".output" "__pycache__" ".cache" "pkg"

    # Config files
    "*.json" "*.yaml" "*.yml" "*.toml" "*.ini" "*.env*" "*.lock"
    "*.config.js" "*.config.ts" "*.rc" "*.config.*"

    # Generated files
    "*.min.js" "*.map" "*.d.ts" "*.log" "package-lock.json" "pnpm-lock.yaml"

    # Documentation and resources
    "*.md" "*.mdx" "*.txt" "*.rst" "*.html"
    "assets" "images" "public" "static" "fonts" "docs"
    "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.ico" "*.webp"
    "*.css" "*.scss" "*.less" "*.sass"

    # Version control and IDE
    ".git" ".svn" ".hg" ".idea" ".vscode" ".claude"

    # Annotation output (avoid recursive scanning)
    "annotation"
)

# Build find exclude arguments
build_exclude_args() {
    local args=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$pattern" == "*"* ]]; then
            # File pattern
            args+=" -not -name '$pattern'"
        else
            # Directory name
            args+=" -not -path '*/$pattern/*'"
        fi
    done
    echo "$args"
}

# Count lines of code (SLOC) - excluding blank lines and comments
count_sloc() {
    local file="$1"
    local ext="${file##*.}"
    local sloc=0

    case "$ext" in
        rs|c|cpp|cc|cxx|h|hpp|cs|java|kt|kts|scala|go|swift|m|mm)
            # C-style languages: exclude // and /* */ comments
            sloc=$(sed '/^\s*$/d; /^\s*\/\//d; /^\s*\/\*/d' "$file" 2>/dev/null | wc -l | tr -d ' ')
            ;;
        py|rb|sh|bash|zsh|lua|r)
            # Script languages: exclude # comments
            sloc=$(sed '/^\s*$/d; /^\s*#/d' "$file" 2>/dev/null | wc -l | tr -d ' ')
            ;;
        js|ts|jsx|tsx|vue|svelte|php)
            # Web languages
            sloc=$(sed '/^\s*$/d; /^\s*\/\//d; /^\s*#/d' "$file" 2>/dev/null | wc -l | tr -d ' ')
            ;;
        *)
            # Default: just exclude blank lines
            sloc=$(sed '/^\s*$/d' "$file" 2>/dev/null | wc -l | tr -d ' ')
            ;;
    esac

    echo "${sloc:-0}"
}

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

# Determine complexity based on SLOC
get_complexity() {
    local sloc="$1"
    if [[ "$sloc" -lt 200 ]]; then
        echo "low"
    elif [[ "$sloc" -lt 1000 ]]; then
        echo "medium"
    elif [[ "$sloc" -lt 3000 ]]; then
        echo "high"
    else
        echo "very_high"
    fi
}

echo "Scanning project: $PROJECT_PATH"
echo "Output directory: $OUTPUT_DIR"

# Build file extensions pattern
EXT_PATTERN="-name \"*.rs\" -o -name \"*.py\" -o -name \"*.js\" -o -name \"*.ts\" -o -name \"*.tsx\" -o -name \"*.jsx\""
EXT_PATTERN="$EXT_PATTERN -o -name \"*.go\" -o -name \"*.java\" -o -name \"*.kt\" -o -name \"*.kts\""
EXT_PATTERN="$EXT_PATTERN -o -name \"*.scala\" -o -name \"*.c\" -o -name \"*.cpp\" -o -name \"*.cc\" -o -name \"*.cxx\""
EXT_PATTERN="$EXT_PATTERN -o -name \"*.h\" -o -name \"*.hpp\" -o -name \"*.cs\" -o -name \"*.rb\""
EXT_PATTERN="$EXT_PATTERN -o -name \"*.php\" -o -name \"*.swift\" -o -name \"*.m\" -o -name \"*.mm\""
EXT_PATTERN="$EXT_PATTERN -o -name \"*.sh\" -o -name \"*.bash\" -o -name \"*.zsh\" -o -name \"*.lua\""
EXT_PATTERN="$EXT_PATTERN -o -name \"*.r\" -o -name \"*.sql\" -o -name \"*.vue\" -o -name \"*.svelte\""

# Find all source files
cd "$PROJECT_PATH"

# Use find with exclusions
eval "find . -type f \( $EXT_PATTERN \) \
    -not -path '*/node_modules/*' \
    -not -path '*/vendor/*' \
    -not -path '*/target/*' \
    -not -path '*/dist/*' \
    -not -path '*/build/*' \
    -not -path '*/out/*' \
    -not -path '*/bin/*' \
    -not -path '*/obj/*' \
    -not -path '*/__pycache__/*' \
    -not -path '*/.git/*' \
    -not -path '*/.idea/*' \
    -not -path '*/.vscode/*' \
    -not -path '*/tests/*' \
    -not -path '*/test/*' \
    -not -path '*/__tests__/*' \
    -not -path '*/spec/*' \
    -not -path '*/docs/annotation/*' \
    -not -name '*_test.*' \
    -not -name '*_spec.*' \
    -not -name 'test_*.*' \
    -not -name '*Test.*' \
    -not -name '*Spec.*' \
    -not -name '*.min.js' \
    -not -name '*.d.ts' \
    -not -name '*.lock' \
    -not -name 'package-lock.json' \
    -not -name 'pnpm-lock.yaml' \
    -not -name '*.config.js' \
    -not -name '*.config.ts' \
    2>/dev/null | sort" > "$TEMP_SCAN"

# Start JSON array
echo "[" > "$OUTPUT_DIR/scan-result.json"

first=true
total_files=0
total_sloc=0

while IFS= read -r file; do
    # Remove leading ./
    rel_path="${file#./}"

    # Skip if empty
    [[ -z "$rel_path" ]] && continue

    # Get file extension and language
    ext="${rel_path##*.}"
    lang="${LANG_MAP[$ext]:-unknown}"

    # Get SLOC
    sloc=$(count_sloc "$rel_path")

    # Get complexity
    complexity=$(get_complexity "$sloc")

    # Get hash
    hash=$(calc_hash "$rel_path")

    # Update totals
    ((total_files++))
    ((total_sloc+=sloc))

    # Write JSON entry
    if [[ "$first" == "true" ]]; then
        first=false
    else
        echo "," >> "$OUTPUT_DIR/scan-result.json"
    fi

    cat >> "$OUTPUT_DIR/scan-result.json" << EOF
  {
    "path": "$rel_path",
    "language": "$lang",
    "sloc": $sloc,
    "complexity": "$complexity",
    "hash": "$hash"
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
  "totalSloc": $total_sloc,
  "outputFile": "scan-result.json"
}
EOF

echo ""
echo "=========================================="
echo "Scan Complete"
echo "=========================================="
echo "Total files: $total_files"
echo "Total SLOC: $total_sloc"
echo "Output: $OUTPUT_DIR/scan-result.json"
echo "Summary: $OUTPUT_DIR/scan-summary.json"
