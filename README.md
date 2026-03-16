# Claude Code Plugins Marketplace

A curated collection of high-quality plugins for Claude Code.

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

## Contributing

Contributions are welcome! Please submit a pull request to add your plugin.

## Documentation

For more information on developing Claude Code plugins, see the [official documentation](https://code.claude.com/docs/plugins).
