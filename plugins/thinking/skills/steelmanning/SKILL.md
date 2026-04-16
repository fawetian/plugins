---
name: steelmanning
description: Steelmanning — construct the strongest possible version of the opposing argument before responding. Use during design reviews, PR discussions, disagreements, or when evaluating competing approaches. Triggers: "steelman", "steelmanning", "稻草人加强", "strongest argument", "最强版本", "对方的最佳论点", "fair argument", "play devil's advocate", "other side".
userInvocable: true
---

# Steelmanning (稻草人加强)

## Core Philosophy
**Defeat the strongest version of the opposing argument, not the weakest.** If you can only beat a strawman, you haven't won anything.

## Constraints
- ALL output must be in Chinese (中文)
- The steelman must be genuinely stronger than the original — not a disguised strawman
- Must check with a "swap test" — would the other side agree this represents their best case?
- Use `templates/steelman-analysis.md` as output structure

## When to Use
- 立场对立的讨论（技术选型、设计评审）
- PR review 中对别人的方案有质疑
- 听到一个你本能反对的观点
- 需要做出二选一的决策

## When NOT to Use
- 对方的论点有事实错误（先纠正事实，再 steelman）
- 需要的是分析而非辩论（→ `mece` / `first-principles`）
- 时间紧迫无法深入讨论（→ `ooda-loop`）

## Workflow

### Step 1: 陈述对方的原始论点
如实记录对方的论点，不添加不删减：
> "对方认为 _______ 。"
> "对方的主要理由是 _______ 。"

### Step 2: 找出对方论点的核心洞察
每个有人认真持有的观点，背后都有一个合理的核心。找到它：
> "这个观点背后的核心洞察是 _______ 。"

引导问题：
- 在什么情境下这个观点是 100% 正确的？
- 对方可能看到了什么我没看到的？
- 如果对方是 X 领域的 10 年专家，他的经验支撑了什么？

### Step 3: 加强——构建最强版本
在对方的基础上，把论点加强到最强版本：
- 补充对方可能遗漏的支持性证据
- 用更精确的语言重新表述
- 找到更好的类比或框架

> **Steelman 版本**："_______ "

### Step 4: 互换测试
> "如果我把这个 steelman 版本发给对方，他们会说'是的，这就是我的意思，甚至比我说得更好'吗？"
- 如果是 → steelman 合格
- 如果不是 → 回到 Step 3 继续加强

### Step 5: 在最强版本上回应
现在针对 steelman 版本（不是原始版本）做出你的回应：

| 对方最强论点 | 我的回应 | 我承认对方对的部分 |
|-------------|---------|------------------|
| ... | ... | ... |

**关键**：先说"你说得对的是 _______"，再说"但我认为 _______"

## Output
生成 Steelman 分析报告。使用 `templates/steelman-analysis.md` 模板。

## See Also
- `scout-mindset` — 侦察兵心态：确保自己追求真相
- `circle-of-competence` — 能力圈：承认对方在某领域可能比你懂
- `second-order-thinking` — 二阶思维：双方方案的下游影响对比
- `thinking-selector` — 不确定用哪个？
