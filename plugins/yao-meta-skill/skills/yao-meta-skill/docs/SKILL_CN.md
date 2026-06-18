# Yao Meta Skill

当你需要从工作流、提示词、对话记录、文档或笔记中创建、重构、评估并打包可复用 agent skill 时，使用这个 skill。

## 适用场景

- 把反复出现的工作流沉淀为可复用 skill。
- 把提示词或笔记重构成有清晰触发边界的 skill。
- 设计 trigger eval、output eval、打包检查和发布门禁。
- 审计现有 skill 的触发漂移、可移植性、治理要求或包发布准备度。

## 不适用场景

- 普通 PRD、产品路线图、RFC、ADR、代码审查或实现计划。
- 不需要复用工作流或 skill 包的简单提示词润色。
- 单纯的 plugin marketplace 接线；只有涉及 skill 设计时才用它。
- 执行某个已有 skill 的领域工作流。

## 本地打包方式

这是上游项目 `plugins/yao-meta-skill/vendor/yao-meta-skill/` 的 wrapper。

wrapper 保持 marketplace 触发稳定，同时保留上游更新路径。上游项目包含详细方法论 references、scripts、reports、registry metadata 和生成证据。

## 安装

Claude Code:

```bash
/plugin install yao-meta-skill@fawetian-plugins
```

Codex:

```bash
codex plugin add yao-meta-skill@fawetian-plugins-codex
```
