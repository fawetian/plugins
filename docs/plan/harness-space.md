# Plan: harness-space 插件 — AI harness 持续迭代

## 背景

用户将 `~/harness-space/` 作为自己的 **harness engineering** 仓库。这个插件的目标就是帮助用户**持续迭代这个 harness-space**。

当前 harness-space 的内容是 `rules/` 目录下的 md 文件；每个文件是一类 rule（按领域划分，如 `git.md`、`coding-style.md`），通过 `@` 导入到 `~/.claude/CLAUDE.md` 全局生效。这只是现阶段的一个 case — 随着迭代，harness-space 可能会扩展出更多形态的 harness 资产。

## 目录结构

```
plugins/
└── harness-space/
    ├── .claude-plugin/
    │   └── plugin.json         # Claude plugin manifest
    ├── .codex-plugin/
    │   └── plugin.json         # Codex plugin manifest
    └── skills/
        └── rule-kit/
            ├── SKILL.md
            ├── evals/
            │   └── evals.json
            └── docs/
                ├── README.md
                └── SKILL_CN.md
```

## harness-space 仓库结构（~/harness-space/）

```
~/harness-space/
├── README.md                    # Harness 说明文档（plugin skill 帮助维护）
├── rules/                       # Rule 文件（按领域划分，粒度适中）
│   ├── git.md                   # 示例：Git 相关规则（含 worktree 必须用 wt 工具等）
│   ├── coding-style.md          # 未来可能的 rule
│   └── ...
└── .git/                        # 版本控制
```

`~/.claude/CLAUDE.md`（Claude 用户级规则）通过 `@` 导入引用 `~/harness-space/rules/` 下的文件：

```markdown
## Harness Space Rules

@~/harness-space/rules/git.md
```

`~/.codex/AGENTS.md`（Codex 用户级指令）**不支持 `@` 导入**，规则内容需直接嵌入：

```markdown
## Harness Space Rules

<!-- harness-space:git -->
（git.md 的完整内容直接嵌入此处）
<!-- /harness-space:git -->
```

每个 rule 用 HTML 注释标记 `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->` 包裹，便于定位和替换。

## 实现步骤

### 1. 创建 Claude plugin.json

**文件**: `plugins/harness-space/.claude-plugin/plugin.json`

```json
{
  "name": "harness-space",
  "version": "0.1.0",
  "description": "Manage and iterate your AI harness engineering workspace — file-based rule categories and constraints for reliable AI agents",
  "author": {
    "name": "fawetian"
  },
  "license": "MIT",
  "keywords": ["harness", "harness-engineering", "rules", "rule-kit", "constraints", "workspace"],
  "skills": ["./skills/rule-kit"]
}
```

### 2. 创建 Codex plugin.json

**文件**: `plugins/harness-space/.codex-plugin/plugin.json`

```json
{
  "name": "harness-space",
  "version": "0.1.0",
  "description": "管理 AI harness engineering 工作空间 — 按文件维护 rule 类别和约束",
  "author": {
    "name": "fawetian"
  },
  "homepage": "https://github.com/fawetian/plugins",
  "repository": "https://github.com/fawetian/plugins",
  "license": "MIT",
  "keywords": ["harness", "harness-engineering", "rules", "rule-kit", "constraints", "workspace"],
  "skills": "./skills/",
  "interface": {
    "displayName": "Harness Space",
    "shortDescription": "Manage and iterate your AI harness engineering workspace",
    "longDescription": "持续迭代你的 harness-space：添加、列出、更新、删除和同步约束 AI agent 行为的规则。",
    "developerName": "fawetian",
    "category": "Productivity",
    "capabilities": ["Interactive", "Read", "Write"],
    "websiteURL": "https://github.com/fawetian/plugins",
    "privacyPolicyURL": "https://github.com/fawetian/plugins",
    "termsOfServiceURL": "https://github.com/fawetian/plugins",
    "defaultPrompt": [
      "list all my harness rules",
      "add a git rule to harness-space",
      "sync harness-space"
    ],
    "brandColor": "#7C3AED",
    "screenshots": []
  }
}
```

### 3. 注册到双平台 marketplace

- `.claude-plugin/marketplace.json` — Claude marketplace 的 plugins 数组追加 harness-space 条目
- `.agents/plugins/marketplace.json` — Codex marketplace 的 plugins 数组追加 harness-space 条目

