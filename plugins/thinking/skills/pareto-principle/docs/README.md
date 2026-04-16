# Pareto Principle (帕累托 / 80-20 法则)

## SKILL_CN.md
完整的中文文档见 `SKILL_CN.md`

## Overview

Identify the vital few inputs that drive the majority of outcomes. Focus on the 20% that produces 80% of results.

找到驱动大部分产出的关键少数。聚焦产出 80% 结果的 20% 输入。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:pareto-principle

# Auto-trigger examples
"用 80/20 法则分析这个项目的优先级"
"帕累托分析：哪些功能贡献了最多价值"
"help me prioritize — which 20% of work gives 80% of value?"
```

## Workflow

1. **列出所有输入项** — 所有候选任务/因素
2. **估算影响分布** — 量化或打分每项贡献
3. **排序并画分布** — 按影响从大到小，计算累计百分比
4. **画线找关键少数** — 在累计 ~80% 处划分
5. **决策** — 关键少数优先投入，琐碎多数延后/砍掉

## Output

Generates a priority analysis report with impact distribution and vital-few identification.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 资源有限需要聚焦 | 所有选项同等重要 (安全合规清单) |
| 任务清单过长需要砍 scope | 需要穷尽不遗漏 (-> `mece`) |
| 优化投入产出比 | 问题是"怎么想"而非"做什么" (-> `first-principles`) |
