# devops

Developer operations toolset — documentation lookup, dead code cleanup, agent harness optimization, and autonomous loop monitoring.

## Install

```bash
/plugin install devops@fawetian-plugins
```

## Agents

This plugin is agents-only (no skills). All 5 agents are available after installation.

| Agent | Purpose | Model |
|-------|---------|-------|
| `doc-updater` | Update codemaps and documentation proactively | haiku |
| `docs-lookup` | Fetch up-to-date library/framework docs via Context7 | sonnet |
| `harness-optimizer` | Analyze and improve agent harness configuration | sonnet |
| `loop-operator` | Monitor autonomous loops and intervene when they stall | sonnet |
| `refactor-cleaner` | Remove dead code and consolidate duplicates | sonnet |

## Usage

Agents are invoked automatically when Claude determines they fit the task, or explicitly:

```
Use the docs-lookup agent to find how to configure Playwright
Use the refactor-cleaner agent to remove dead code in this repo
```

### doc-updater
Updates READMEs, codemaps (`docs/CODEMAPS/*`), and guides after code changes. Invoke proactively at the end of a development session.

### docs-lookup
Answers "how do I use X?" questions by fetching current documentation via the Context7 MCP server. Requires the context7 MCP server to be configured.

### harness-optimizer
Reviews agent harness settings (model choices, tool restrictions, permission modes) and recommends improvements for cost and reliability.

### loop-operator
Monitors long-running autonomous agent loops. Detects stalls, infinite loops, and repeated failures, then intervenes safely.

### refactor-cleaner
Runs dead code analysis tools (knip, depcheck, ts-prune) and removes unused code, duplicate logic, and stale dependencies.
