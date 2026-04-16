---
name: five-whys
description: 5 Whys root cause analysis — iteratively ask "why?" to move from symptoms to underlying causes. Use for post-mortems, debugging recurring failures, or understanding why something keeps going wrong. Triggers: "5 whys", "five whys", "五个为什么", "root cause", "根因分析", "why does this keep happening", "为什么总是", "post-mortem", "复盘".
userInvocable: true
---

# 5 Whys (五个为什么)

## Core Philosophy
**Symptoms lie, root causes don't.** Keep asking "why" until you reach a cause you can actually fix.

## Constraints
- ALL output must be in Chinese (中文)
- Must ask at least 5 levels of "why", but stop when reaching an actionable root cause
- Distinguish between single-cause and multi-cause chains
- Use `templates/five-whys-worksheet.md` as output structure

## When to Use
- 事故复盘 / post-mortem
- 反复出现的 bug 或运维问题
- 流程失败但表面原因不够深
- "修了又出现"的问题

## When NOT to Use
- 问题有多个独立根因交织（→ `systems-thinking` 更合适）
- 需要创造新方案而非诊断旧问题（→ `first-principles`）
- 问题定义模糊，不知道从哪问起（→ `feynman-technique` 先厘清）

## Workflow

### Step 1: 定义现象
用一句话描述可观测的问题现象（不带假设）：
> "现象：_______ 发生了。"

### Step 2: 连续追问 Why

| 层级 | 问题 | 回答 | 证据 |
|------|------|------|------|
| Why 1 | 为什么 {现象}？ | 因为 ... | {日志/数据/证人} |
| Why 2 | 为什么 {Why1 的回答}？ | 因为 ... | ... |
| Why 3 | 为什么 {Why2 的回答}？ | 因为 ... | ... |
| Why 4 | 为什么 {Why3 的回答}？ | 因为 ... | ... |
| Why 5 | 为什么 {Why4 的回答}？ | 因为 ... | ... |

**关键规则**：
- 每层回答必须有**证据支撑**，不能凭直觉
- 如果某层有多个原因 → 分叉为多条链，各自继续追问
- 到达"这个我能改"的层级时停止

### Step 3: 识别根因类型

根因通常落在以下类别：
- **流程缺失**：没有制度/检查点防止此类问题
- **知识缺失**：相关人不知道正确做法
- **系统缺陷**：技术架构/工具本身的限制
- **资源不足**：人力/时间/预算不够
- **激励错位**：制度鼓励了错误行为

### Step 4: 制定对策

| 根因 | 对策 | 负责人 | 验证方式 | 截止日期 |
|------|------|--------|----------|----------|
| ... | ... | ... | ... | ... |

**对策层级**（优先选高层级）：
1. **消除**：让根因不可能发生
2. **预防**：加检查点在根因触发前拦截
3. **检测**：根因发生后尽快发现
4. **缓解**：减小影响范围

### Step 5: 验证
- 追问"如果这个对策到位，原始问题还会发生吗？"
- 如果答案是"可能" → 根因没挖到位，回到 Step 2

## Output
生成根因分析报告，包含上述 5 步的完整产物。使用 `templates/five-whys-worksheet.md` 模板。

## See Also
- `systems-thinking` — 系统思考：多因多果的复杂系统
- `pre-mortem` — 事前验尸：在问题发生前做根因分析
- `inversion` — 反向思维：从"如何失败"反推
- `thinking-selector` — 不确定用哪个？
