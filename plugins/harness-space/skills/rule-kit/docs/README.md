# Harness Space - Rule Kit

## Overview

**harness-space** is a plugin for managing your AI harness engineering workspace at `~/harness-space/`. The `rule-kit` skill helps you continuously iterate your harness-space by adding, listing, updating, removing, and syncing rules that shape AI agent behavior.

### Harness Engineering

Harness engineering is the discipline of designing environments, constraints, and feedback loops that make AI agents reliable — going beyond prompt engineering to create deterministic, persistent rule systems.

## Installation

### Claude Code
```
/plugin install harness-space@fawetian-plugins
```

### Codex
```
codex plugin add harness-space@fawetian-plugins-codex
```

## Usage

Invoke the skill with `/rule-kit` followed by your intent:

| Action | Example |
|--------|---------|
| Init / pull repo | `/rule-kit` → "init harness-space" |
| Add a rule | `/rule-kit` → "add a rule named git: always use wt CLI for worktree ops" |
| List rules | `/rule-kit` → "list all rules" |
| Update a rule | `/rule-kit` → "update git rule: also enforce conventional commits" |
| Remove a rule | `/rule-kit` → "remove git" |
| Sync both platforms | `/rule-kit` → "sync harness-space" |
| Commit & push | `/rule-kit` → "commit harness-space" |

## How It Works

Rules live as markdown files in `~/harness-space/rules/` (one file per domain, e.g. `git.md`, `coding-style.md`).

The harness-space repository is version-controlled on GitHub: https://github.com/fawetian/harness-space

The skill keeps two platform instruction files in sync:

| Platform | File | Mechanism |
|----------|------|-----------|
| Claude | `~/.claude/CLAUDE.md` | `@` import references |
| Codex | `~/.codex/AGENTS.md` | Content embedded with HTML comment markers |

## Harness Space Directory

```
~/harness-space/
├── README.md
├── rules/
│   ├── git.md              # Git-related rules
│   ├── coding-style.md     # Coding conventions
│   └── ...
└── .git/                   # Version controlled
```
