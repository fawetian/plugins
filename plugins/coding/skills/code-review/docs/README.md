# Code Review

使用多个专项 Agent 并行执行自动化代码审查，基于置信度评分过滤问题，支持 PR 模式和本地变更模式。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

在对话中明确输入 `code-review` 触发（严格触发，避免误触发）：

- `/code-review` — 审查本地未提交变更
- `/code-review <PR 编号或 URL>` — 审查指定 Pull Request

## 使用示例

**场景一：审查本地未提交的变更**

```
/code-review
```

自动获取 `git diff HEAD` 的内容，启动 5 个并行审查 Agent（CLAUDE.md 合规性、代码质量与安全、git blame 上下文、历史提交分析、代码注释检查），对每个问题进行置信度评分（0-100），过滤掉低于 80 分的问题，将结果写入文件。

**场景二：审查 Pull Request**

```
/code-review 42
```

获取 PR #42 的 diff，执行相同的多 Agent 并行审查流程，通过 `gh` 命令将审查结果作为评论发布到 PR 上（若无高置信度问题则不发布）。

**场景三：结合 CLAUDE.md 规范审查**

```
/code-review
```

自动查找变更涉及目录下的所有 CLAUDE.md 文件，将项目规范纳入审查标准，确保代码符合项目约定。

## 输出

- **本地模式**：审查结果以中文写入 `docs/code-review/{YYYY-MM-DD_HH-mm-ss}/review.md`，包含问题列表、置信度分数及文件行号引用。
- **PR 模式**：通过 `gh` 命令将审查评论发布到 GitHub Pull Request。
