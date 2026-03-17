---
paths:
  - "**/*.sh"
  - "**/*.bash"
  - "**/*.zsh"
  - "**/*.ksh"
---
# Shell Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Shell specific content.

## POSIX Compliance

- Write POSIX-compliant scripts when possible for maximum portability
- Use `#!/bin/sh` for POSIX scripts, `#!/bin/bash` for Bash-specific features
- Avoid bashisms when targeting `/bin/sh`

## Static Analysis

- **shellcheck** — mandatory for all shell scripts
  ```bash
  shellcheck script.sh
  ```
- Address all shellcheck warnings before committing

## Defensive Programming

Always use strict mode at the start of scripts:

```bash
#!/bin/bash
set -euo pipefail

# -e: Exit immediately if a command exits with non-zero status
# -u: Treat unset variables as an error
# -o pipefail: Return value of a pipeline is the status of the last command to exit with non-zero
```

## Variable Usage

- Always quote variables to prevent word splitting and globbing:
  ```bash
  # Good
  echo "$variable"
  rm -rf "$dir"/*

  # Bad
  echo $variable
  rm -rf $dir/*
  ```

- Use local variables in functions:
  ```bash
  my_function() {
      local var="value"
      # ...
  }
  ```

- Use uppercase for environment variables, lowercase for local variables

## Function Definition

Use explicit function syntax:

```bash
# Good
my_function() {
    echo "Hello"
}

# Avoid (less portable)
function my_function {
    echo "Hello"
}
```

## Error Handling

Check command results explicitly:

```bash
if ! command; then
    echo "Command failed" >&2
    exit 1
fi

# Or using ||
command || { echo "Command failed" >&2; exit 1; }
```

## Reference

See skill: `shell-patterns` for comprehensive shell scripting idioms and patterns.
