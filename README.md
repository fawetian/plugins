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
├── .claude-plugin/
│   └── marketplace.json    # Marketplace configuration
├── plugins/                # Internal plugins
└── external_plugins/       # Third-party plugins
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
| [JimLiu/baoyu-skills](https://github.com/JimLiu/baoyu-skills) | Baoyu skills collection |
| [anthropics/skills](https://github.com/anthropics/skills) | Official Anthropic skills |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Official Claude plugins |

## Contributing

Contributions are welcome! Please submit a pull request to add your plugin.

## Documentation

- [Plugins Development Guide](https://code.claude.com/docs/plugins)
- [Plugin Marketplaces](https://code.claude.com/docs/plugin-marketplaces)
- [Skills Development Guide](https://code.claude.com/docs/skills)
