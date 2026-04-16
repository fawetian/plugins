---
name: pre-mortem
description: Pre-mortem analysis — imagine the project has already failed and work backwards to identify why. Use before important launches, kickoffs, or major decisions. Triggers: "pre-mortem", "事前验尸", "premortem", "imagine this failed", "假设失败了", "what could kill this project", "risk review", "launch readiness", "发布前检查".
userInvocable: true
---

# Pre-mortem (事前验尸)

## Core Philosophy
**It's easier to identify what went wrong after failure. So imagine failure first.** A pre-mortem removes the stigma of raising concerns by making pessimism the task.

## Constraints
- ALL output must be in Chinese (中文)
- Must generate at least 7 failure scenarios
- Must include both technical and non-technical failures
- Each failure scenario needs a mitigation or kill switch
- Use `templates/pre-mortem-report.md` as output structure

## When to Use
- 重要产品发布前
- 项目 kickoff 后的首次风险评审
- 大型技术迁移启动前
- 团队决策后的"反方论证"

## When NOT to Use
- 事后复盘（→ `five-whys`，那是 post-mortem）
- 需要深度系统分析（→ `systems-thinking`）
- 问题已经很明确只需执行（→ `ooda-loop`）

## Workflow

### Step 1: 设定场景
> "今天是 {未来日期}，{项目名称} 已经彻底失败了。"

### Step 2: 自由联想失败原因
假设你是写失败报告的人。尽可能多地写出"为什么失败了"：

**技术维度**：
- 性能 / 稳定性 / 安全 / 数据

**人员维度**：
- 关键人离职 / 知识断层 / 沟通失败

**流程维度**：
- 需求变更 / 时间不够 / 依赖延迟

**外部维度**：
- 市场变化 / 竞对抢先 / 政策法规

### Step 3: 结构化失败场景

| # | 失败场景 | 维度 | 可能性 | 致命性 | 可检测性 |
|---|---------|------|--------|--------|---------|
| 1 | ... | 技术/人员/流程/外部 | 高/中/低 | 致命/严重/一般 | 早期/晚期/无法 |

### Step 4: 排序——找出"暗雷"
最危险的组合：**高可能性 + 致命 + 晚期才能检测**

### Step 5: 制定预防和应急计划

| 排名 | 失败场景 | 预防措施 | 应急方案(Kill Switch) | 检测信号 |
|------|---------|---------|---------------------|---------|
| 1 | ... | ... | ... | ... |
| 2 | ... | ... | ... | ... |

### Step 6: 更新项目计划
把 Top 3 风险的预防措施纳入项目时间线和资源分配。

## Output
生成事前验尸报告。使用 `templates/pre-mortem-report.md` 模板。

## See Also
- `inversion` — 反向思维：Pre-mortem 的简化个人版
- `margin-of-safety` — 安全边际：为高风险场景留缓冲
- `five-whys` — 五个为什么：事后复盘用
- `thinking-selector` — 不确定用哪个？
