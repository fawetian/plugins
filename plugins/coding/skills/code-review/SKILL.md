---
name: code-review
description: Automated code review for pull requests or local changes using multiple specialized agents with confidence-based scoring. Use when user asks for /code-review, wants to review a PR, or review local uncommitted changes.
source: https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review
---

# Code Review

Use this skill when the user asks for /code-review, wants an automated PR review, or wants to review local uncommitted changes.

## Mode Detection

First determine the review mode:
- **PR mode**: User provides a PR number, URL, or explicitly asks to review a PR
- **Local mode**: User asks to review local changes, uncommitted changes, staged changes, or no PR is specified

## Workflow

### Step 1: Collect Changes

**PR Mode:**
1. Eligibility check:
   - Skip if the PR is closed, draft, trivial or automated, or already reviewed by you.
2. Get PR diff using `gh pr diff`

**Local Mode:**
1. Check for changes:
   - Use `git status` to see what's changed
   - Use `git diff HEAD` for all uncommitted changes (staged + unstaged)
   - If no changes found, inform user and exit
2. Collect affected file paths for CLAUDE.md lookup

### Step 2: Collect Guidance

Return paths to relevant CLAUDE.md files: the root CLAUDE.md plus any CLAUDE.md in directories touched by the changes.

### Step 3: Summarize the Change

### Step 4: Independent Reviews (5 parallel agents)

Each agent returns issues plus rationale:
- Agent 1: CLAUDE.md compliance.
- Agent 2: obvious bugs in the diff only (avoid extra context).
- Agent 3: git blame or history context.
- Agent 4: prior PRs/commits touching these files (use `git log` for local mode).
- Agent 5: code comments in modified files.

### Step 5: Confidence Scoring

Score each issue 0-100 with this rubric:
- 0: Not confident at all. False positive or pre-existing issue.
- 25: Somewhat confident. Might be real, could be false positive.
- 50: Moderately confident. Real but minor or unlikely.
- 75: Highly confident. Real, important, or explicitly in CLAUDE.md.
- 100: Absolutely certain. Definitely real and frequent.

For CLAUDE.md issues, verify the guidance explicitly calls out the issue.

### Step 6: Filter and Output

Filter out issues with score < 80. Then output results based on mode:

**PR Mode:**
- Re-check eligibility before posting
- Post a brief review comment with `gh`

**Local Mode:**
- Write results to `docs/code-review/{datetime}/review.md` where datetime is in `YYYY-MM-DD_HH-mm-ss` format
- Output a summary to user with the file path

## False positives to avoid

- Pre-existing issues or code outside the PR changes.
- Things that look like bugs but are not.
- Pedantic nitpicks or stylistic issues not called out in CLAUDE.md.
- Issues linters, typecheckers, or CI would catch (imports, formatting, type errors).
- General quality issues unless explicitly required by CLAUDE.md.
- Issues explicitly silenced in the code (lint ignore comments).
- Intentional behavior changes that match the PR goal.

## Notes

- Do not run builds, tests, or typechecks.
- Use `gh` for GitHub interactions (PR mode only).
- Make a todo list first.
- Cite and link each issue.

## Output Format

Use templates from the `templates/` directory:
- **PR Mode**: `templates/pr-comment.md`
- **Local Mode**: `templates/local-review.md`

### Local Mode

Write results to `docs/code-review/{datetime}/review.md` with datetime format `YYYY-MM-DD_HH-mm-ss`.

**Important**: Output content in Chinese (中文).

After writing, output to user:
```
Code review completed. Results saved to: docs/code-review/{datetime}/review.md
```

### PR Mode

Post comment using `gh`. If no issues remain after filtering, do not comment unless asked.

## Link/Reference Format Requirements

**PR Mode:**
- Use the full git SHA.
- Use `#Lstart-Lend` with at least one line of context.
- Use the repo name of the PR being reviewed.

**Local Mode:**
- Use file paths with line numbers in `path:line` or `path:start-end` format.
- Reference the actual line numbers from the diff.
