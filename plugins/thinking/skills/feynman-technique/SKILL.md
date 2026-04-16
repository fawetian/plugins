---
name: feynman-technique
description: Feynman Technique — explain concepts in simple language to expose gaps in understanding. Use when learning new domains, verifying comprehension, teaching others, or simplifying complex topics. Triggers: "feynman", "费曼", "explain like I'm five", "简单解释", "teach me", "用大白话说", "verify understanding", "我理解对了吗", "ELI5".
userInvocable: true
---

# Feynman Technique (费曼学习法)

## Core Philosophy
**If you can't explain it simply, you don't understand it well enough.** The act of simplification exposes hidden complexity and false understanding.

## Constraints
- ALL output must be in Chinese (中文)
- Explanation must be understandable by a smart 12-year-old
- Always identify and fill at least one knowledge gap
- Use `templates/feynman-worksheet.md` as output structure

## When to Use
- 进入新领域，需要快速建立准确心智模型
- 怀疑自己或他人的理解是"伪懂"（能说术语但讲不清逻辑）
- 需要给非专业人士解释技术概念
- 评估候选人或团队成员对某领域的掌握深度

## When NOT to Use
- 已有明确问题需要诊断（→ `five-whys`）
- 需要结构化拆分（→ `mece`）
- 需要做决策而非理解（→ `ooda-loop` / `eisenhower-matrix`）

## Workflow

### Step 1: 选择概念
明确要理解的一个概念：
> "我要真正理解的概念是：_______"

### Step 2: 用大白话解释
假装对面坐着一个聪明但完全不懂这个领域的人。用以下规则写一段解释：
- 禁止使用术语（必须用时，先定义）
- 每句话不超过 20 个字
- 用类比连接到日常经验
- 用因果关系（因为 A，所以 B）串联逻辑

**模板**：
> {概念} 就像 {日常类比}。
> 它做的事情是 {一句话功能}。
> 它之所以重要，是因为 {一句话价值}。
> 它是这样工作的：{3-5 步因果链}。

### Step 3: 找到卡壳点
在写解释的过程中，标记所有"说不清楚"或"绕回术语"的地方。这些就是**知识空洞**。

| # | 卡壳点 | 我以为我懂的 | 实际上不清楚的 |
|---|--------|-------------|---------------|
| 1 | ... | ... | ... |

### Step 4: 回去学习
针对每个知识空洞：
1. 回到原始材料（代码/文档/论文）补充理解
2. 重新用大白话解释这个卡壳点
3. 如果还卡 → 说明这个点需要更深入的学习

### Step 5: 简化和类比
用一个完整的、连贯的类比重新讲述整个概念：
> "理解 {概念} 最好的方式是把它想象成 {类比}..."

**好类比的标准**：
- 结构上相似（不只是表面相似）
- 能预测行为（通过类比能推理出正确结论）
- 明确边界（类比在哪里会失效）

## Output
生成学习笔记，包含大白话解释 + 知识空洞分析 + 精炼类比。使用 `templates/feynman-worksheet.md` 模板。

## See Also
- `circle-of-competence` — 能力圈：划清懂与不懂的边界
- `first-principles` — 第一性原理：从基础事实重建理解
- `mece` — MECE：系统性组织知识结构
- `thinking-selector` — 不确定用哪个？
