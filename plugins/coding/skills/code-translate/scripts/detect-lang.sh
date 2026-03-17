#!/bin/bash
# detect-lang.sh - Detect language of a markdown file based on path and content
# Usage: ./detect-lang.sh <file_path>
# Output: english | translated | unknown

set -e

FILE_PATH="${1:-}"

if [[ -z "$FILE_PATH" ]]; then
    echo "Error: File path required" >&2
    echo "Usage: $0 <file_path>" >&2
    exit 1
fi

# Language patterns in file paths (case insensitive)
TRANSLATED_PATTERNS=(
    # Chinese
    'zh-cn' 'zh_CN' 'zh-tw' 'zh_TW' 'zh-hans' 'zh-hant'
    # Japanese
    'ja-jp' 'ja_JP' 'ja'
    # Korean
    'ko-kr' 'ko_KR' 'ko'
    # Other common locale patterns
    'i18n' 'locales' 'translations' 'l10n'
    # Language-specific file suffixes
    '.zh.' '.ja.' '.ko.' '.de.' '.fr.' '.es.' '.ru.'
)

# Check if path contains translated patterns
check_path_patterns() {
    local path="$1"
    local lower_path=$(echo "$path" | tr '[:upper:]' '[:lower:]')

    for pattern in "${TRANSLATED_PATTERNS[@]}"; do
        if [[ "$lower_path" == *"$pattern"* ]]; then
            return 0  # Found translated pattern
        fi
    done
    return 1  # No pattern found
}

# Check for Chinese content indicators
check_chinese_content() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Sample first 1000 chars to detect Chinese characters
    local sample=$(head -c 1000 "$file" 2>/dev/null || cat "$file" 2>/dev/null | head -c 1000)

    # Count Chinese characters (CJK Unified Ideographs range)
    local chinese_chars=$(echo "$sample" | grep -oP '[\x{4e00}-\x{9fff}]' 2>/dev/null | wc -l || echo "0")

    # If more than 5 Chinese characters, likely translated content
    if [[ "$chinese_chars" -gt 5 ]]; then
        return 0
    fi

    return 1
}

# Check for Japanese content indicators
check_japanese_content() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    local sample=$(head -c 1000 "$file" 2>/dev/null || cat "$file" 2>/dev/null | head -c 1000)

    # Count Hiragana characters
    local hiragana=$(echo "$sample" | grep -oP '[\x{3040}-\x{309f}]' 2>/dev/null | wc -l || echo "0")
    # Count Katakana characters
    local katakana=$(echo "$sample" | grep -oP '[\x{30a0}-\x{30ff}]' 2>/dev/null | wc -l || echo "0")

    # If more than 5 Japanese characters, likely Japanese content
    if [[ $((hiragana + katakana)) -gt 5 ]]; then
        return 0
    fi

    return 1
}

# Check for Korean content indicators
check_korean_content() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    local sample=$(head -c 1000 "$file" 2>/dev/null || cat "$file" 2>/dev/null | head -c 1000)

    # Count Korean Hangul characters
    local korean_chars=$(echo "$sample" | grep -oP '[\x{ac00}-\x{d7af}]' 2>/dev/null | wc -l || echo "0")

    # If more than 5 Korean characters, likely Korean content
    if [[ "$korean_chars" -gt 5 ]]; then
        return 0
    fi

    return 1
}

# Check for clear English indicators
check_english_content() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    local sample=$(head -c 2000 "$file" 2>/dev/null || cat "$file" 2>/dev/null | head -c 2000)

    # Count common English words
    local english_words=$(echo "$sample" | grep -oiE '\b(the|and|for|are|with|this|that|you|your|our|will|can|have|has|from|they|we|it|is|are|to|of|in|on|at|by|as|be|or|if|an|not|but|what|all|when|where|who|how|why|which|their|there|them|then|than|also|use|using|used|example|create|make|add|get|set|call|function|method|class|file|code|project|application|system|data|user|server|client|api|web|app|development|developer|programming|software|hardware|computer|technology|interface|implementation|configuration|documentation|reference|guide|tutorial|introduction|overview|getting started|installation|setup|requirements|support|help|information|please|note|important|warning|caution|tip|see|read|learn|understand|know|need|want|should|must|may|might|could|would|should)\b' 2>/dev/null | wc -l || echo "0")

    # If many common English words found, likely English content
    if [[ "$english_words" -gt 10 ]]; then
        return 0
    fi

    return 1
}

# Main detection logic
detect_language() {
    local path="$1"

    # First check path patterns (fastest)
    if check_path_patterns "$path"; then
        echo "translated"
        return 0
    fi

    # If file exists, check content
    if [[ -f "$path" ]]; then
        # Check for Asian language content first
        if check_chinese_content "$path" || check_japanese_content "$path" || check_korean_content "$path"; then
            echo "translated"
            return 0
        fi

        # Check for English content
        if check_english_content "$path"; then
            echo "english"
            return 0
        fi
    fi

    # If no clear indicators, check path for English-only indicators
    local lower_path=$(echo "$path" | tr '[:upper:]' '[:lower:]')

    # If file is in root or typical English doc paths without locale markers
    if [[ ! "$lower_path" =~ (zh|ja|ko|de|fr|es|ru|i18n|locales|translations) ]]; then
        echo "english"
        return 0
    fi

    echo "unknown"
}

# Output detailed info if --verbose flag is used
if [[ "${2:-}" == "--verbose" ]]; then
    echo "File: $FILE_PATH"
    echo "Detected: $(detect_language "$FILE_PATH")"

    if [[ -f "$FILE_PATH" ]]; then
        echo ""
        echo "Content analysis:"
        if check_chinese_content "$FILE_PATH"; then
            echo "  - Chinese characters detected"
        fi
        if check_japanese_content "$FILE_PATH"; then
            echo "  - Japanese characters detected"
        fi
        if check_korean_content "$FILE_PATH"; then
            echo "  - Korean characters detected"
        fi
        if check_english_content "$FILE_PATH"; then
            echo "  - English content detected"
        fi
    fi
else
    # Standard output - just the result
    detect_language "$FILE_PATH"
fi
