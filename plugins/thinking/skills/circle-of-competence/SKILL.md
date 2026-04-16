---
name: circle-of-competence
description: Circle of Competence — define the boundary between what you know well and what you don't. Use when making decisions outside your domain, delegating, hiring, or when you suspect overconfidence. Triggers: "circle of competence", "能力圈", "what do I actually know", "我真的懂吗", "outside my expertise", "超出我的专业", "know your limits", "认清边界", "overconfidence".
userInvocable: true
---

# Circle of Competence (能力圈)

## Core Philosophy
**Knowing what you don't know is more valuable than what you do know.** The edge of your circle is where expensive mistakes happen.

## Constraints
- ALL output must be in Chinese (中文)
- Must be honest — the exercise only works with intellectual honesty
- Must produce actionable boundaries, not just vague admissions
- Use `templates/competence-map.md` as output structure

## When to Use
- 做跨领域决策时
- 决定是否自己做 vs 委派/咨询
- 评估自己或团队能力
- 招聘决策
- 发现自己在信心满满地谈论不熟悉的领域

## When NOT to Use
- 需要学习新领域（→ `feynman-technique` 先学）
- 需要分析具体问题（→ `five-whys` / `mece`）
- 需要快速行动（→ `ooda-loop`）

## Workflow

### Step 1: 选择评估领域
> "我要评估我在 _______ 领域的能力边界。"

### Step 2: 绘制三环

```
┌──────────────────────────────┐
│      不知道自己不知道          │  ← 盲区（最危险）
│  ┌─────────────────────┐     │
│  │  知道自己不知道       │     │  ← 认知边界（可以学习或求助）
│  │  ┌──────────────┐   │     │
│  │  │ 知道自己知道   │   │     │  ← 核心能力圈
│  │  └──────────────┘   │     │
│  └─────────────────────┘     │
└──────────────────────────────┘
```

### Step 3: 填充核心能力圈
列出你确实掌握的知识/技能，标准严格：
- **能教别人** = 真的懂
- **能在压力下使用** = 真的熟练
- **做过真实项目** = 有实战经验

| 我确实掌握的 | 证据（项目/经验/年限） | 置信度 |
|-------------|---------------------|--------|
| ... | ... | 高/中 |

### Step 4: 填充认知边界
列出你知道自己不懂的：

| 我知道我不懂的 | 缺什么 | 重要性 | 行动 |
|---------------|--------|--------|------|
| ... | 经验/知识/训练 | 高/中/低 | 学习/委派/咨询 |

### Step 5: 探索盲区
最难的部分——你不知道你不知道什么。启发方法：
- 问该领域的专家："我可能忽略了什么？"
- 回忆最近的意外（意外 = 盲区的信号）
- 检查过去自信但事后证明错误的判断

| 潜在盲区 | 发现方式 | 风险 |
|---------|---------|------|
| ... | 专家反馈/事后回顾/意外事件 | ... |

### Step 6: 制定决策规则

| 决策类型 | 在能力圈内？ | 策略 |
|---------|------------|------|
| 我擅长的领域 | 圈内 | 自主决策 |
| 有一定了解 | 边界 | 做决策但寻求 review |
| 不太了解 | 圈外 | 委派给专家，自己学习 |
| 完全未知 | 盲区 | 先承认无知，再找导师 |

## Output
生成能力圈评估。使用 `templates/competence-map.md` 模板。

## See Also
- `feynman-technique` — 费曼学习法：扩展能力圈边界
- `scout-mindset` — 侦察兵心态：诚实面对能力边界
- `steelmanning` — 稻草人加强：尊重别人的能力圈
- `thinking-selector` — 不确定用哪个？
