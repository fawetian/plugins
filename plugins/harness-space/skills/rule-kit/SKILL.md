---
name: rule-kit
description: "Manage harness-space rules in ~/harness-space/rules/. Each file is one rule category. Init, add, list, update, remove, sync, or commit rules that shape AI agent behavior. Triggers: rule, add rule, harness, harness-space, list rules, sync harness, init harness, commit harness, worktree rule, coding style, rule-kit"
userInvocable: true
---

You manage the user's harness-space at ~/harness-space/rules/. Each file in this directory is one rule category — a persistent, domain-scoped rule set that shapes how AI coding agents behave.

**Repository**: https://github.com/fawetian/harness-space

Rules must be synced to both platform user-level instruction files:

- **Claude**: `~/.claude/CLAUDE.md` — via `@` import (e.g. `@~/harness-space/rules/git.md`)
- **Codex**: `~/.codex/AGENTS.md` — content embedded directly, wrapped in HTML comment markers:
  `<!-- harness-space:<name> -->` ... content ... `<!-- /harness-space:<name> -->`

## Operations

Determine the user's intent from their message and execute one of:

### init
1. Check if ~/harness-space exists and is a git repository
2. **Not cloned yet**:
   - Run `git clone https://github.com/fawetian/harness-space.git ~/harness-space`
   - If clone fails: inform the user of the error and stop
   - After clone: report success and show what rule categories exist (if any)
3. **Already cloned**:
   - Run `git -C ~/harness-space pull`
   - Report what changed (new commits) or that it's already up to date
4. Ensure ~/harness-space/rules/ directory exists

### commit
1. Verify ~/harness-space exists and is a git repository — if not, suggest running "init" first
2. Show current git status (`git -C ~/harness-space status --short`)
3. If nothing to commit: inform the user, offer to push if there are unpushed commits
4. Stage all changes (`git -C ~/harness-space add -A`)
5. Commit with a descriptive message based on what changed (e.g. "feat: add git rule", "update: coding-style rule")
6. Push to remote (`git -C ~/harness-space push`)
7. Report success with commit hash

### add
1. Ask the user for the rule category name (kebab-case, e.g. "git", "coding-style") if not provided
2. Collect the rule content from the user's description — ask clarifying questions if needed
3. Write to ~/harness-space/rules/<name>.md (abort if file already exists — suggest "update" instead)
4. **Claude sync**: add the import line `@~/harness-space/rules/<name>.md` to ~/.claude/CLAUDE.md:
   - File does not exist: create it with a "## Harness Space Rules" section containing the import
   - File exists but no "## Harness Space Rules" section: append the section with the import
   - Section exists but missing this import: append the import line (keep imports alphabetically sorted)
   - Import already exists: inform the user, skip
5. **Codex sync**: embed the rule content in ~/.codex/AGENTS.md:
   - File does not exist: create it with a "## Harness Space Rules" section
   - Wrap content with `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->`
   - If markers already exist: inform the user, skip
6. Show the user what was written and the file paths

### list
1. Read all files in ~/harness-space/rules/*.md
2. For each file, show: name, first heading line, Claude import status, Codex embed status
3. If directory is empty, inform the user and suggest adding a rule category

### update
1. Confirm which rule category to update
2. Read the existing file and show current content
3. Collect modification requests from the user
4. Update ~/harness-space/rules/<name>.md in-place
5. **Claude**: no change needed (`@` import path unchanged)
6. **Codex**: update the content within the `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->` block in ~/.codex/AGENTS.md

### remove
1. Confirm which rule category to remove
2. Delete ~/harness-space/rules/<name>.md
3. **Claude**: remove the `@~/harness-space/rules/<name>.md` line from ~/.claude/CLAUDE.md
4. **Codex**: remove the `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->` block from ~/.codex/AGENTS.md
5. If no content remains under "## Harness Space Rules" in either file, remove that section entirely
6. Confirm deletion

### sync
1. Scan ~/harness-space/rules/*.md for all rule category files
2. **Claude sync**:
   - Read ~/.claude/CLAUDE.md and find the "## Harness Space Rules" section
   - Ensure every rule category file has a corresponding `@` import line
   - Remove import lines for files that no longer exist
   - Sort imports alphabetically
3. **Codex sync**:
   - Read ~/.codex/AGENTS.md and find the "## Harness Space Rules" section
   - Ensure every rule category file has a corresponding `<!-- harness-space:<name> -->` block
   - For missing blocks: read the rule file and embed its content
   - For existing blocks: compare embedded content against the current rule file; if different, update the embedded content
   - For orphaned blocks (file no longer exists): remove the block
4. Report all changes made to both platforms

## Constraints

- ALWAYS use ~/harness-space/rules/ as the rule storage directory
- ALWAYS sync to BOTH ~/.claude/CLAUDE.md (`@` import) and ~/.codex/AGENTS.md (embedded content) when adding or removing rule categories
- KEEP entries alphabetically sorted within the "## Harness Space Rules" section in both files
- NEVER modify content outside the "## Harness Space Rules" section in either file
- CREATE ~/harness-space/rules/ directory if it doesn't exist
- CREATE ~/.claude/CLAUDE.md if it doesn't exist
- CREATE ~/.codex/AGENTS.md if it doesn't exist
