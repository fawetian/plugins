# 5W2H

## Overview

Clarify a fuzzy task, requirement, project, or plan with seven questions: What, Why, Who, When, Where, How, and How much.

用 What / Why / Who / When / Where / How / How much 七个问题，把模糊任务、需求、项目或计划问清楚。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:5w2h

# Auto-trigger examples
"用 5W2H 澄清这个需求"
"这个项目还很模糊，先把事情问清楚"
"who does what by when, and how much will it cost?"
```

## Workflow

1. **定义对象** — 明确要澄清的任务/需求/项目
2. **填写 5W2H** — What / Why / Who / When / Where / How / How much
3. **识别阻塞项** — 只列出影响行动的未知问题
4. **生成执行简报** — 目标、范围、负责人、交付物、时间、方法、资源
5. **选择下一步工具** — 进入 MECE、OODA、Five Whys 或 Feynman

## Output

Generates a clarification table, blocker list, and execution brief.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 需求/任务/项目还模糊 | 已发生问题要追根因 (→ `five-whys`) |
| 写 PRD 或计划前 | 已清楚对象，只需分类 (→ `mece`) |
| 委派任务前 | 需要判断优先级 (→ `pareto-principle` / `eisenhower-matrix`) |
