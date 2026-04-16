# Occam's Razor & Hanlon's Razor (奥卡姆剃刀 & 汉隆剃刀)

## SKILL_CN.md
完整的中文文档见 `SKILL_CN.md`

## Overview

Prefer simpler explanations and don't attribute to malice what stupidity explains. Cut through analysis paralysis.

同等条件下，最简单的解释最可能正确；能用无知解释的，不要归因于恶意。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:occam-hanlon-razor

# Auto-trigger examples
"用奥卡姆剃刀分析这个 bug 的可能原因"
"is this a conspiracy or the simplest explanation?"
"过度分析了，帮我用汉隆剃刀理清思路"
```

## Workflow

1. **列出竞争解释** — 把所有可能解释列出，标注复杂度和假设数
2. **应用奥卡姆剃刀** — 按假设数排序，去掉冗余假设
3. **应用汉隆剃刀** — 检查恶意假设能否替换为无知/失误
4. **得出最佳解释** — 选择假设最少且不依赖恶意的解释
5. **检查失效条件** — 主动检查剃刀可能误导的场景

## Output

Generates a razor analysis report with competing explanations ranked by simplicity.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 分析瘫痪，想得太多 | 确有恶意或对抗场景 (安全事件) |
| Debug 时复杂理论 vs 简单 bug | 问题确实复杂不能简化 (-> `systems-thinking`) |
| 阴谋论倾向 | 需要深入根因 (-> `five-whys`) |
