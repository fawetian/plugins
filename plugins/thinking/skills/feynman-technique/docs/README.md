# Feynman Technique (费曼学习法)

## Overview

Explain concepts in simple language to expose gaps in understanding. The ultimate test: if you can't explain it to a 12-year-old, you don't really understand it.

用最简单的语言解释概念以发现知识空洞。终极测试：如果解释不给 12 岁小孩听，说明你并没有真正理解。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:feynman-technique

# Auto-trigger examples
"用大白话给我解释 Raft 共识算法"
"explain Kubernetes networking like I'm five"
"我理解对了吗？帮我验证一下"
```

## Workflow

1. **选择概念** — 明确要理解的一个概念
2. **大白话解释** — 禁用术语，20 字以内每句
3. **找到卡壳点** — 标记说不清楚的地方
4. **回去学习** — 针对空洞补充理解
5. **简化和类比** — 用一个完整类比重述

## Output

Generates a learning note with plain-language explanation, knowledge gap analysis, and refined analogy.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 进入新领域 | 有明确问题要诊断 (→ `five-whys`) |
| 怀疑"伪懂" | 需要结构化拆分 (→ `mece`) |
| 给非专业人士解释 | 需要做决策 (→ `ooda-loop`) |
