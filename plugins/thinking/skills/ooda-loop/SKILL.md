---
name: ooda-loop
description: OODA Loop — Observe, Orient, Decide, Act rapid decision-making cycle. Use when under time pressure, in competitive environments, or when fast iteration beats perfect planning. Triggers: "OODA", "observe orient decide act", "快速决策", "rapid decision", "time pressure", "competitive response", "紧急决策", "fast iteration".
userInvocable: true
---

# OODA Loop (OODA 循环)

## Core Philosophy
**Speed of iteration beats quality of individual decisions.** The side that cycles faster through Observe-Orient-Decide-Act wins.

## Constraints
- ALL output must be in Chinese (中文)
- Each cycle should complete in < 15 minutes of thinking time
- Bias toward action — a 70% decision now beats a 90% decision tomorrow
- Use `templates/ooda-cycle.md` as output structure

## When to Use
- 时间紧迫，不能等完美信息
- 对抗性/竞争性环境（市场窗口、incident response）
- 需要快速试错迭代
- 计划赶不上变化

## When NOT to Use
- 决策不可逆且代价巨大（→ `inversion` + `margin-of-safety`）
- 有充足时间做深度分析（→ `systems-thinking`）
- 需要 team alignment 而非个人判断（→ `mece` 做共识）

## Workflow

### Step 1: Observe (观察)
收集当前可获取的事实。不追求完美，追求"够用"：
- 当前状态是什么？（数据、日志、用户反馈）
- 环境发生了什么变化？
- 竞争对手/对手方在做什么？

**时间盒**：5 分钟内完成

### Step 2: Orient (定向)
这是 OODA 最关键的一步——把观察到的事实放入背景中理解：
- 我的心智模型是否还适用？
- 有哪些认知偏见可能影响判断？
- 历史经验是否适用于当前情况？
- 对方的 OODA 循环可能处于哪个阶段？

**关键问题**："如果我错了，最可能错在哪里？"

### Step 3: Decide (决策)
基于 Orient 的理解，做出决策：
- 选择一个行动方案
- 明确"什么信号出现说明决策错误"（预设退出条件）
- 设定下一次 Observe 的时间点

**决策格式**：
> 我决定 _______ ，因为 _______ 。
> 如果看到 _______ ，说明需要调整。
> 下次检查点：_______ 。

### Step 4: Act (行动)
执行决策，同时开始下一轮 Observe：
- 执行行动
- 记录执行结果
- 立即进入下一个循环

### Step 5: 循环复盘
3 个循环后暂停，检查：
- 循环速度是否在加快？（好信号）
- Orient 阶段是否在更新心智模型？（好信号）
- 是否在重复同样的错误？（坏信号→ 退出 OODA，换 `five-whys`）

## Output
生成 OODA 循环记录，包含每轮的观察-定向-决策-行动。使用 `templates/ooda-cycle.md` 模板。

## See Also
- `eisenhower-matrix` — 艾森豪威尔：紧急/重要分类后再 OODA
- `pareto-principle` — 帕累托：聚焦 20% 关键行动
- `margin-of-safety` — 安全边际：不可逆决策的缓冲
- `thinking-selector` — 不确定用哪个？
