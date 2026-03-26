# Claude Code 插件市场

我的 Claude Code 插件市场。

[English](./README.md)

## 添加市场

将此市场添加到 Claude Code：

```bash
/plugin marketplace add fawetian/plugins
```

或使用完整 URL：

```bash
/plugin marketplace add https://github.com/fawetian/plugins
```

## 安装插件

添加市场后，安装插件：

```bash
/plugin install {plugin-name}@fawetian-plugins
```

## 目录结构

```
.claude-plugin/
│   └── marketplace.json    # 市场清单
plugins/                    # 每个子目录是一个独立插件
├── coding/                 # 代码质量工具集（15 个 skill、11 个 agent）
├── product/                # 产品经理工具集（4 个 skill、2 个 agent）
├── cli/                    # 本地 CLI 工具 - 飞书、阿里云（2 个 skill）
└── devops/                 # 开发者工具 - 文档查询、代码清理、配置优化（5 个 agent）
rules/                      # 可复用的 Claude Code Rules
├── common/                 # 语言无关的通用规则
├── me/                     # 用户个性化配置模板
├── golang/                 # Go 专用规则
├── python/                 # Python 专用规则
├── typescript/             # TypeScript/JavaScript 规则
├── rust/                   # Rust 专用规则
├── shell/                  # Shell/Bash/Zsh 规则
├── swift/                  # Swift 专用规则
└── zh-CN/                  # 中文翻译（镜像上方结构）
tests/                      # Skill 评估测试套件
docs/                       # 生成的文档和 review 报告
```

## 插件结构

每个插件遵循标准结构：

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # 插件元数据（必需）
├── .mcp.json            # MCP 服务器配置（可选）
├── commands/            # 斜杠命令（可选）
├── agents/              # 智能体定义（可选）
├── skills/              # 技能定义（可选）
└── README.md            # 文档
```

## Agents（子智能体）

Agents 是处理特定类型任务的专门 AI 助手。每个 agent 在自己的上下文窗口中运行，具有自定义系统提示、特定的工具访问权限和独立的权限。

### Agent 优势

- **保留上下文** - 将探索和实现保持在主对话之外
- **强制执行约束** - 限制 agent 可以使用的工具
- **重用配置** - 通过插件跨项目共享 agents
- **专门化行为** - 为特定领域使用专注的系统提示
- **控制成本** - 将任务路由到更快、更便宜的模型（如 Haiku）

### Agent 结构

Agents 使用带有 YAML frontmatter 的 Markdown 文件定义：

```
agents/
├── {agent-name}.md          # 英文版
└── zh-CN/
    └── {agent-name}.md      # 中文版
```

Agent 文件示例：

```markdown
---
name: code-reviewer
description: 专家级代码审查专家。主动审查代码的质量、安全性和可维护性。
tools: Read, Grep, Glob, Bash
model: inherit
---

你是一位资深代码审查专家，确保代码质量和安全性达到高标准。
```

### 可用的 Agents

| Agent | 用途 | 优先级 |
|-------|------|--------|
| `code-reviewer` | 代码质量、安全性、可维护性审查 | P0 |
| `architect` | 系统设计、可扩展性、技术决策 | P0 |
| `planner` | 实现计划、步骤分解 | P0 |
| `security-reviewer` | 安全漏洞检测和修复 | P0 |
| `build-error-resolver` | TypeScript/构建错误解决 | P1 |
| `python-reviewer` | Python 代码审查（PEP 8、类型提示、安全） | P1 |
| `go-reviewer` | Go 代码审查（惯用法、并发、错误处理） | P1 |
| `go-build-resolver` | Go 构建/vet 错误解决 | P1 |
| `rust-reviewer` | Rust 代码审查（所有权、生命周期、unsafe） | P1 |
| `rust-build-resolver` | Rust 编译/借用检查器错误解决 | P1 |
| `database-reviewer` | PostgreSQL 查询优化、schema 设计、RLS | P1 |
| `tdd-guide` | 测试驱动开发方法论 | P1 |
| `refactor-cleaner` | 死代码清理、依赖删除 | P2 |
| `doc-updater` | 文档和代码地图更新 | P2 |
| `docs-lookup` | 通过 Context7 查询库/框架文档 | P2 |
| `e2e-runner` | 端到端测试（Agent Browser、Playwright） | P2 |
| `harness-optimizer` | Agent harness 配置优化 | P2 |
| `loop-operator` | 自主循环监控和干预 | P2 |

### 官方文档

设计 agent 时，**务必参考官方最新文档**了解规范：
- [Subagents 文档](https://code.claude.com/docs/zh-CN/sub-agents)

## 外部源

推荐的外部插件/技能源：

| 源 | 描述 |
|----|------|
| [obra/superpowers](https://github.com/obra/superpowers) | Agentic 技能框架与开发方法论 |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Vercel 官方技能集合（React、Next.js、设计指南） |
| [JimLiu/baoyu-skills](https://github.com/JimLiu/baoyu-skills) | 宝玉技能集合 |
| [anthropics/skills](https://github.com/anthropics/skills) | Anthropic 官方技能 |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Claude 官方插件 |

## 参与贡献

欢迎贡献代码！请提交 Pull Request 来添加你的插件。

## Rules (跨项目复用)

`rules/` 目录包含可复用的 Claude Code Rules，支持多种语言。可复制到其他项目或全局 `~/.claude/rules/` 目录使用。

```bash
# 复制到全局规则
cp -r rules/common ~/.claude/rules/
cp -r rules/rust ~/.claude/rules/

# 或复制到项目专用规则
cp -r rules/python .claude/rules/
```

详情参见 [rules/README.md](./rules/README.md)。

## MCP 集成

### 极简示例：将 MCP 服务器封装为插件

创建插件最简单的方式是封装现有的 MCP 服务器。示例来自[官方 GitHub 插件](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/github)：

**文件结构：**
```
github/
├── .claude-plugin/
│   └── plugin.json    # 插件元数据
└── .mcp.json          # MCP 服务器配置
```

**`.claude-plugin/plugin.json`：**
```json
{
  "name": "github",
  "description": "Official GitHub MCP server for repository management. Create issues, manage pull requests, review code, search repositories, and interact with GitHub's full API directly from Claude Code.",
  "author": {
    "name": "GitHub"
  }
}
```

**`.mcp.json`：**
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

就这样！无需 skills、agents 或 commands — MCP 服务器提供所有功能。

### 高级 MCP 集成

如需集成 MCP 服务器并添加自定义技能和逻辑，请参考：
- [MCP 集成技能示例](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/plugin-dev/skills/mcp-integration/SKILL.md)

## 官方文档

- [插件开发指南](https://code.claude.com/docs/zh-CN/plugins)
- [插件市场配置](https://code.claude.com/docs/zh-CN/plugin-marketplaces)
- [技能开发指南](https://code.claude.com/docs/zh-CN/skills)
- [规则与记忆](https://code.claude.com/docs/zh-CN/memory)
