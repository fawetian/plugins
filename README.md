# Claude Code Plugins Marketplace

My personal plugin marketplace for Claude Code.

[中文文档](./README_CN.md)

## Add Marketplace

To add this marketplace to Claude Code:

```bash
/plugin marketplace add fawetian/plugins
```

Or use the full URL:

```bash
/plugin marketplace add https://github.com/fawetian/plugins
```

## Install Plugins

Once the marketplace is added, install plugins:

```bash
/plugin install {plugin-name}@fawetian-plugins
```

## Structure

```
plugins/
├── plugins/                # Internal plugins
│   └── coding/
├── external_plugins/       # Third-party plugins
└── rules/                  # Reusable Claude Code Rules
    ├── common/             # Language-agnostic principles
    ├── golang/             # Go specific rules
    ├── python/             # Python specific rules
    ├── typescript/         # TypeScript/JavaScript rules
    ├── rust/               # Rust specific rules
    ├── shell/              # Shell/Bash/Zsh rules
    └── swift/              # Swift specific rules
```

## Plugin Structure

Each plugin follows a standard structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (required)
├── .mcp.json            # MCP server configuration (optional)
├── commands/            # Slash commands (optional)
├── agents/              # Agent definitions (optional)
├── skills/              # Skill definitions (optional)
└── README.md            # Documentation
```

## External Sources

Recommended external plugin/skill sources:

| Source | Description |
|--------|-------------|
| [obra/superpowers](https://github.com/obra/superpowers) | Agentic skills framework & development methodology |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Vercel's official agent skills (React, Next.js, design) |
| [JimLiu/baoyu-skills](https://github.com/JimLiu/baoyu-skills) | Baoyu skills collection |
| [anthropics/skills](https://github.com/anthropics/skills) | Official Anthropic skills |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Official Claude plugins |

## Contributing

Contributions are welcome! Please submit a pull request to add your plugin.

## Rules (Cross-Project)

The `rules/` directory contains reusable Claude Code Rules for multiple languages. These can be copied to other projects or your global `~/.claude/rules/` directory.

```bash
# Copy to global rules
cp -r rules/common ~/.claude/rules/
cp -r rules/rust ~/.claude/rules/

# Or copy to project-specific rules
cp -r rules/python .claude/rules/
```

See [rules/README.md](./rules/README.md) for details.

## Documentation

- [Plugins Development Guide](https://code.claude.com/docs/en/plugins)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Discover Plugins](https://code.claude.com/docs/en/discover-plugins)
- [Skills Development Guide](https://code.claude.com/docs/en/skills)
- [Rules & Memory](https://code.claude.com/docs/en/memory)
