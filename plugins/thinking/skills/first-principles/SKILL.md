---
name: first-principles
description: First principles thinking — break problems down to fundamental truths and rebuild solutions from scratch. Use when challenging assumptions, designing novel systems, or escaping analogy-based reasoning. Triggers: "first principles", "第一性原理", "fundamental assumptions", "from scratch", "challenge assumption", "why do we assume", "重新思考".
userInvocable: true
---

# First Principles Thinking (第一性原理)

## Core Philosophy
**Reason from atoms, not analogies.** Decompose a problem until you reach truths that cannot be deduced further, then rebuild the solution.

## Constraints
- ALL output must be in Chinese (中文)
- Always produce a "假设清单 → 不可约事实 → 重新构建" 三段式
- Use `templates/decomposition-worksheet.md` as output structure

## When to Use
- 现有方案被"行业惯例"束缚
- 成本结构被认为是定数
- 新领域 / 无先例问题
- 被问"为什么不能 X？"时回答都是"因为一直都是这样"

## When NOT to Use
- 时间紧迫的执行性任务（→ `ooda-loop`）
- 协作中需要快速对齐框架（→ `mece`）
- 问题已有明确根因需要深挖（→ `five-whys`）

## Workflow

### Step 1: 列出当前方案的所有假设
把现状拆解为一条条独立的假设。不评判，只列举。

**输出格式**：
| # | 假设 | 来源 |
|---|------|------|
| 1 | ... | 事实 / 类比 / 习惯 / 权威 |

### Step 2: 标记每个假设的来源
逐条标注来源类型：
- **事实**：可验证的物理/数学/数据约束
- **类比**：因为别人这么做所以我们也这么做
- **习惯**：因为一直都是这样
- **权威**：因为某个专家/领导说的

### Step 3: 质疑非事实假设
对每个"类比/习惯/权威"来源的假设提问：
- 去掉这个假设，最坏结果是什么？
- 这个假设在什么条件下不成立？
- 有无反例？

### Step 4: 从剩余事实重新构建方案
只保留"事实"来源的假设作为约束条件，从零设计新方案。不参考原方案。

### Step 5: 与原方案对比，标记差异
| 维度 | 原方案 | 第一性原理方案 | 差异原因 |
|------|--------|----------------|----------|
| ... | ... | ... | 去掉了假设 #X |

## Output
生成分析文档，包含上述 5 步的完整产物。使用 `templates/decomposition-worksheet.md` 模板。

## See Also
- `inversion` — 反向思维：从"如何失败"反推
- `mece` — 结构化拆分：不重不漏地分类
- `five-whys` — 根因分析：连续追问为什么
- `thinking-selector` — 不确定用哪个？
