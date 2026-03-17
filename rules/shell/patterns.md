---
paths:
  - "**/*.sh"
  - "**/*.bash"
  - "**/*.zsh"
---
# Shell Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Shell specific content.

## Error Handling

### Trap Signals

Clean up on script exit:

```bash
cleanup() {
    rm -rf "$temp_dir"
}
trap cleanup EXIT

trap 'echo "Error on line $LINENO" >&2' ERR
```

### Command Results

Always check exit codes:

```bash
if command; then
    echo "Success"
else
    echo "Failed with exit code $?" >&2
    exit 1
fi
```

## Logging

Use consistent logging levels:

```bash
log_info() { echo "[INFO] $*"; }
log_warn() { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_debug() { [[ "${DEBUG:-}" ]] && echo "[DEBUG] $*" >&2; }
```

## Temporary Files

Create secure temporary files:

```bash
# Good: mktemp is secure and portable
temp_file=$(mktemp)
temp_dir=$(mktemp -d)

# Cleanup on exit
trap 'rm -rf "$temp_file" "$temp_dir"' EXIT
```

## Configuration Management

Source configuration files safely:

```bash
load_config() {
    local config_file="$1"
    if [[ -f "$config_file" ]]; then
        # shellcheck source=/dev/null
        source "$config_file"
    fi
}
```

## Path Handling

Get script directory reliably:

```bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

## String Manipulation

Use parameter expansion:

```bash
name="file.txt"
base="${name%.txt}"      # Remove suffix: "file"
ext="${name##*.}"       # Get extension: "txt"
length="${#name}"        # String length
default="${unset:-default}"  # Default value
```

## Array Usage

Prefer arrays over string concatenation:

```bash
# Good: array
cmd=("docker" "run" "-it" "--rm" "myimage")
"${cmd[@]}"

# Bad: string concatenation
cmd="docker run -it --rm myimage"
$cmd  # Word splitting issues
```

## Reference

See skill: `shell-patterns` for comprehensive shell scripting idioms and patterns.
