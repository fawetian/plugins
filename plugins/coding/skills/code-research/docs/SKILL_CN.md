---
name: code-research
description: 深度研究和理解当前项目。当用户想要深入理解某个开源项目的设计思路、架构决策、核心机制、数据流或关键算法时，必须使用此 skill。触发词：code-research。
---

# Code Research 代码研究

深度理解当前代码仓库的系统化研究流程。

## 核心理念

**自顶向下**：先从宏观入手，再深入细节。先理解整体，再理解局部。

研究代码的核心问题只有两个：**这个模块是什么（What）**、**为什么需要它（Why）**。"怎么实现"是最后才关心的。每个模块、每个设计决策，都必须先回答这两个问题，再谈实现细节。

## 约束

- **使用 Mermaid 画图**：所有架构图、流程图、关系图必须使用 Mermaid 语法绘制。

## 执行流程

### Phase 1：快速扫描，制定研究计划

读 README、目录结构、入口文件、依赖文件，对项目建立初步认知。

然后创建 `docs/research/RESEARCH_PLAN.md`，把研究任务拆成若干**独立专题**。参考模板：[templates/research_plan.md](templates/research_plan.md)

计划写好后向用户确认，或直接执行（视情况而定）。

### Phase 2：并行研究

为每个专题启动独立的 Explore Agent 并行执行。

每个 Agent 的 prompt 应包含：
- 明确的研究目标
- 需要关注的文件/模块范围
- 产出文件路径
- **每个模块必须先回答 What/Why，再讲实现**

各专题的产出模板见 `templates/` 目录：
- [templates/architecture.md](templates/architecture.md) — 架构全景
- [templates/mechanism.md](templates/mechanism.md) — 核心机制
- [templates/data_flow.md](templates/data_flow.md) — 数据流与状态
- [templates/dependencies.md](templates/dependencies.md) — 依赖与生态
- [templates/learning_path.md](templates/learning_path.md) — 学习路径

### Phase 3：汇总整合

所有专题完成后，在 `RESEARCH_PLAN.md` 顶部补充研究摘要：项目核心价值、各专题文档索引、最值得关注的设计亮点。

---

## 研究策略

**忽略的文件**：测试文件（`*_test.*`、`__tests__/`、`tests/`、`spec/`）、依赖目录（`node_modules/`、`vendor/`、`dist/`）、锁文件。

**读代码的顺序**：接口/协议定义 → 核心数据结构 → 主流程 → 边界处理

**遇到不理解的代码**：记录到 `RESEARCH_PLAN.md` 的"待解决疑问"，不要跳过。

**质量标准**：研究完成后，应能用一段话解释项目解决了什么问题，画出核心模块依赖图，追踪任意核心功能的调用链，解释 2-3 个关键设计决策及原因。

---

## 灵活调整

- **"给我一个大概了解"** → 只做架构专题
- **"我想理解 X 功能"** → 重点拆分 X 的机制专题
- **"我想贡献代码"** → 完整执行所有专题
- **"对比两个项目"** → 对两个项目各做架构专题，再写对比分析
