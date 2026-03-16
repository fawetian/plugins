---
name: git-ops
description: Git shortcuts: ga(add), gc(commit), gp(push), gpl(pull). Triggers: ga, gc, gp, gpl, "commit", "push", "pull", "stage", "add".
userInvocable: true
---

# Git Operation Shortcuts

Streamlined git workflow. Supports four alias commands: `ga`, `gc`, `gp`, `gpl`.

---

## ga — git add

**Usage:**
- `ga` — Stage all changes (`git add .`)
- `ga <file1> <file2> ...` — Stage only specified files

After execution, display `git status` to confirm staging result.

---

## gc — git commit

**Workflow:**

1. Run `git diff --cached` to show staged changes, letting user see what this commit includes.
2. Based on changes and project structure, **auto-infer** suggested type and scope, then **present all suggestions at once** for user confirmation/modification:
   - **type** (show suggestion + type list for reference)
   - **scope** (auto-suggested from project directory/module structure, optional)
   - **description** (required, in Chinese)
   - **body** (required, in Chinese)
3. Assemble into Conventional Commits format, display full commit message for user confirmation.
4. Execute `git commit` after user confirms.

**Commit message format:**

```
<type>(<scope>): <description>

<body, can be multiline>
```

**type list:**

| type | purpose |
|------|---------|
| feat | New feature |
| fix | Bug fix |
| docs | Documentation changes |
| style | Code formatting (no logic changes) |
| refactor | Refactoring (not feature or fix) |
| perf | Performance optimization |
| test | Test related |
| chore | Build/tools/dependencies |
| ci | CI/CD configuration |
| revert | Revert changes |

**Example:**

```
feat(auth): add JWT login functionality

Implemented JWT-based user authentication flow including token generation, validation, and refresh logic.
Need to add configuration for token expiration time.
```

**Note:** If staging area is empty (nothing to commit), prompt user to run `ga` first, do not proceed with commit.

---

## gp — git push

**Workflow:**

1. Check current branch:
   - If `master` or `main`, **refuse to execute**, prompt user to switch to a feature branch before push.
2. Execute `git push`. If remote branch doesn't exist, automatically use `git push --set-upstream origin <branch>`.
3. Display push result.

---

## gpl — git pull

Execute `git pull --rebase` to maintain linear commit history.

If conflicts occur during rebase, prompt user to resolve conflicts and run `git rebase --continue`. Do not auto-resolve conflicts.

---

## General Principles

- Confirm status before each operation, show results after execution. Keep user informed of current git state.
- Never skip user confirmation steps. Do not make arbitrary batch operations.
- Provide clear error messages and next-step suggestions when errors occur.
