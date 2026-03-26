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
.claude-plugin/
│   └── marketplace.json    # Marketplace manifest
plugins/                    # Each subdirectory is a standalone plugin
├── coding/                 # Code quality tools (15 skills, 11 agents)
├── product/                # Product manager tools (4 skills, 2 agents)
├── cli/                    # Local CLI tools - Feishu, Aliyun (2 skills)
└── devops/                 # Dev tools - doc lookup, refactor, optimization (5 agents)
rules/                      # Reusable Claude Code Rules
├── common/                 # Language-agnostic principles
├── me/                     # User-level personalization templates
├── golang/                 # Go specific rules
├── python/                 # Python specific rules
├── typescript/             # TypeScript/JavaScript rules
├── rust/                   # Rust specific rules
├── shell/                  # Shell/Bash/Zsh rules
├── swift/                  # Swift specific rules
└── zh-CN/                  # Chinese translations (mirrors above)
tests/                      # Skill evaluation test suite
docs/                       # Generated documentation and reviews
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

## Agents (Subagents)

Agents are specialized AI assistants that handle specific types of tasks. Each agent runs in its own context window with a custom system prompt, specific tool access, and independent permissions.

### Agent Benefits

- **Preserve context** - Keep exploration and implementation out of main conversation
- **Enforce constraints** - Limit which tools an agent can use
- **Reuse configurations** - Share agents across projects via plugins
- **Specialize behavior** - Focused system prompts for specific domains
- **Control costs** - Route tasks to faster, cheaper models like Haiku

### Agent Structure

Agents are defined in Markdown files with YAML frontmatter:

```
agents/
├── {agent-name}.md          # English version
└── zh-CN/
    └── {agent-name}.md      # Chinese version
```

Example agent file:

```markdown
---
name: code-reviewer
description: Expert code review specialist. Use proactively after code changes.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.
```

### Available Agents

| Agent | Purpose | Priority |
|-------|---------|----------|
| `code-reviewer` | Code quality, security, maintainability review | P0 |
| `architect` | System design, scalability, technical decisions | P0 |
| `planner` | Implementation planning, step breakdown | P0 |
| `security-reviewer` | Security vulnerability detection and remediation | P0 |
| `build-error-resolver` | TypeScript/build error resolution | P1 |
| `python-reviewer` | Python code review (PEP 8, type hints, security) | P1 |
| `go-reviewer` | Go code review (idiomatic, concurrency, error handling) | P1 |
| `go-build-resolver` | Go build/vet error resolution | P1 |
| `rust-reviewer` | Rust code review (ownership, lifetimes, unsafe) | P1 |
| `rust-build-resolver` | Rust compilation/borrow checker error resolution | P1 |
| `database-reviewer` | PostgreSQL query optimization, schema design, RLS | P1 |
| `tdd-guide` | Test-Driven Development methodology | P1 |
| `refactor-cleaner` | Dead code cleanup, dependency removal | P2 |
| `doc-updater` | Documentation and codemap updates | P2 |
| `docs-lookup` | Library/framework documentation lookup via Context7 | P2 |
| `e2e-runner` | End-to-end testing (Agent Browser, Playwright) | P2 |
| `harness-optimizer` | Agent harness configuration optimization | P2 |
| `loop-operator` | Autonomous loop monitoring and intervention | P2 |

### Official Documentation

When designing agents, **always refer to the official documentation** for the latest specifications:
- [Subagents Documentation](https://code.claude.com/docs/en/sub-agents)

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

## MCP Integration

### Minimal Example: Wrap MCP Server as Plugin

The simplest way to create a plugin is to wrap an existing MCP server. Example from [official GitHub plugin](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/github):

**File structure:**
```
github/
├── .claude-plugin/
│   └── plugin.json    # Plugin metadata
└── .mcp.json          # MCP server configuration
```

**`.claude-plugin/plugin.json`:**
```json
{
  "name": "github",
  "description": "Official GitHub MCP server for repository management. Create issues, manage pull requests, review code, search repositories, and interact with GitHub's full API directly from Claude Code.",
  "author": {
    "name": "GitHub"
  }
}
```

**`.mcp.json`:**
```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/",
    "headers": {
      "Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"
    }
  }
}
```

That's it! No skills, agents, or commands needed - the MCP server provides all functionality.

### Advanced MCP Integration

For integrating MCP servers with custom skills and logic, see:
- [MCP Integration Skill Example](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/plugin-dev/skills/mcp-integration/SKILL.md)

## Documentation

- [Plugins Development Guide](https://code.claude.com/docs/en/plugins)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Discover Plugins](https://code.claude.com/docs/en/discover-plugins)
- [Skills Development Guide](https://code.claude.com/docs/en/skills)
- [Rules & Memory](https://code.claude.com/docs/en/memory)
