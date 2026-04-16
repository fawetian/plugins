---
name: inversion
description: Inversion thinking — flip the problem and ask "how would I guarantee failure?" to find hidden risks and better solutions. Use for risk assessment, architecture decisions, or pre-launch reviews. Triggers: "inversion", "反向思维", "逆向思维", "how to fail", "如何失败", "what could go wrong", "flip the problem", "avoid failure".
userInvocable: true
---

# Inversion (反向思维)

## Core Philosophy
**Instead of asking "How do I succeed?", ask "How would I guarantee failure?" Then avoid those things.**

## Constraints
- ALL output must be in Chinese (中文)
- Must generate at least 5 failure paths before proposing solutions
- Solutions must directly counter specific failure paths
- Use `templates/inversion-analysis.md` as output structure

## When to Use
- 架构选型：评估方案风险
- 产品发布前：识别致命缺陷
- 团队决策：对抗乐观偏误
- 人生/职业重大决策

## When NOT to Use
- 已知失败原因需要深挖（→ `five-whys`）
- 需要从零构建而非规避风险（→ `first-principles`）
- 时间紧迫只能向前冲（→ `ooda-loop`）

## Workflow

### Step 1: 定义成功
用一句话描述"成功"是什么样的：
> "成功意味着 _______ 。"

### Step 2: 反转——设计失败
假设你是一个破坏者，目标是**保证这件事失败**。列举所有能导致失败的方法：

| # | 失败路径 | 严重程度 | 发生概率 |
|---|---------|---------|---------|
| 1 | ... | 致命/严重/一般 | 高/中/低 |
| 2 | ... | ... | ... |
| 3 | ... | ... | ... |
| 4 | ... | ... | ... |
| 5 | ... | ... | ... |

**引导问题**：
- 如果想让这个项目 100% 失败，我会做什么？
- 如果想让用户彻底放弃，我会做什么？
- 如果想让团队内耗最大化，我会做什么？

### Step 3: 排序失败路径
按 "严重程度 × 发生概率" 排优先级：
- **致命 + 高概率** → 必须解决
- **致命 + 低概率** → 需要安全网
- **一般 + 高概率** → 流程中预防

### Step 4: 反转回来——设计成功
对每个高优先级失败路径，设计其反面作为成功策略：

| 失败路径 | 反转策略 | 具体行动 |
|---------|---------|---------|
| {如果 X} | {确保不 X} | {具体做什么} |

### Step 5: 整合为行动清单
把反转策略合并为一个连贯的行动计划，按优先级排序。

## Output
生成反向分析报告。使用 `templates/inversion-analysis.md` 模板。

## See Also
- `pre-mortem` — 事前验尸：Inversion 的团队协作版本
- `second-order-thinking` — 二阶思维：预判反转策略的下游影响
- `margin-of-safety` — 安全边际：为"致命+低概率"路径留缓冲
- `thinking-selector` — 不确定用哪个？
