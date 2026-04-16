# Git Workflow

## Commit Message Format

```
<type>(<scope>): <description>

<optional body>
```

- **scope** is optional, inferred from project directory/module structure
- Attribution disabled globally via ~/.claude/settings.json

### Type List

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

## Commit Behavior

By default, commit all changes from the current session unless specifically instructed otherwise.

## Branch Protection

- Never push directly to `main` or `master`. Switch to a feature branch first.
- For new branches, push with `git push -u origin <branch>`.

## Pull Strategy

Use `git pull --rebase` to maintain linear commit history.
If conflicts occur, resolve manually and run `git rebase --continue`.

## Pull Request Workflow

When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

> For the full development process (planning, TDD, code review) before git operations,
> see [development-workflow.md](./development-workflow.md).
