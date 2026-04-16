---
name: eisenhower-matrix
description: Eisenhower Matrix — classify tasks by urgency and importance to decide what to do, delegate, schedule, or eliminate. Use when overwhelmed with tasks, struggling to prioritize, or mixing urgent with important. Triggers: "eisenhower", "艾森豪威尔", "urgent vs important", "紧急重要", "task prioritization", "任务排序", "overwhelmed", "too many tasks", "事情太多".
userInvocable: true
---

# Eisenhower Matrix (艾森豪威尔矩阵)

## Core Philosophy
**What is important is seldom urgent, and what is urgent is seldom important.** Separate the two to stop firefighting and start leading.

## Constraints
- ALL output must be in Chinese (中文)
- Every task must be placed in exactly one quadrant
- Challenge items in Q1 (urgent+important) — most are misclassified
- Use `templates/eisenhower-matrix.md` as output structure

## When to Use
- 事情太多，不知道先做哪个
- 总在救火，没时间做重要但不紧急的事
- 团队需要对齐优先级
- 个人时间管理

## When NOT to Use
- 只有一件事需要做（直接做）
- 需要按影响力排序而非时间维度（→ `pareto-principle`）
- 需要深度分析问题而非排序（→ `first-principles`）

## Workflow

### Step 1: 列出所有待办
不筛选，全部列出：

| # | 任务 | 截止日期 | 利益相关方 |
|---|------|---------|-----------|
| 1 | ... | ... | ... |

### Step 2: 定义"紧急"和"重要"
- **紧急**：有外部截止日期 / 他人在等 / 延迟会造成损失
- **重要**：对长期目标有贡献 / 影响核心指标 / 不可逆

### Step 3: 分类到四象限

```
                    紧急                 不紧急
         ┌─────────────────┬─────────────────┐
  重要   │   Q1: 立即做     │   Q2: 计划做     │
         │   (DO)           │   (SCHEDULE)     │
         │                  │                  │
         ├─────────────────┼─────────────────┤
  不重要 │   Q3: 委派       │   Q4: 消除       │
         │   (DELEGATE)     │   (ELIMINATE)    │
         │                  │                  │
         └─────────────────┴─────────────────┘
```

### Step 4: 质疑 Q1
Q1（紧急+重要）应该是最少的。如果 Q1 任务太多，逐个问：
- "如果推迟一天，真的会有严重后果吗？" → 不是 → 移到 Q2
- "这件事只能我做吗？" → 不是 → 移到 Q3
- "这件事对长期目标有贡献吗？" → 没有 → 移到 Q3 或 Q4

### Step 5: 执行策略

| 象限 | 策略 | 时间分配 |
|------|------|---------|
| Q1 | 立即执行，亲自做 | 尽量 < 20% |
| Q2 | 安排固定时间块，保护不被打断 | 目标 > 50% |
| Q3 | 明确委派对象，设检查点 | 委派后跟进 |
| Q4 | 勇敢砍掉，或自动化 | 趋近 0% |

**核心指标**：Q2 的时间占比是否 > Q1？如果不是，说明还在救火模式。

## Output
生成优先级矩阵。使用 `templates/eisenhower-matrix.md` 模板。

## See Also
- `pareto-principle` — 帕累托：按影响力再聚焦 Q2
- `ooda-loop` — OODA：Q1 任务的快速执行
- `second-order-thinking` — 二阶思维：Q2 任务的长期价值评估
- `thinking-selector` — 不确定用哪个？
