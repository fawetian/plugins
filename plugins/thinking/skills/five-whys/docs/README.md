# 5 Whys (五个为什么)

## Overview

Iteratively ask "why?" to move from symptoms to root causes. The go-to tool for post-mortems and debugging recurring failures.

连续追问"为什么？"，从表象深入根因。事故复盘和反复问题的首选工具。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:five-whys

# Auto-trigger examples
"为什么这个 bug 又出现了？做个根因分析"
"post-mortem for yesterday's outage"
"帮我做个五个为什么分析"
```

## Workflow

1. **定义现象** — 用一句话描述可观测问题
2. **连续追问 Why** — 至少 5 层，每层要有证据
3. **识别根因类型** — 流程/知识/系统/资源/激励
4. **制定对策** — 消除 > 预防 > 检测 > 缓解
5. **验证** — 对策到位后原始问题还会发生吗？

## Output

Generates a root cause analysis report with Why-chain, root cause classification, and action items.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 事故复盘 / post-mortem | 多因多果的复杂系统 (→ `systems-thinking`) |
| 反复出现的故障 | 需要创造新方案 (→ `first-principles`) |
| "修了又出现"的问题 | 问题定义模糊 (→ `feynman-technique`) |
