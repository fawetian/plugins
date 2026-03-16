# Claude Code Plugins Directory

A curated directory of high-quality plugins for Claude Code.

## Structure

- `/plugins` - Internal plugins
- `/external_plugins` - Third-party plugins from the community

## Installation

Plugins can be installed directly from this marketplace via Claude Code's plugin system.

To install, run `/plugin install {plugin-name}@fawetian/plugins`

## Contributing

See `/plugins/example-plugin` for a reference implementation.

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

## Documentation

For more information on developing Claude Code plugins, see the official documentation.
