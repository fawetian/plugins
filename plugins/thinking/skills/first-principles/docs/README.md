# First Principles Thinking (第一性原理)

## Overview

Break problems down to fundamental truths and rebuild solutions from scratch. Escape analogy-based reasoning and challenge industry defaults.

抛弃类比，回到不可再分的事实重新构建方案。突破行业惯例束缚。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:first-principles

# Auto-trigger examples
"用第一性原理重新审视我们的缓存策略"
"challenge the assumption that we need a microservice here"
"为什么我们默认用 X？从零开始想想"
```

## Workflow

1. **列出假设** — 把现状拆解为独立假设
2. **标记来源** — 区分事实 / 类比 / 习惯 / 权威
3. **质疑非事实** — 去掉每个非事实假设会怎样？
4. **从事实重建** — 只保留事实，从零设计方案
5. **新旧对比** — 标记差异和原因

## Output

Generates a decomposition worksheet with assumption inventory, irreducible facts, and rebuilt solution.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 现有方案被惯例束缚 | 时间紧迫 (→ `ooda-loop`) |
| 成本结构被当作定数 | 需要快速对齐 (→ `mece`) |
| 新领域/无先例问题 | 已有明确根因 (→ `five-whys`) |
