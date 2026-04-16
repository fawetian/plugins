# Eisenhower Matrix (艾森豪威尔矩阵)

## SKILL_CN.md
完整的中文文档见 `SKILL_CN.md`

## Overview

Classify tasks by urgency and importance to decide what to do, delegate, schedule, or eliminate.

按紧急程度和重要程度对任务分类，决定立即做、计划做、委派、还是消除。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:eisenhower-matrix

# Auto-trigger examples
"用艾森豪威尔矩阵整理一下这些任务"
"紧急重要矩阵：帮我做任务排序"
"I'm overwhelmed with too many tasks, help me sort by urgent vs important"
```

## Workflow

1. **列出所有待办** — 不筛选，全部列出
2. **定义紧急和重要** — 明确分类标准
3. **分类到四象限** — Q1 立即做 / Q2 计划做 / Q3 委派 / Q4 消除
4. **质疑 Q1** — 如果 Q1 太多，逐个重新评估
5. **执行策略** — Q2 时间占比应 > Q1

## Output

Generates a priority matrix with four quadrants and execution strategies.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 事情太多，不知道先做哪个 | 只有一件事需要做 (直接做) |
| 总在救火，没时间做重要的事 | 需要按影响力排序 (-> `pareto-principle`) |
| 团队需要对齐优先级 | 需要深度分析问题 (-> `first-principles`) |
