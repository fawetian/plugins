# CLAUDE_CN.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作时提供指导。

[English](./CLAUDE.md)

## 项目概述

Claude Code 插件市场 - 通过 GitHub 市场分发的插件集合。

## 架构

```
plugins/
├── .claude-plugin/
│   └── marketplace.json    # 市场清单（pluginRoot 指向 ./plugins）
└── plugins/                # 每个子目录是一个独立的插件
    └── {plugin-name}/
        ├── .claude-plugin/
        │   └── plugin.json # 插件清单（skills 数组引用技能目录）
        ├── agents/         # 智能体定义（可选）
        │   └── {agent}.md  # 带有 YAML frontmatter 的智能体
        ├── skills/         # 技能定义
        │   └── {skill}/
        │       ├── SKILL.md
        │       └── docs/
        │           └── SKILL_CN.md
        └── evals/          # 技能评估测试
            └── evals.json
```

## Skill 规范

1. **SKILL.md 使用英文** - AI 加载执行，避免污染上下文
2. **docs/SKILL_CN.md 使用中文** - 独立文件，不被插件系统加载
3. **两个版本保持同步** - 内容一致，仅语言不同，每次改动 2 个版本同步修改

## 新增 Skill/Plugin/Agent 前

**务必先阅读官方文档**了解规范：
- 插件: https://code.claude.com/docs/zh-CN/plugins
- 技能: https://code.claude.com/docs/zh-CN/skills
- 智能体: https://code.claude.com/docs/zh-CN/sub-agents
- 市场: https://code.claude.com/docs/zh-CN/plugin-marketplaces

## 关键约定

- **市场 ID**: `fawetian-plugins`
- **安装命令**: `/plugin install {plugin-name}@fawetian-plugins`
- **技能**: 使用包含 `name` 和 `description` 字段的 YAML frontmatter 以便触发
- **提交格式**: 使用中文描述的约定式提交（针对 git-ops 插件）
- **文档同步**: 修改任何文档文件时必须同时更新中英文两个版本
- **版本号更新**: 修改 skill 内容后，必须更新 `plugin.json` 中的版本号：
  - `PATCH` (1.0.x): Bug 修复、skill 内容小调整
  - `MINOR` (1.x.0): 新增 skill、新功能、skill 重大改动
  - `MAJOR` (x.0.0): 破坏性变更、重大重构
  - 这是 Claude Code 通过 `/plugin update` 检测插件更新的必要条件

## 添加新插件

1. 在 `plugins/` 下创建目录
2. 添加 `.claude-plugin/plugin.json`，包含 name、version、description、skills 数组
3. 在 `skills/` 中创建带有 YAML frontmatter 的技能文件
4. 在 `marketplace.json` 的 plugins 数组中注册插件

## Agent 规范

1. **Agent 文件命名** - 使用小写字母和连字符：`{agent-name}.md`
2. **YAML frontmatter 必需** - 必须包含 `name` 和 `description` 字段
3. **清晰的描述** - Claude 使用描述来决定何时委托任务
4. **模型选择** - 快速只读任务使用 `haiku`，复杂任务使用 `inherit`
5. **工具限制** - 使用 `tools`（允许列表）或 `disallowedTools`（拒绝列表）限制能力

### Agent Frontmatter 字段

| 字段 | 必需 | 描述 |
|------|------|------|
| `name` | 是 | 使用小写字母和连字符的唯一标识符 |
| `description` | 是 | Claude 何时应委托给此 agent |
| `tools` | 否 | agent 可以使用的工具（省略则继承所有工具） |
| `disallowedTools` | 否 | 要拒绝的工具，从继承或指定的列表中删除 |
| `model` | 否 | 模型：`sonnet`、`opus`、`haiku` 或 `inherit`（默认） |
| `permissionMode` | 否 | 权限模式：`default`、`acceptEdits`、`dontAsk`、`bypassPermissions`、`plan` |
| `maxTurns` | 否 | agent 停止前的最大代理轮数 |
| `skills` | 否 | 在启动时加载到 agent 上下文中的技能 |
| `mcpServers` | 否 | 此 agent 可用的 MCP 服务器 |
| `hooks` | 否 | 限定于此 agent 的生命周期钩子 |
| `memory` | 否 | 持久内存范围：`user`、`project` 或 `local` |
| `background` | 否 | 设置为 `true` 以始终作为后台任务运行 |
| `isolation` | 否 | 设置为 `worktree` 以在临时 git worktree 中运行 |

## 官方文档

- 插件: https://code.claude.com/docs/zh-CN/plugins
- 技能: https://code.claude.com/docs/zh-CN/skills
- 智能体: https://code.claude.com/docs/zh-CN/sub-agents
- 市场: https://code.claude.com/docs/zh-CN/plugin-marketplaces
