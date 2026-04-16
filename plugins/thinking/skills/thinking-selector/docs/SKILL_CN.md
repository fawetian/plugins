---
name: thinking-selector
description: 思维工具选择器 — 帮你为特定问题选择合适的心智模型。当不确定该用哪个思维框架、面对需要结构化思考的复杂问题、或想了解可用的思维工具时使用。触发词："thinking tool"、"思维工具"、"which framework"、"how should I think about"、"用什么方法思考"、"怎样思考"、"structured thinking"、"选择思维框架"。
userInvocable: true
---

# 思维工具选择器

## 核心理念
**对的工具解决对的问题。** 不要硬套框架——将问题的本质匹配到为它设计的框架。

## 约束
- 所有输出使用中文
- 必须解释为什么推荐某个框架，而不只是推荐哪个
- 最多推荐 1 个主工具 + 1-2 个辅助工具

## 决策树

### 第一步：分类问题

问自己：**这个问题的本质是什么？**

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

### 第二步：验证匹配

推荐前检查：
1. **时间约束**：< 30 分钟决策推荐快框架（OODA、Pareto），否则可用深框架
2. **信息完备度**：信息不足时，先用 Five Whys / Feynman 收集，再用决策框架
3. **利益相关方**：多方参与时优先 MECE + Steelmanning

### 第三步：输出推荐

使用 `templates/selector-tree.md` 模板输出结果。

## 参见
所有可用的思维 skill 都在上面的决策树中列出。从主推荐开始，按需串联辅助工具。
