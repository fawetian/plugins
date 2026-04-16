# MECE (互斥完全)

## Overview

Structure problems into mutually exclusive, collectively exhaustive categories. Ensure nothing is missed and nothing is double-counted.

把问题/选项划分为互斥且穷尽的类别。确保不遗漏、不重复。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:mece

# Auto-trigger examples
"帮我用 MECE 把这个问题拆解一下"
"不重不漏地分析一下用户流失的原因"
"categorize these options into clean groups"
```

## Workflow

1. **定义分解对象** — 明确要拆分的"整体"
2. **选择维度** — 按流程/主体/时间/Yes-No/量级
3. **列出子类** — 每个子类含清晰边界
4. **验证互斥 (ME)** — 边界案例测试
5. **验证完全 (CE)** — 极端案例测试
6. **输出结构** — 树形图 + 验证状态

## Output

Generates a structured decomposition document with ME/CE validation.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 拆解复杂分析 | 需要创造性跳跃 (→ `first-principles`) |
| 组织方案选项 | 需要追溯因果链 (→ `five-whys`) |
| 团队分工/职责划分 | 定义不清 (→ `feynman-technique` 先厘清) |
