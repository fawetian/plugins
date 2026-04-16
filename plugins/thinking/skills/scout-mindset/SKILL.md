---
name: scout-mindset
description: Scout Mindset — actively seek truth rather than defending existing beliefs. Use during code reviews, design discussions, disagreements, or when you suspect confirmation bias. Triggers: "scout mindset", "侦察兵心态", "am I biased", "我有偏见吗", "confirmation bias", "确认偏误", "devil's advocate", "challenge my thinking", "验证我的想法".
userInvocable: true
---

# Scout Mindset (侦察兵心态)

## Core Philosophy
**A scout's job is to map the territory accurately, not to win the battle.** The goal is to see reality as it is, not as you wish it were.

## Constraints
- ALL output must be in Chinese (中文)
- Must explicitly name the belief being examined
- Must seek genuine disconfirming evidence, not strawmen
- Use `templates/scout-assessment.md` as output structure

## When to Use
- 代码评审时发现自己在辩护而非理解
- 设计讨论中感到"我的方案一定更好"
- 做决策时只看到支持信息
- 被别人反对时第一反应是反驳

## When NOT to Use
- 需要快速行动不需反思（→ `ooda-loop`）
- 明确需要结构化分析（→ `mece`）
- 问题是技术性的不涉及观点（→ `five-whys`）

## Soldier vs Scout

| | Soldier (士兵心态) | Scout (侦察兵心态) |
|---|---|---|
| **目标** | 赢得辩论 | 看清真相 |
| **对待反对意见** | 反驳 | 好奇 |
| **对待自己的错误** | 防御 | 更新 |
| **问的问题** | "怎么证明我是对的？" | "如果我错了呢？" |
| **评判标准** | 我是否说服了别人？ | 我的地图是否更准确了？ |

## Workflow

### Step 1: 命名你的信念
把你持有的观点/假设明确写出来：
> "我相信 _______ 。"
> "这个信念对我的决策影响是 _______ 。"

### Step 2: 偏见自检
对照常见偏见清单：
- [ ] **确认偏误**：我是不是只看了支持我的证据？
- [ ] **沉没成本**：我是不是因为已经投入太多而不愿放弃？
- [ ] **可得性偏误**：我是不是被最近/最显眼的案例影响？
- [ ] **锚定效应**：我的判断是不是被最初的数字/印象锚住了？
- [ ] **群体思维**：我是不是因为大家都这么想所以同意？
- [ ] **专家偏误**：我是不是在能力圈外做判断？

### Step 3: 主动寻找反证
强制自己回答：
- "什么证据能说明我错了？"
- "持相反观点的聪明人，他们看到了什么我没看到的？"
- "如果我的信念是错的，世界会看起来有什么不同？"

| 反证 | 来源 | 可信度 | 对我信念的冲击 |
|------|------|--------|--------------|
| ... | ... | 高/中/低 | 强/中/弱 |

### Step 4: 更新信念
基于反证，诚实更新你的信念：
> "我之前相信 _______ （置信度 X%）。"
> "看到反证后，我现在相信 _______ （置信度 Y%）。"
> "改变的原因是 _______ 。"

### Step 5: 设计未来校验点
> "如果在 {时间点} 看到 {信号}，说明我的更新后信念也错了。"

## Output
生成信念审查报告。使用 `templates/scout-assessment.md` 模板。

## See Also
- `steelmanning` — 稻草人加强：公平对待对方观点
- `circle-of-competence` — 能力圈：划清知道和不知道的边界
- `inversion` — 反向思维：从失败角度挑战信念
- `thinking-selector` — 不确定用哪个？
