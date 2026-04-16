---
name: mece
description: MECE (Mutually Exclusive, Collectively Exhaustive) framework — structure problems into non-overlapping, complete categories. Use when decomposing complex analyses, organizing options, or ensuring nothing is missed. Triggers: "MECE", "互斥完全", "mutually exclusive", "不重不漏", "结构化分析", "categorize", "分类分析", "break down into categories".
userInvocable: true
---

# MECE (互斥完全)

## Core Philosophy
**No overlaps, no gaps.** Every element belongs to exactly one category, and all elements are accounted for.

## Constraints
- ALL output must be in Chinese (中文)
- Always validate both ME (互斥) and CE (完全) before finalizing
- Use `templates/mece-decomposition.md` as output structure

## When to Use
- 拆解复杂分析，确保不遗漏不重复
- 组织方案选项，让比较公平
- 做团队分工，确保职责清晰
- 根因分析前的问题空间划分

## When NOT to Use
- 问题需要创造性跳跃（→ `first-principles`）
- 需要追溯因果链（→ `five-whys`）
- 问题本质模糊、定义不清（先用 `feynman-technique` 厘清）

## Workflow

### Step 1: 定义分解对象
明确要拆分的"整体"是什么。写成一句话：
> "我要将 _______ 拆分为互斥完全的子类。"

### Step 2: 选择分解维度
常用维度（选一个最贴切的）：
- **按流程**：输入 → 处理 → 输出
- **按主体**：用户 / 系统 / 第三方
- **按时间**：过去 / 现在 / 未来
- **按 Yes/No**：是 X / 不是 X
- **按量级**：大 / 中 / 小
- **自定义**：根据领域定义

### Step 3: 列出子类

| 子类 | 定义（边界条件） | 示例 |
|------|------------------|------|
| A | ... | ... |
| B | ... | ... |
| C | ... | ... |

### Step 4: 验证互斥性 (ME)
逐对检查：任意两个子类之间是否有元素同时属于两者？
- 如果有 → 调整边界或合并
- **检查方法**：找一个边界案例，问"它属于 A 还是 B？"

### Step 5: 验证完全性 (CE)
问："有没有元素不属于任何子类？"
- **检查方法**：列举 3 个极端案例，确认都能归入某一类
- 如果有遗漏 → 增加"其他"类（但尽量细化，避免"其他"成为垃圾桶）

### Step 6: 输出结构化结果

```
整体：{分解对象}
维度：{选用的维度}
├── 子类 A：{定义}
├── 子类 B：{定义}
├── 子类 C：{定义}
└── (验证：ME ✓ / CE ✓)
```

## Output
生成分析文档，包含上述 6 步的完整产物。使用 `templates/mece-decomposition.md` 模板。

## See Also
- `first-principles` — 第一性原理：挑战假设后再分类
- `pareto-principle` — 帕累托：分类后聚焦 20% 关键项
- `eisenhower-matrix` — 艾森豪威尔：2×2 分类的经典应用
- `thinking-selector` — 不确定用哪个？
