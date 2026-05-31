---
name: rule-kit
description: "管理 ~/harness-space/rules/ 中的 harness-space rules。每个文件是一类 rule。初始化、添加、列出、更新、删除、同步或提交推送约束 AI agent 行为的规则。触发词：rule, add rule, harness, harness-space, list rules, sync harness, init harness, commit harness, worktree rule, coding style, rule-kit"
userInvocable: true
---

你管理用户的 harness-space，位于 ~/harness-space/rules/。该目录下的每个文件都是一类 rule — 一组按领域组织的持久化规则，用于约束 AI coding agent 的行为。

**仓库地址**: https://github.com/fawetian/harness-space

规则需要同步到两个平台的用户级指令文件：

- **Claude**: `~/.claude/CLAUDE.md` — 通过 `@` 导入（如 `@~/harness-space/rules/git.md`）
- **Codex**: `~/.codex/AGENTS.md` — 不支持 `@` 导入，需将内容直接嵌入，用 HTML 注释标记包裹：
  `<!-- harness-space:<name> -->` ... 内容 ... `<!-- /harness-space:<name> -->`

## 操作

根据用户消息判断意图，执行以下操作之一：

### init（初始化）
1. 检查 ~/harness-space 是否存在且为 git 仓库
2. **未克隆**:
   - 执行 `git clone https://github.com/fawetian/harness-space.git ~/harness-space`
   - 如克隆失败：告知用户错误信息并停止
   - 克隆成功后：报告结果并列出已有的 rule 类别（如有）
3. **已克隆**:
   - 执行 `git -C ~/harness-space pull`
   - 报告变更内容（新提交）或已是最新
4. 确保 ~/harness-space/rules/ 目录存在

### commit（提交推送）
1. 确认 ~/harness-space 存在且为 git 仓库 — 如不是，建议先执行 "init"
2. 展示当前 git 状态（`git -C ~/harness-space status --short`）
3. 如无变更：提示用户，如有未推送的提交则推送
4. 暂存所有变更（`git -C ~/harness-space add -A`）
5. 根据变更内容生成描述性提交信息（如 "feat: add git rule"、"update: coding-style rule"）
6. 推送到远程（`git -C ~/harness-space push`）
7. 报告成功及提交哈希

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
4. 更新 ~/harness-space/rules/<name>.md
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
