# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

[中文版本](./CLAUDE_CN.md)

## Project Overview

Claude Code Plugins Marketplace - a collection of plugins distributed via GitHub marketplace.

## Architecture

```
plugins/
├── .claude-plugin/
│   └── marketplace.json    # Marketplace manifest (pluginRoot points to ./plugins)
└── plugins/                # Each subdirectory is a standalone plugin
    └── {plugin-name}/
        ├── .claude-plugin/
        │   └── plugin.json # Plugin manifest (skills array references skill directories)
        ├── agents/         # Agent definitions (optional)
        │   └── {agent}.md  # Agent with YAML frontmatter
        ├── skills/         # Skill definitions
        │   └── {skill}/
        │       ├── SKILL.md
        │       └── docs/
        │           └── SKILL_CN.md
        └── evals/          # Skill evaluation tests
            └── evals.json
```

## Skill Conventions

1. **SKILL.md in English** - AI loads and executes this file; English avoids context pollution
2. **docs/SKILL_CN.md in Chinese** - Independent file, not loaded by plugin system, for human reference
3. **Keep both versions in sync** - Same content, different languages, update both on every change

## Before Adding New Skills/Plugins/Agents

**Read the official documentation first** to understand the specifications:
- Plugins: https://code.claude.com/docs/en/plugins
- Skills: https://code.claude.com/docs/en/skills
- Agents: https://code.claude.com/docs/en/sub-agents
- Marketplaces: https://code.claude.com/docs/en/plugin-marketplaces

## Key Conventions

- **Marketplace ID**: `fawetian-plugins`
- **Install command**: `/plugin install {plugin-name}@fawetian-plugins`
- **Skills**: Use YAML frontmatter with `name` and `description` fields for triggering
- **Commit format**: Conventional Commits with Chinese descriptions (for git-ops plugin)
- **Documentation**: Always update both English and Chinese versions when modifying any documentation files
- **Version Bumping**: When modifying skill content, MUST bump plugin version in `plugin.json`:
  - `PATCH` (1.0.x): Bug fixes, minor skill content tweaks
  - `MINOR` (1.x.0): New skills, new features, significant skill changes
  - `MAJOR` (x.0.0): Breaking changes, major restructure
  - This is required for Claude Code to detect plugin updates via `/plugin update`

## Adding New Plugins

1. Create directory under `plugins/`
2. Add `.claude-plugin/plugin.json` with name, version, description, skills array
3. Create skill files in `skills/` with YAML frontmatter
4. Register plugin in `marketplace.json` plugins array

## Agent Conventions

1. **Agent file naming** - Use lowercase with hyphens: `{agent-name}.md`
2. **YAML frontmatter required** - Must include `name` and `description` fields
3. **Clear description** - Claude uses description to decide when to delegate tasks
4. **Model selection** - Use `haiku` for fast read-only tasks, `inherit` for complex tasks
5. **Tool restrictions** - Use `tools` (allowlist) or `disallowedTools` (denylist) to limit capabilities

### Agent Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier using lowercase letters and hyphens |
| `description` | Yes | When Claude should delegate to this agent |
| `tools` | No | Tools the agent can use (inherits all if omitted) |
| `disallowedTools` | No | Tools to deny from inherited or specified list |
| `model` | No | Model: `sonnet`, `opus`, `haiku`, or `inherit` (default) |
| `permissionMode` | No | Permission mode: `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Maximum agentic turns before agent stops |
| `skills` | No | Skills to preload into agent's context at startup |
| `mcpServers` | No | MCP servers available to this agent |
| `hooks` | No | Lifecycle hooks scoped to this agent |
| `memory` | No | Persistent memory scope: `user`, `project`, or `local` |
| `background` | No | Set to `true` to always run as background task |
| `isolation` | No | Set to `worktree` to run in temporary git worktree |

## Official Documentation

- Plugins: https://code.claude.com/docs/en/plugins
- Skills: https://code.claude.com/docs/en/skills
- Agents: https://code.claude.com/docs/en/sub-agents
- Marketplaces: https://code.claude.com/docs/en/plugin-marketplaces
