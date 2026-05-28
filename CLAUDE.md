# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and Codex when working with code in this repository.

[中文版本](./CLAUDE_CN.md)

## Project Overview

Claude Code / Codex Plugins Marketplace - a collection of plugins distributed via GitHub marketplace.

## Architecture

```
plugins/
├── .claude-plugin/
│   └── marketplace.json    # Marketplace manifest (pluginRoot points to ./plugins)
├── .agents/
│   └── plugins/
│       └── marketplace.json # Codex marketplace manifest
└── plugins/                # Each subdirectory is a standalone plugin
    └── {plugin-name}/
        ├── .claude-plugin/
        │   └── plugin.json # Claude plugin manifest (skills array references skill directories)
        ├── .codex-plugin/
        │   └── plugin.json # Codex plugin manifest (skills: "./skills/")
        ├── agents/         # Agent definitions (optional)
        │   └── {agent}.md  # Agent with YAML frontmatter
        ├── skills/         # Skill definitions
        │   └── {skill}/
        │       ├── SKILL.md
        │       └── docs/
        │           ├── README.md       # Human-facing docs (installation, usage, etc.)
        │           └── SKILL_CN.md
        └── evals/          # Skill evaluation tests
            └── evals.json
```

## Skill Conventions

1. **SKILL.md in English** - AI loads and executes this file; English avoids context pollution
2. **docs/SKILL_CN.md in Chinese** - Independent file, not loaded by plugin system, for human reference
3. **docs/README.md** - All human-facing documentation (installation, configuration, usage examples) goes here
4. **Keep SKILL.md and SKILL_CN.md in sync** - Same content, different languages, update both on every change

## Before Adding New Skills/Plugins/Agents

**Read the official documentation first** to understand the specifications:
- Claude plugins: https://code.claude.com/docs/en/plugins
- Claude skills: https://code.claude.com/docs/en/skills
- Claude agents: https://code.claude.com/docs/en/sub-agents
- Claude marketplaces: https://code.claude.com/docs/en/plugin-marketplaces
- Codex plugins: https://developers.openai.com/codex/plugins
- Codex skills: https://developers.openai.com/codex/skills

## Key Conventions

- **Claude Marketplace ID**: `fawetian-plugins`
- **Codex Marketplace ID**: `fawetian-plugins-codex`
- **Claude install command**: `/plugin install {plugin-name}@fawetian-plugins`
- **Codex install command**: `codex plugin add {plugin-name}@fawetian-plugins-codex`
- **Skills**: Use strict YAML frontmatter with `name` and quoted `description` fields for triggering
- **Dual-platform default**: New skills must be available to both Claude and Codex unless the plugin is intentionally Claude-only (for example agents-only `devops`)
- **Commit format**: Conventional Commits with Chinese descriptions (for git-ops plugin)
- **Documentation**: Always update both English and Chinese versions when modifying any documentation files
- **Version Bumping**: When modifying skill content, MUST bump both Claude and Codex `plugin.json` versions when both manifests exist:
  - `PATCH` (1.0.x): Bug fixes, minor skill content tweaks
  - `MINOR` (1.x.0): New skills, new features, significant skill changes
  - `MAJOR` (x.0.0): Breaking changes, major restructure
  - Keep `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, and marketplace entries version-consistent

## Adding New Plugins

1. Create directory under `plugins/`
2. Add `.claude-plugin/plugin.json` with name, version, description, and a `skills` array when the plugin has skills
3. Add `.codex-plugin/plugin.json` with matching name/version/description and `skills: "./skills/"` for skill-based plugins
4. Create skill files in `skills/` with strict YAML frontmatter
5. Register the plugin in `.claude-plugin/marketplace.json`
6. Register skill-based Codex plugins in `.agents/plugins/marketplace.json`
7. Do not register agents-only plugins in Codex until they expose at least one Codex skill

## Adding New Skills

1. Create `plugins/<plugin>/skills/<skill>/SKILL.md` in English.
2. Use strict YAML frontmatter:
   - `name`: lowercase hyphenated skill name matching the directory
   - `description`: quoted string describing exactly when the skill should trigger
   - Optional fields such as `userInvocable` must remain valid YAML
3. Add `docs/SKILL_CN.md` and `docs/README.md`; keep English and Chinese skill docs in sync.
4. Add `evals/evals.json` with positive and negative trigger prompts.
5. Add the skill path to `.claude-plugin/plugin.json` `skills[]`.
6. Ensure `.codex-plugin/plugin.json` exists for the plugin and uses `skills: "./skills/"`; no per-skill Codex list update is needed with this layout.
7. Bump both Claude and Codex plugin versions, then update matching marketplace versions.
8. Run:
   ```bash
   ./tests/run-all.sh --structure
   python3 /Users/shanquan/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/<plugin>
   ```
9. For trigger behavior changes, also run targeted evals:
   ```bash
   ./tests/run-all.sh --trigger --skill <skill>
   ```

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

## Skill Evaluation

Each skill must have an `evals/evals.json` file for automated testing. The test suite lives in `tests/`.

```bash
./tests/run-all.sh --structure    # Quick structure check (no Claude needed)
./tests/run-all.sh --dry-run      # List all discoverable tests
./tests/run-all.sh --trigger --skill git-ops  # Test specific skill
./tests/run-all.sh                # Run all 5 layers
```

When adding a new skill, create `evals/evals.json` with trigger prompts (positive + negative). See `tests/lib/eval-schema.json` for the schema and `tests/README.md` for details. Structure tests validate both Claude and Codex manifests.

## MCP Integration

For integrating MCP servers into plugins, see the official example skill:
- https://github.com/anthropics/claude-plugins-official/blob/main/plugins/plugin-dev/skills/mcp-integration/SKILL.md

## Official Documentation

- Claude plugins: https://code.claude.com/docs/en/plugins
- Claude skills: https://code.claude.com/docs/en/skills
- Claude agents: https://code.claude.com/docs/en/sub-agents
- Claude marketplaces: https://code.claude.com/docs/en/plugin-marketplaces
- Codex plugins: https://developers.openai.com/codex/plugins
- Codex skills: https://developers.openai.com/codex/skills
