---
name: 5w2h
description: "5W2H clarification — define a fuzzy task, requirement, project, or plan by answering What, Why, Who, When, Where, How, and How much. Use before execution, PRD writing, planning, delegation, or study planning when the request is vague or missing scope, owner, timing, method, or cost. Triggers: \"5W2H\", \"5w2h\", \"what why who when where how how much\", \"需求澄清\", \"任务澄清\", \"项目启动\", \"把事情问清楚\", \"who does what by when\", \"how much\"."
userInvocable: true
---

# 5W2H

## Core Philosophy
**Vague work fails quietly.** Clarify the seven basic questions before choosing a deeper thinking tool or starting execution.

## Constraints
- ALL output must be in Chinese (中文)
- Always separate known facts from unknowns
- Do not invent missing answers; mark them as "待确认"
- Use `templates/5w2h-worksheet.md` as output structure

## When to Use
- 需求、任务、项目或学习计划还很模糊
- 准备写 PRD、技术方案、执行计划或委派任务
- 对齐 "谁在什么时间用什么方式交付什么"
- 需要先收集背景，再决定是否用 MECE、OODA 或其他框架

## When NOT to Use
- 已经发生问题，需要追根因（→ `five-whys`）
- 已经清楚对象，只需要不重不漏分类（→ `mece`）
- 需要判断优先级（→ `pareto-principle` / `eisenhower-matrix`）
- 需要学习概念并暴露知识空洞（→ `feynman-technique`）

## Workflow

### Step 1: Define the object
Write the thing being clarified in one sentence:
> "我要澄清的是：_______"

### Step 2: Fill the 5W2H table

| 维度 | 问题 | 答案 | 状态 |
|------|------|------|------|
| What | 做什么？交付物是什么？ | ... | 已知/待确认 |
| Why | 为什么做？不做会怎样？ | ... | 已知/待确认 |
| Who | 谁负责？谁使用？谁审批？ | ... | 已知/待确认 |
| When | 什么时候开始、检查、交付？ | ... | 已知/待确认 |
| Where | 在哪里发生？适用范围是什么？ | ... | 已知/待确认 |
| How | 怎么做？流程、方法、约束是什么？ | ... | 已知/待确认 |
| How much | 需要多少资源、成本、数量或质量标准？ | ... | 已知/待确认 |

### Step 3: Identify blockers
List only the unknowns that block action:

| 待确认问题 | 阻塞什么决策 | 找谁确认 | 截止时间 |
|------------|--------------|----------|----------|
| ... | ... | ... | ... |

### Step 4: Produce an execution brief
Convert the answers into a concise brief:
- **目标**：...
- **范围**：...
- **负责人/相关方**：...
- **交付物**：...
- **时间点**：...
- **方法**：...
- **资源/成本/验收标准**：...

### Step 5: Decide next tool
- 信息已经清楚，但需要分类 → `mece`
- 已经进入执行，时间紧迫 → `ooda-loop`
- 发现根因问题 → `five-whys`
- 发现知识缺口 → `feynman-technique`

## Output
生成 5W2H 澄清表、待确认问题清单和执行简报。使用 `templates/5w2h-worksheet.md` 模板。

## See Also
- `mece` — 澄清后做不重不漏的结构化拆解
- `five-whys` — 问题发生后追根因
- `feynman-technique` — 学习概念并暴露知识空洞
- `thinking-selector` — 不确定用哪个？