### 4. 创建 SKILL.md

**文件**: `plugins/harness-space/skills/rule-kit/SKILL.md`

Frontmatter（实现时用英文）:
```yaml
---
name: rule-kit
description: >
  管理 ~/harness-space/rules/ 中的 harness-space rules。
  每个文件是一类 rule；添加、列出、更新或删除约束 AI agent 行为的规则。
  触发词：rule, add rule, harness, harness-space,
  list rules, setup wt, worktree rule, coding style, rule-kit
userInvocable: true
---
```

**Body 指令（实现时用英文，此处用中文描述逻辑）：**

```
你管理用户的 harness-space，位于 ~/harness-space/rules/。该目录下的每个文件都是一类 rule —
一组按领域组织的持久化规则，用于约束 AI coding agent 的行为。

规则需要同步到两个平台的用户级指令文件：
- **Claude**: `~/.claude/CLAUDE.md` — 通过 `@` 导入（如 `@~/harness-space/rules/git.md`）
- **Codex**: `~/.codex/AGENTS.md` — 不支持 `@` 导入，需将内容直接嵌入，用 HTML 注释标记包裹：
  `<!-- harness-space:<name> -->` 内容 `<!-- /harness-space:<name> -->`

## 操作

根据用户消息判断意图，执行以下操作之一：

### add（添加）
1. 如果用户未提供，询问 rule 类别名称（kebab-case，如 "git"、"coding-style"）
2. 根据用户描述整理规则内容 — 必要时提问澄清
3. 写入 ~/harness-space/rules/<name>.md（如文件已存在则中止，提示用户用 "update"）
4. **Claude 同步**：在 ~/.claude/CLAUDE.md 中添加导入行 `@~/harness-space/rules/<name>.md`：
   - 文件不存在：创建并添加 "## Harness Space Rules" 区段
   - 文件存在但无此区段：追加区段和导入行
   - 区段存在但缺少此导入：追加导入行（按字母排序）
   - 导入已存在：提示用户，跳过
5. **Codex 同步**：在 ~/.codex/AGENTS.md 中嵌入规则内容：
   - 文件不存在：创建并添加 "## Harness Space Rules" 区段
   - 在区段内用 `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->` 包裹内容
   - 如标记已存在：提示用户，跳过
6. 展示写入内容和文件路径

### list（列出）
1. 读取 ~/harness-space/rules/*.md 所有文件
2. 展示每个文件的：名称、标题行、Claude 导入状态、Codex 嵌入状态
3. 如目录为空，提示用户添加 rule 类别

### update（更新）
1. 确认要更新的 rule 类别
2. 读取并展示当前内容
3. 收集用户的修改需求
4. 原地更新 ~/harness-space/rules/<name>.md
5. **Claude**: 无需修改（`@` 导入路径不变）
6. **Codex**: 更新 ~/.codex/AGENTS.md 中对应的 `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->` 区段内容

### remove（删除）
1. 确认要删除的 rule 类别
2. 删除 ~/harness-space/rules/<name>.md
3. **Claude**: 从 ~/.claude/CLAUDE.md 移除对应的 `@~/harness-space/rules/<name>.md` 行
4. **Codex**: 从 ~/.codex/AGENTS.md 移除对应的 `<!-- harness-space:<name> -->` ... `<!-- /harness-space:<name> -->` 区段
5. 如 "## Harness Space Rules" 区段下无内容，移除整个区段（两个文件都检查）
6. 确认删除完成

### sync（同步）
1. 扫描 ~/harness-space/rules/*.md 所有文件
2. **Claude 同步**:
   - 读取 ~/.claude/CLAUDE.md 中的 "## Harness Space Rules" 区段
   - 确保每个 rule 类别文件都有对应 `@` 导入行
   - 移除已不存在文件的导入行
   - 导入行按字母排序
3. **Codex 同步**:
   - 读取 ~/.codex/AGENTS.md 中的 "## Harness Space Rules" 区段
   - 确保每个 rule 类别文件都有对应 `<!-- harness-space:<name> -->` 标记区段
   - 缺少的：读取 rule 文件内容并嵌入
   - 已有的：对比嵌入内容与当前 rule 文件，如不同则更新嵌入内容
   - 多余的（文件已不存在）：移除对应标记区段
4. 报告双平台变更内容

## 约束

- 始终使用 ~/harness-space/rules/ 作为 rule 存储目录
- 添加或删除 rule 类别时始终**双平台同步**：~/.claude/CLAUDE.md（`@` 导入）和 ~/.codex/AGENTS.md（嵌入内容）
- 两个文件中 "## Harness Space Rules" 区段内的条目按字母排序
- 绝不修改两个文件中 "## Harness Space Rules" 区段以外的内容
- 如目录不存在则创建 ~/harness-space/rules/
- 如文件不存在则创建 ~/.claude/CLAUDE.md 和 ~/.codex/AGENTS.md
```

