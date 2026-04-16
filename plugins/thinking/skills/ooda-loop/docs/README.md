# OODA Loop (OODA 循环)

## Overview

Observe-Orient-Decide-Act rapid decision-making cycle. Speed of iteration beats quality of individual decisions.

观察-定向-决策-行动快速决策循环。迭代速度胜过单次决策质量。

## Installation

```bash
/plugin install thinking@fawetian-plugins
```

## Usage

```bash
# Explicit
/skill thinking:ooda-loop

# Auto-trigger examples
"用 OODA 循环处理这个线上事故"
"time pressure, need a rapid decision framework"
"快速决策：竞争对手刚发布了类似功能"
```

## Workflow

1. **Observe (观察)** — 5 分钟内收集当前可获取的事实
2. **Orient (定向)** — 把事实放入背景中理解，检查心智模型
3. **Decide (决策)** — 选择行动方案，预设退出条件
4. **Act (行动)** — 执行决策，同时开始下一轮观察
5. **循环复盘** — 3 个循环后检查速度和模型更新

## Output

Generates OODA cycle records with observation-orientation-decision-action for each round.

## When to Use vs Not

| Use | Don't Use |
|-----|-----------|
| 时间紧迫，不能等完美信息 | 决策不可逆且代价巨大 (-> `inversion` + `margin-of-safety`) |
| 对抗性/竞争性环境 | 有充足时间做深度分析 (-> `systems-thinking`) |
| 需要快速试错迭代 | 需要团队共识 (-> `mece`) |
