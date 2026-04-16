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

- **所有输出必须使用中文**：所有文档、研究报告、图表和注释都必须用中文撰写。输出中不允许出现英文。
- **使用 Mermaid 画图**：所有架构图、流程图、关系图必须使用 Mermaid 语法绘制。

## Phase 0：已有研究检测

开始研究之前，检查 `docs/code-research/` 是否已存在且包含文件。

1. 检查 `docs/code-research/RESEARCH_PLAN.md` 及该目录下的 `*.md` 文件是否存在。

2. **目录不存在或为空**：直接进入 Phase 1，无需额外操作。

3. **目录已存在文件**：
   - 读取 `RESEARCH_PLAN.md`（如有），了解之前的研究范围。
   - 检查哪些专题文件已存在、哪些缺失。
   - 向用户展示以下选项（不适用的选项省略）：

   **A. 完整重新研究（覆盖全部）** — 删除已有文件，从 Phase 1 重新开始。适合代码已发生较大变化的情况。

   **B. 继续未完成的研究** — 仅在部分专题文件缺失时可用。读取已有的 RESEARCH_PLAN.md，识别没有输出文件的专题，仅启动这些专题的 Agent。已有文件保持不变。

   **C. 归档后重新开始** — 将 `docs/code-research/` 重命名为 `docs/code-research/_archived_{YYYY-MM-DD}/`（使用当前日期），然后正常进入 Phase 1。旧研究被保留。

   **D. 研究新专题** — 仅在用户的指令中提到特定主题或关注点时可用。创建子目录 `docs/code-research/{topic-slug}/`，在此目录下进行专项研究。已有的完整研究保持不变。详见下方"选项 D 范围"。

   展示选项后，附上推荐：
   - 如果部分专题文件缺失：推荐 **B**
   - 如果所有文件都已存在且完整：推荐 **A**（或 **C**，如果用户可能需要参考旧研究）
   - 如果用户请求针对特定领域：突出 **D**

4. 用户选择后，进入相应阶段：
   - **A**：删除已有文件，进入 Phase 1。
   - **B**：跳过 Phase 1，仅针对缺失专题进入 Phase 2。
   - **C**：重命名目录，进入 Phase 1。
   - **D**：聚焦 Phase 1，使用指定输出路径和精选模板（见下方）。

### 选项 D：子目录专题研究范围

主目录已提供全局视角。子目录应只聚焦该专题独有的内容——不重复。

**范围确定**：根据用户的专题描述，选择 1-3 个相关模板：

| 用户关注点 | 相关模板 | 跳过 |
|-----------|---------|------|
| 特定模块/机制 | mechanism + data_flow | architecture, dependencies, learning_path |
| 某功能的端到端流程 | workflow + architecture(局部) | dependencies, learning_path |
| 某模块的数据建模 | data_flow + dependencies | workflow, learning_path |
| 对比两种实现方案 | mechanism × 2 | 其余全部 |

**子目录工作流**：
1. **聚焦 Phase 1**：在 `docs/code-research/{topic-slug}/` 中创建精简的 RESEARCH_PLAN.md，只包含选中的专题。
2. **引用主目录研究**：Agent prompt 中必须注明"引用 `docs/code-research/` 的已有研究作为全局上下文；本子目录仅覆盖 [专题特定细节]。"
3. **聚焦 Phase 2**：只启动选中模板对应的 Agent，输出到子目录。
4. **聚焦 Phase 3**：在子目录的 RESEARCH_PLAN.md 中写汇总，并在主目录的 RESEARCH_PLAN.md 中添加指向该子目录的交叉引用。

## 执行流程

### Phase 1：快速扫描，制定研究计划

读 README、目录结构、入口文件、依赖文件，对项目建立初步认知。

然后创建 `docs/code-research/RESEARCH_PLAN.md`，把研究任务拆成若干**独立专题**。参考模板：[templates/research_plan.md](templates/research_plan.md)

计划写好后向用户确认，或直接执行（视情况而定）。

### Phase 2：并行研究

为每个专题启动独立的 Explore Agent 并行执行。

每个 Agent 的 prompt 应包含：
- 明确的研究目标
- 需要关注的文件/模块范围
- 产出文件路径
- **重要：所有内容必须用中文撰写**
- **每个模块必须先回答 What/Why，再讲实现**

各专题的产出模板见 `templates/` 目录：
- [templates/architecture.md](templates/architecture.md) — 架构全景
- [templates/mechanism.md](templates/mechanism.md) — 核心机制
- [templates/data_flow.md](templates/data_flow.md) — 数据流与状态
- [templates/dependencies.md](templates/dependencies.md) — 依赖与生态
- [templates/workflow.md](templates/workflow.md) — 核心工作流
- [templates/learning_path.md](templates/learning_path.md) — 学习路径

### Phase 3：汇总整合

所有专题完成后，在 `docs/code-research/RESEARCH_PLAN.md` 顶部补充研究摘要：项目核心价值、各专题文档索引、最值得关注的设计亮点。

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
- **"我想理解系统怎么运转的"** → 架构专题 + 工作流专题
- **"对比两个项目"** → 对两个项目各做架构专题，再写对比分析
