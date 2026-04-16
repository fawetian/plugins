---
name: critical-thinking
description: Critical Thinking — systematically audit claims, evidence, and reasoning chains for logical validity and soundness. Use when assessing technical proposals, evaluating competing claims, reviewing decision rationale, auditing your own reasoning, or when someone presents a convincing-sounding argument that needs scrutiny. Triggers: "critical thinking", "批判性思维", "evaluate this argument", "评估论点", "logical fallacy", "逻辑谬误", "is this reasoning valid", "这个推理对吗", "evidence quality", "证据质量", "论证分析".
userInvocable: true
---

# Critical Thinking (批判性思维)

## Core Philosophy
**An argument is only as strong as its weakest link.** Audit the chain of reasoning — premises, evidence, warrants, and conclusion — before accepting or rejecting any claim, including your own.

## Constraints
- ALL output must be in Chinese (中文)
- Must separate "the claim" from "the evidence" from "the warrant (reasoning bridge)"
- Scan all relevant reasoning-error categories; if none found, explicitly state "未发现明显推理错误" with the categories checked
- Never dismiss an argument without stating what WOULD make it valid
- Use `templates/critical-analysis.md` as output structure

## When to Use
- 评估技术方案的论证是否站得住脚
- 有人说"X 是最佳实践"但没给出理由
- 对一个听起来很有道理但你隐隐觉得不对的论点做检验
- 审计自己刚做的推理是否经得起检验
- 需要在多个相互矛盾的信息源之间做判断
- 代码审查中评估 PR 描述中的设计论证

## When NOT to Use
- 你怀疑的是自己的偏见倾向，不是论点本身（→ `scout-mindset`）
- 你想公平对待对方观点再回应（→ `steelmanning`）
- 你需要从零重建方案（→ `first-principles`）
- 你需要找根因而非评估论证（→ `five-whys`）

## Common Reasoning Errors & Evidence Traps

### Category A: Relevance Errors (无关性错误)
| Error | Chinese | Pattern |
|-------|---------|---------|
| Ad Hominem | 人身攻击 | 攻击提出者而非论点本身 |
| Appeal to Authority | 诉诸权威 | "专家说的所以是对的" |
| Appeal to Popularity | 诉诸大众 | "大家都这么做所以是对的" |
| Appeal to Emotion | 诉诸感情 | 用情感代替证据 |
| Red Herring | 红鲱鱼 | 引入不相关话题转移注意力 |
| Appeal to Ignorance | 诉诸无知 | "没人能证明它错，所以它对" |

### Category B: Structural Errors (结构性错误)
| Error | Chinese | Pattern |
|-------|---------|---------|
| False Dichotomy | 非黑即白 | 人为制造只有两个选项 |
| Slippery Slope | 滑坡谬误 | 无依据地推演极端后果 |
| Circular Reasoning | 循环论证 | 结论即前提 |
| Straw Man | 稻草人 | 歪曲对方论点再反驳 |
| False Analogy | 错误类比 | 两个情境相似度不足以支撑推论 |
| Equivocation | 偷换概念 | 同一词在论证中含义悄悄变了 |

### Category C: Evidence & Sampling Errors (证据与抽样错误)
| Error | Chinese | Pattern |
|-------|---------|---------|
| Hasty Generalization | 以偏概全 | 从少量样本推广到全体 |
| Cherry-Picking | 选择性引用 | 只引用支持结论的证据 |
| Survivorship Bias | 幸存者偏差 | 只看成功案例忽略失败样本 |
| Base-Rate Neglect | 基率忽略 | 忽视基础概率只看个案 |

### Category D: Causal Errors (因果错误)
| Error | Chinese | Pattern |
|-------|---------|---------|
| Post Hoc | 事后归因 | "B 发生在 A 之后，所以 A 导致 B" |
| Correlation ≠ Causation | 相关非因果 | 混淆相关性和因果性 |
| Single Cause | 单一归因 | 复杂结果归因于单一原因 |

## Workflow

### Step 1: 提取论证结构
把论点拆解为标准论证结构：

> **主张 (Claim)**："_______ 。"
> **前提 (Premises)**：
> 1. _______
> 2. _______
> **证据 (Evidence)**：_______
> **论据 (Warrant)**：前提和证据如何推出结论？_______

### Step 2: 评估证据质量
对每条证据打分：

| 证据 | 类型 | 来源可信度 | 是否可验证 | 样本量 | 综合评分 |
|------|------|-----------|-----------|--------|---------|
| ... | 数据/案例/专家意见/类比 | 高/中/低 | 是/否 | 大/小/N/A | 强/中/弱 |

**证据质量等级**：
- **强**：可重复验证的数据、多源交叉验证、大样本
- **中**：可信来源的单一数据、专家共识、合理类比
- **弱**：个案经验、匿名来源、过时数据、利益相关方的声明

### Step 3: 推理错误扫描
逐类别扫描上方错误清单（A→B→C→D）。对每个发现的问题记录：

| 疑似错误 | 出现在哪 | 严重程度 | 说明 |
|---------|---------|---------|------|
| ... | 前提/推理/结论 | 致命/中等/轻微 | ... |

- **致命**：推理链条直接断裂，结论不成立
- **中等**：论证被削弱，但核心可能仍成立
- **轻微**：表述不严谨，但不影响核心逻辑

如果所有类别扫描后未发现问题，明确记录："未发现明显推理错误。已检查类别：无关性、结构性、证据抽样、因果。"

### Step 4: 评估替代解释
对于每个关键主张，至少提出一个替代解释：

> **原主张**："_______ 。"
> **替代解释 1**："_______ 。"
> **替代解释 2**："_______ 。"
> **哪个更有可能，为什么？** _______

### Step 5: 综合裁定

论证评级（1-5 星）、证据质量、逻辑严谨度、结论可靠性、最大弱点、使之成立需要什么、建议行动。

**关键原则**：永远说明"如果补充了什么，这个论点就成立了"——拒绝一个论点时要说清楚修复路径。

## Output
生成批判性分析报告。使用 `templates/critical-analysis.md` 模板。

## See Also
- `scout-mindset` — 侦察兵心态：校准思考者自身的偏见
- `steelmanning` — 稻草人加强：先公平重建对方论点再评估
- `first-principles` — 第一性原理：质疑假设并从事实重建
- `occam-hanlon-razor` — 奥卡姆/汉隆剃刀：最简解释优先
- `thinking-selector` — 不确定用哪个？