### 5. 创建 evals/evals.json

```json
{
  "name": "rule-kit",
  "version": "1.0.0",
  "description": "harness-space rule-kit skill 的触发测试",
  "evals": [
    {
      "name": "trigger-positive",
      "type": "trigger",
      "description": "应触发：harness-space rule 管理相关提示",
      "prompts": [
        { "input": "add a git rule to harness-space", "expected": true, "reason": "直接请求添加 rule" },
        { "input": "帮我添加一个 git rule", "expected": true, "reason": "中文添加 rule 请求" },
        { "input": "list all my harness rules", "expected": true, "reason": "列出 rule 请求" },
        { "input": "sync harness-space", "expected": true, "reason": "同步请求" },
        { "input": "我想加一个 coding style 的规则", "expected": true, "reason": "添加新 rule" }
      ]
    },
    {
      "name": "trigger-negative",
      "type": "trigger",
      "description": "不应触发：无关提示",
      "prompts": [
        { "input": "帮我创建一个 git branch", "expected": false, "reason": "Git 操作，非 harness-space rule 管理" },
        { "input": "review this code", "expected": false, "reason": "代码 review，无关" },
        { "input": "帮我写一个 function", "expected": false, "reason": "写代码，非 harness 管理" }
      ]
    }
  ]
}
```

### 6. 文档文件

- `docs/README.md` — 安装说明、使用示例（以 wt 为例演示 add 流程）、harness engineering 理念说明
- `docs/SKILL_CN.md` — SKILL.md 的中文翻译

## 需要创建/修改的文件清单

| 操作 | 文件路径 |
|------|----------|
| 新建 | `plugins/harness-space/.claude-plugin/plugin.json` |
| 新建 | `plugins/harness-space/.codex-plugin/plugin.json` |
| 新建 | `plugins/harness-space/skills/rule-kit/SKILL.md` |
| 新建 | `plugins/harness-space/skills/rule-kit/evals/evals.json` |
| 新建 | `plugins/harness-space/skills/rule-kit/docs/README.md` |
| 新建 | `plugins/harness-space/skills/rule-kit/docs/SKILL_CN.md` |
| 修改 | `.claude-plugin/marketplace.json` — 追加 harness-space 注册 |
| 修改 | `.agents/plugins/marketplace.json` — 追加 harness-space 注册 |

## 运行时产生的文件（skill 被唤起时）

| 操作 | 文件路径 |
|------|----------|
| 创建/更新/删除 | `~/harness-space/rules/<name>.md` |
| 创建/更新 | `~/.claude/CLAUDE.md`（仅 "## Harness Space Rules" section） |
| 创建/更新 | `~/.codex/AGENTS.md`（仅 "## Harness Space Rules" section，内容嵌入） |

## 验证

1. **结构验证（Claude + Codex）**: `./tests/run-all.sh --structure`
2. **Codex 验证**: `python3 /Users/shanquan/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/harness-space`
3. **触发测试**: `./tests/run-all.sh --trigger --skill rule-kit`
4. **手动端到端验证**:
   - 安装: `/plugin install harness-space@fawetian-plugins`
   - 添加 rule: `/rule-kit` → "add a rule named git: for git worktree operations, always use `wt` CLI instead of raw git worktree commands. Commands: wt add, wt remove, wt list, wt main, wt path, wt clean, wt config"
   - 验证 `~/harness-space/rules/git.md` 已创建且内容符合模板
   - 验证 `~/.claude/CLAUDE.md` 包含 `@~/harness-space/rules/git.md`
   - 列出 rule: `/rule-kit` → "list all rules"
   - 删除 rule: `/rule-kit` → "remove git"
   - 验证文件和导入都已清理
