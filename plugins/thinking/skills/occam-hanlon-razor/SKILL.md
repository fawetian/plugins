---
name: occam-hanlon-razor
description: "Occam's Razor and Hanlon's Razor — prefer simpler explanations and don't attribute to malice what stupidity explains. Use when suffering analysis paralysis, seeing conspiracy where there is none, or debugging complex systems. Triggers: \"occam\", \"hanlon\", \"奥卡姆\", \"汉隆\", \"剃刀\", \"simplest explanation\", \"最简单的解释\", \"analysis paralysis\", \"过度分析\", \"is this a conspiracy\"."
userInvocable: true
---

# Occam's Razor & Hanlon's Razor (奥卡姆剃刀 & 汉隆剃刀)

## Core Philosophy
- **Occam's (奥卡姆)**：同等条件下，最简单的解释最可能是正确的
- **Hanlon's (汉隆)**：能用无知解释的，不要归因于恶意

## Constraints
- ALL output must be in Chinese (中文)
- Always list competing explanations before applying razors
- Razors are heuristics, not proofs — flag when they might mislead
- Use `templates/razor-analysis.md` as output structure

## When to Use
- 分析瘫痪：想得太多，决策不了
- 阴谋论倾向："他们是不是故意的？"
- Debug 时：复杂理论 vs 简单 bug
- 多个假说竞争时的筛选

## When NOT to Use
- 确有恶意或已知对抗场景（安全事件）
- 问题确实复杂，简化会丢失关键信息（→ `systems-thinking`）
- 需要深入根因而非快速判断（→ `five-whys`）

## Workflow

### Step 1: 列出所有竞争解释
把当前情况的所有可能解释列出来，不筛选：

| # | 解释 | 复杂度 | 需要假设数 |
|---|------|--------|-----------|
| 1 | ... | 低/中/高 | X 个 |
| 2 | ... | ... | ... |

### Step 2: 应用奥卡姆剃刀
按"需要假设数"排序，最少假设的排最前：
- 每增加一个假设，出错概率乘以该假设错误的概率
- 问："去掉哪个假设后解释依然成立？"→ 去掉它

### Step 3: 应用汉隆剃刀
对涉及"某人故意为之"的解释：
- 替换为"某人不知道/犯了错/偷懒"是否同样能解释？
- 如果能 → 优先采纳非恶意解释
- 如果不能（有明确恶意证据）→ 保留，但标记为"需要额外证据"

### Step 4: 得出最佳解释
选择假设最少 + 不依赖恶意假设的解释作为首选。

**但要声明例外条件**：
> 当前最佳解释是 _______ 。
> 如果发现 _______ ，则需要重新评估。

### Step 5: 检查剃刀失效条件
剃刀可能误导的场景（主动检查）：
- 涌现行为：简单规则产生复杂结果
- 制度性问题：个体无恶意但系统有恶果
- 多因叠加：每个因素都简单，但组合起来产生意外

## Output
生成剃刀分析报告。使用 `templates/razor-analysis.md` 模板。

## See Also
- `five-whys` — 五个为什么：剃刀选定方向后深挖根因
- `scout-mindset` — 侦察兵心态：对抗确认偏误
- `first-principles` — 第一性原理：剃刀不够用时回到基本事实
- `thinking-selector` — 不确定用哪个？
