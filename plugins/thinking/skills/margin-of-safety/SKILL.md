---
name: margin-of-safety
description: Margin of Safety — build buffers into estimates and capacity for unknown unknowns. Use for capacity planning, time estimation, architecture robustness, or any decision under uncertainty. Triggers: "margin of safety", "安全边际", "buffer", "缓冲", "how much headroom", "留多少余量", "worst case", "最坏情况", "over-provision", "contingency".
userInvocable: true
---

# Margin of Safety (安全边际)

## Core Philosophy
**The bridge that can hold 10 tons should be built to hold 30.** Plan for what you don't know you don't know.

## Constraints
- ALL output must be in Chinese (中文)
- Always quantify the margin (percentage or absolute value)
- Distinguish known unknowns from unknown unknowns
- Use `templates/margin-analysis.md` as output structure

## When to Use
- 容量规划：服务器、带宽、存储
- 时间估算：工期、deadline、sprint 容量
- 架构鲁棒性：故障容忍、数据冗余
- 财务预算：成本预估、投资决策

## When NOT to Use
- 已有精确数据无需估算
- 过度缓冲会导致资源浪费 > 风险成本（需权衡）
- 需要快速决策不能等（→ `ooda-loop`）

## Workflow

### Step 1: 定义估算对象
> "我需要估算 _______ ，它的失败代价是 _______ 。"

### Step 2: 做出基础估算
用最佳可用信息做出"最可能"的估算：
- **乐观估计**：一切顺利时的值
- **最可能估计**：正常情况下的值
- **悲观估计**：出问题时的值

| 维度 | 乐观 | 最可能 | 悲观 |
|------|------|--------|------|
| ... | ... | ... | ... |

### Step 3: 识别不确定性来源

| 不确定性 | 类型 | 影响方向 | 能否降低 |
|---------|------|---------|---------|
| ... | 已知未知 / 未知未知 | 低估/高估 | 能（如何）/ 不能 |

### Step 4: 确定安全边际

根据失败代价和不确定性选择安全系数：

| 场景 | 安全系数 | 适用条件 |
|------|---------|---------|
| 可逆 + 低损失 | 1.2x (20%) | 内部工具、可回滚 |
| 可逆 + 高损失 | 1.5x (50%) | 面向客户但可回滚 |
| 不可逆 + 低损失 | 1.5x (50%) | 小规模、影响有限 |
| 不可逆 + 高损失 | 2.0x-3.0x | 基础设施、安全、合规 |

**最终值** = 最可能估计 × 安全系数

### Step 5: 设置触发线
不是一直保持最大缓冲，而是设置分级响应：
- **绿线** (70% 利用率)：正常运行
- **黄线** (85% 利用率)：开始预警，启动扩容计划
- **红线** (95% 利用率)：紧急响应

## Output
生成安全边际分析报告。使用 `templates/margin-analysis.md` 模板。

## See Also
- `inversion` — 反向思维：识别需要留安全边际的领域
- `second-order-thinking` — 二阶思维：缓冲不足的下游影响
- `systems-thinking` — 系统思考：系统性地理解瓶颈和缓冲
- `thinking-selector` — 不确定用哪个？
