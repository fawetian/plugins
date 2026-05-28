# CLAUDE_CN.md

本文件为 Claude Code (claude.ai/code) 和 Codex 在此仓库中工作时提供指导。

[English](./CLAUDE.md)

## 项目概述

Claude Code / Codex 插件市场 - 通过 GitHub 市场分发的插件集合。

## 架构

```
plugins/
├── .claude-plugin/
│   └── marketplace.json    # 市场清单（pluginRoot 指向 ./plugins）
├── .agents/
│   └── plugins/
│       └── marketplace.json # Codex 市场清单
└── plugins/                # 每个子目录是一个独立的插件
    └── {plugin-name}/
        ├── .claude-plugin/
        │   └── plugin.json # Claude 插件清单（skills 数组引用技能目录）
        ├── .codex-plugin/
        │   └── plugin.json # Codex 插件清单（skills: "./skills/"）
        ├── agents/         # 智能体定义（可选）
        │   └── {agent}.md  # 带有 YAML frontmatter 的智能体
        ├── skills/         # 技能定义
        │   └── {skill}/
        │       ├── SKILL.md
        │       └── docs/
        │           ├── README.md       # 给人看的文档（安装、使用说明等）
        │           └── SKILL_CN.md
        └── evals/          # 技能评估测试
            └── evals.json
```

## Skill 规范

1. **SKILL.md 使用英文** - AI 加载执行，避免污染上下文
2. **docs/SKILL_CN.md 使用中文** - 独立文件，不被插件系统加载，供人工参考
3. **docs/README.md** - 所有给人看的文档（安装、配置、使用示例等）统一放在此文件
4. **SKILL.md 与 SKILL_CN.md 保持同步** - 内容一致，仅语言不同，每次改动 2 个版本同步修改

## 新增 Skill/Plugin/Agent 前

**务必先阅读官方文档**了解规范：
- Claude 插件: https://code.claude.com/docs/zh-CN/plugins
- Claude 技能: https://code.claude.com/docs/zh-CN/skills
- Claude 智能体: https://code.claude.com/docs/zh-CN/sub-agents
- Claude 市场: https://code.claude.com/docs/zh-CN/plugin-marketplaces
- Codex 插件: https://developers.openai.com/codex/plugins
- Codex 技能: https://developers.openai.com/codex/skills

## 关键约定

- **Claude 市场 ID**: `fawetian-plugins`
- **Codex 市场 ID**: `fawetian-plugins-codex`
- **Claude 安装命令**: `/plugin install {plugin-name}@fawetian-plugins`
- **Codex 安装命令**: `codex plugin add {plugin-name}@fawetian-plugins-codex`
- **技能**: 使用严格 YAML frontmatter，包含 `name` 和加引号的 `description` 字段以便触发
- **双平台默认**: 新增 skill 必须同时支持 Claude 和 Codex，除非该插件明确只支持 Claude（例如 agents-only 的 `devops`）
- **提交格式**: 使用中文描述的约定式提交（针对 git-ops 插件）
- **文档同步**: 修改任何文档文件时必须同时更新中英文两个版本
- **版本号更新**: 修改 skill 内容后，如果 Claude 和 Codex manifest 都存在，必须同时更新两边 `plugin.json` 的版本号：
  - `PATCH` (1.0.x): Bug 修复、skill 内容小调整
  - `MINOR` (1.x.0): 新增 skill、新功能、skill 重大改动
  - `MAJOR` (x.0.0): 破坏性变更、重大重构
  - `.claude-plugin/plugin.json`、`.codex-plugin/plugin.json` 和市场条目版本必须保持一致

## 添加新插件

1. 在 `plugins/` 下创建目录
2. 添加 `.claude-plugin/plugin.json`，包含 name、version、description；有 skills 时包含 skills 数组
3. 为基于 skill 的插件添加 `.codex-plugin/plugin.json`，name/version/description 与 Claude 一致，并设置 `skills: "./skills/"`
4. 在 `skills/` 中创建带有严格 YAML frontmatter 的技能文件
5. 在 `.claude-plugin/marketplace.json` 中注册插件
6. 在 `.agents/plugins/marketplace.json` 中注册基于 skill 的 Codex 插件
7. agents-only 插件在暴露至少一个 Codex skill 前，不要注册到 Codex 市场

## 添加新 Skill

1. 创建 `plugins/<plugin>/skills/<skill>/SKILL.md`，使用英文。
2. 使用严格 YAML frontmatter：
   - `name`：小写连字符命名，并与目录名一致
   - `description`：加引号的字符串，明确描述何时触发该 skill
   - `userInvocable` 等可选字段也必须保持合法 YAML
3. 添加 `docs/SKILL_CN.md` 和 `docs/README.md`，保持中英文 skill 文档同步。
4. 添加 `evals/evals.json`，包含正向和负向触发提示词。
5. 将 skill 路径加入 `.claude-plugin/plugin.json` 的 `skills[]`。
6. 确认该插件存在 `.codex-plugin/plugin.json` 且使用 `skills: "./skills/"`；此布局下无需逐个更新 Codex skill 列表。
7. 更新 Claude 和 Codex 两边插件版本，并同步更新市场中的版本。
8. 运行：
   ```bash
   ./tests/run-all.sh --structure
   python3 /Users/shanquan/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/<plugin>
   ```
9. 如果改动影响触发行为，还要运行定向 eval：
   ```bash
   ./tests/run-all.sh --trigger --skill <skill>
   ```

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

## Skill 评估

每个 skill 必须有一个 `evals/evals.json` 文件用于自动化测试。测试套件位于 `tests/` 目录。

```bash
./tests/run-all.sh --structure    # 快速结构检查（无需 Claude）
./tests/run-all.sh --dry-run      # 列出所有可发现的测试
./tests/run-all.sh --trigger --skill git-ops  # 测试特定 skill
./tests/run-all.sh                # 运行全部 5 层测试
```

添加新 skill 时，创建包含触发提示词（正向 + 负向）的 `evals/evals.json`。schema 参见 `tests/lib/eval-schema.json`，详情参见 `tests/README.md`。结构测试会同时校验 Claude 和 Codex manifest。

## MCP 集成

关于如何在插件中集成 MCP 服务器，请参考官方示例技能：
- https://github.com/anthropics/claude-plugins-official/blob/main/plugins/plugin-dev/skills/mcp-integration/SKILL.md

## 官方文档

- Claude 插件: https://code.claude.com/docs/zh-CN/plugins
- Claude 技能: https://code.claude.com/docs/zh-CN/skills
- Claude 智能体: https://code.claude.com/docs/zh-CN/sub-agents
- Claude 市场: https://code.claude.com/docs/zh-CN/plugin-marketplaces
- Codex 插件: https://developers.openai.com/codex/plugins
- Codex 技能: https://developers.openai.com/codex/skills
