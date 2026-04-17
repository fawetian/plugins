# Thinking Tools Plugin (思维工具插件)

A curated collection of mental model skills for Claude Code — structured thinking frameworks for technical decisions, product strategy, and general problem solving.

## Install

```bash
/plugin install thinking@fawetian-plugins
```

## Skills

### Category A: Decomposition & Clarity (分解与澄清)

| Skill | Purpose |
|-------|---------|
| `first-principles` | 第一性原理 — 回到不可再分的事实重新构建方案 |
| `mece` | MECE 互斥完全 — 结构化拆分，避免遗漏与重复 |
| `five-whys` | 五个为什么 — 连续追问根因 |
| `feynman-technique` | 费曼学习法 — 用简单语言发现知识空洞 |

### Category B: Decision & Speed (决策与速度)

| Skill | Purpose |
|-------|---------|
| `ooda-loop` | OODA 循环 — 快速迭代决策 |
| `occam-hanlon-razor` | 奥卡姆 / 汉隆剃刀 — 优先选择简单且非恶意的解释 |
| `pareto-principle` | 帕累托 80/20 — 聚焦高价值输入 |
| `eisenhower-matrix` | 艾森豪威尔矩阵 — 紧急/重要排序 |

### Category C: Risk & Systems (风险与系统)

| Skill | Purpose |
|-------|---------|
| `inversion` | 反向思维 — 从"如何失败"反推成功路径 |
| `second-order-thinking` | 二阶思维 — 下游连锁反应 |
| `systems-thinking` | 系统思考 — 反馈回路与杠杆点 |
| `margin-of-safety` | 安全边际 — 估算留缓冲 |
| `pre-mortem` | 事前验尸 — 假设失败，倒推原因 |

### Category D: Cognition & Argumentation (认知与论证)

| Skill | Purpose |
|-------|---------|
| `scout-mindset` | 侦察兵心态 — 追求真相而非胜利 |
| `steelmanning` | 稻草人加强 — 加强对手观点再回应 |
| `circle-of-competence` | 能力圈 — 划清能力边界 |
| `critical-thinking` | 批判性思维 — 审计论点、证据与推理链条 |

### Meta

| Skill | Purpose |
|-------|---------|
| `thinking-selector` | 思维工具选择器 — 不确定用哪个？从这里开始 |

## Usage

```bash
# Explicit invocation
/skill thinking:first-principles

# Auto-trigger via natural language
"用第一性原理分析这个缓存策略"
"帮我系统性思考这个组织瓶颈"

# Don't know which to use? Start here
/skill thinking:thinking-selector
```

## License

MIT
