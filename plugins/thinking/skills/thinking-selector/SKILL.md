---
name: thinking-selector
description: Thinking tool selector — helps choose the right mental model for a given problem. Use when unsure which thinking framework to apply, when facing a complex problem that needs structured thinking, or when wanting to explore available thinking tools. Triggers: "thinking tool", "思维工具", "which framework", "how should I think about", "用什么方法思考", "帮我分析", "structured thinking".
userInvocable: true
---

# Thinking Tool Selector (思维工具选择器)

## Core Philosophy
**The right tool for the right problem.** Don't force a framework — match the problem's nature to the framework designed for it.

## Constraints
- ALL output must be in Chinese (中文)
- Always explain WHY a framework fits, not just WHICH one
- Recommend 1 primary + 1-2 complementary tools max

## Decision Tree

### Step 1: Classify the Problem

Ask yourself: **这个问题的本质是什么？**

```
问题是什么类型？
├── 需要拆解 → 进入「分解与澄清」
│   ├── 挑战现有假设/行业惯例？ → first-principles (第一性原理)
│   ├── 需要不重不漏地分类？ → mece (MECE)
│   ├── 反复出现的故障/问题？ → five-whys (五个为什么)
│   └── 学习新领域/验证理解？ → feynman-technique (费曼学习法)
│
├── 需要决策 → 进入「决策与速度」
│   ├── 时间紧迫/竞争环境？ → ooda-loop (OODA 循环)
│   ├── 解释过于复杂/阴谋论？ → occam-hanlon-razor (奥卡姆/汉隆剃刀)
│   ├── 资源有限需聚焦？ → pareto-principle (帕累托 80/20)
│   └── 任务太多需排序？ → eisenhower-matrix (艾森豪威尔矩阵)
│
├── 需要预判风险 → 进入「风险与系统」
│   ├── 评估失败路径？ → inversion (反向思维)
│   ├── 预判下游连锁反应？ → second-order-thinking (二阶思维)
│   ├── 理解复杂系统动态？ → systems-thinking (系统思考)
│   ├── 估算需要留缓冲？ → margin-of-safety (安全边际)
│   └── 重要发布前的风险检查？ → pre-mortem (事前验尸)
│
└── 需要对抗偏见 → 进入「认知健康」
    ├── 可能在为已有结论找证据？ → scout-mindset (侦察兵心态)
    ├── 在反驳别人但可能不公平？ → steelmanning (稻草人加强)
    └── 可能在能力圈外做判断？ → circle-of-competence (能力圈)
```

### Step 2: Validate the Match

Before recommending, check:
1. **时间约束**：如果 < 30 分钟决策，推荐快框架（OODA、Pareto）而非深框架（Systems Thinking）
2. **信息完备度**：信息不足时，先用 Five Whys / Feynman 收集，再用决策框架
3. **利益相关方**：多方参与时优先 MECE + Steelmanning 保证公平性

### Step 3: Output Recommendation

Format:

```markdown
## 🧠 推荐思维工具

**主工具**：{skill-name} ({中文名})
> {一句话说明为什么匹配}

**辅助工具**：{skill-name} ({中文名})
> {搭配使用的理由}

**使用方式**：
`/skill thinking:{skill-name}`
```

## See Also
All available thinking skills are listed in the decision tree above. Start with the primary recommendation and chain complementary tools as needed.
