# Thinking Selector (思维工具选择器)

## Overview

Don't know which thinking tool to use? Start here. The selector analyzes your problem type and recommends the best-fit mental model.

不知道用哪个思维工具？从这里开始。选择器分析问题类型并推荐最匹配的心智模型。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:thinking-selector

# Auto-trigger examples
"帮我分析这个问题该用什么思考方法"
"I need to think about this more structured"
"用什么方法思考"
```

## How It Works

1. Classifies your problem into one of 4 categories: decomposition, decision-making, risk assessment, or bias correction
2. Considers time constraints and information availability
3. Recommends 1 primary tool + 1-2 complementary tools
4. Explains WHY the match works

## Decision Tree

```
问题类型？
├── 需要拆解 → first-principles / mece / five-whys / feynman-technique
├── 需要决策 → ooda-loop / occam-hanlon-razor / pareto-principle / eisenhower-matrix
├── 需要预判风险 → inversion / second-order-thinking / systems-thinking / margin-of-safety / pre-mortem
└── 需要对抗偏见 → scout-mindset / steelmanning / circle-of-competence
```
