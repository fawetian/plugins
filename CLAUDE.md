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

## Before Adding New Skills/Plugins

**Read the official documentation first** to understand the specifications:
- Plugins: https://code.claude.com/docs/zh-CN/plugins
- Skills: https://code.claude.com/docs/zh-CN/skills
- Marketplaces: https://code.claude.com/docs/zh-CN/plugin-marketplaces

## Key Conventions

- **Marketplace ID**: `fawetian-plugins`
- **Install command**: `/plugin install {plugin-name}@fawetian-plugins`
- **Skills**: Use YAML frontmatter with `name` and `description` fields for triggering
- **Commit format**: Conventional Commits with Chinese descriptions (for git-ops plugin)
- **Documentation**: Always update both English and Chinese versions when modifying any documentation files

## Adding New Plugins

1. Create directory under `plugins/`
2. Add `.claude-plugin/plugin.json` with name, version, description, skills array
3. Create skill files in `skills/` with YAML frontmatter
4. Register plugin in `marketplace.json` plugins array

## Official Documentation

- Plugins: https://code.claude.com/docs/zh-CN/plugins
- Skills: https://code.claude.com/docs/zh-CN/skills
- Marketplaces: https://code.claude.com/docs/zh-CN/plugin-marketplaces
