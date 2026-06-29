---
name: code-research
description: 深度研究和理解当前项目。当用户想要深入理解某个开源项目的设计思路、架构决策、Day 0 产品和技术方案意图、演进历史、实现地图、源码阅读路径、基于源码证据的代码质量地图、核心机制、数据流或关键算法时，必须使用此 skill。触发词：code-research。
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
| 如何阅读项目源码 | learning_path + architecture | 除非需要否则跳过 dependencies |
| 系统如何演进而来 | evolution_history + implementation_map | learning_path，除非需要否则跳过 dependencies |
| 如何从 0 设计某系统/机制 | design_evolution + mechanism | dependencies, learning_path |
| 想站在作者 Day 0 视角理解需求和技术方案 | day0_product_technical_design + design_evolution | 除非需要否则跳过 dependencies |
| 代码质量和可维护性风险 | quality_map + implementation_map | 除非需要否则跳过 dependencies |
| 对比两种实现方案 | mechanism × 2 | 其余全部 |

**子目录工作流**：
1. **聚焦 Phase 1**：在 `docs/code-research/{topic-slug}/` 中创建精简的 RESEARCH_PLAN.md，只包含选中的专题。
2. **引用主目录研究**：Agent prompt 中必须注明"引用 `docs/code-research/` 的已有研究作为全局上下文；本子目录仅覆盖 [专题特定细节]。"
3. **聚焦 Phase 2**：只启动选中模板对应的 Agent，输出到子目录。
4. **聚焦 Phase 3**：在子目录的 RESEARCH_PLAN.md 中写汇总，并在主目录的 RESEARCH_PLAN.md 中添加指向该子目录的交叉引用。

## 执行流程

### Phase 1：快速扫描，制定研究计划

读 README、目录结构、入口文件、依赖文件和 Git 历史，对项目建立初步认知。

Git 历史分析必须针对被研究的目标项目，而不是本 skill：
- 用 `git log --oneline --decorate --max-count=80` 了解整体时间线。
- 快速扫描识别关键目录后，对这些目录使用 `git log --name-status --format=...`。
- 按能力变化、模块边界变化、数据模型变化和大型重构识别里程碑 commit。
- 记录每个结论是 commit/diff 直接证明的事实，还是基于变更顺序和当前代码做出的推断。

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
- [templates/learning_path.md](templates/learning_path.md) — 基于目录结构和代码结构的源码阅读路径
- [templates/evolution_history.md](templates/evolution_history.md) — 基于 Git commit 的系统演进历史
- [templates/implementation_map.md](templates/implementation_map.md) — 连接历史演进与当前代码的实现地图
- [templates/design_evolution.md](templates/design_evolution.md) — 从第一性原理出发的设计演进推演
- [templates/day0_product_technical_design.md](templates/day0_product_technical_design.md) — 基于源码证据复原 Day 0 产品需求和技术方案
- [templates/quality_map.md](templates/quality_map.md) — 基于源码证据的代码质量和可维护性风险地图

完整研究默认输出：
1. `01_architecture.md`
2. `02_mechanism_[名称].md`
3. `03_data_flow.md`
4. `04_dependencies.md`
5. `05_workflow.md`
6. `06_learning_path.md` — 分析项目目录和代码结构，并规划源码阅读路线
7. `07_evolution_history.md`
8. `08_implementation_map.md`
9. `09_design_evolution.md`
10. `10_day0_product_technical_design.md`
11. `11_quality_map.md`

新增综合专题的依赖规则：
- `06_learning_path.md` 必须作为独立的源码阅读路径文件产出。它需要从阅读源码的角度解释目录结构、识别入口文件和核心模块、给出文件阅读顺序，并标出第一轮可以暂时跳过的目录。
- `07_evolution_history.md` 必须基于目标项目的 Git history 和 diff，不能只根据当前代码反推历史。
- `08_implementation_map.md` 要把 `07_evolution_history.md` 中的历史阶段映射到当前模块、接口、数据结构、运行时组件和存储/状态。
- `09_design_evolution.md` 不按 commit 时间线写，而是按第一性原理推演：最小设计 → 暴露问题 → 新增设计 → 复杂度代价 → 当前代码落点。
- `10_day0_product_technical_design.md` 要复原作者 Day 0 视角：需求起点、目标用户、MVP 边界、初始技术方案、后续产品压力如何逼出技术选择，以及每个判断的证据等级。它是对现有项目的反向研究，不是面向未来新功能的实施方案；如果用户要写 RFC、ADR 或 implementation plan，应改用 `technical-design`。
- `11_quality_map.md` 必须直接阅读目标项目源码。已有研究只能用于定位文件，不能作为证据。每个结论都必须落到具体文件路径，以及函数、类型、配置或调用链，并说明观察到的代码现象。高风险判断至少需要 2 个源码证据点；中/低风险判断至少需要 1 个源码证据点。没有源码证据的判断只能放入待解决疑问。
- 质量地图只识别基于源码证据的可维护性风险，不做逐行审查、漏洞扫描、性能 profiling 或代码修改。不要输出总分，只按模块给低/中/高风险等级。
- 如果 Explore Agent 之间不能保证依赖顺序，就在 Phase 3 等事实专题完成后，由主 Agent 汇总写 07/08/09/10/11。

### Phase 3：汇总整合

所有专题完成后，在 `docs/code-research/RESEARCH_PLAN.md` 顶部补充研究摘要：项目核心价值、各专题文档索引、最值得关注的设计亮点。

完整研究的汇总必须包含：
- 来自 `06_learning_path.md` 的源码阅读路线和目录结构重点
- 来自 `07_evolution_history.md` 的主要历史演进路线
- 来自 `08_implementation_map.md` 的当前实现地图亮点
- 来自 `09_design_evolution.md` 的第一性原理设计路线
- 来自 `10_day0_product_technical_design.md` 的作者 Day 0 产品和技术方案复原
- 来自 `11_quality_map.md` 的源码证据驱动的质量和可维护性风险重点

---

## 研究策略

**忽略的文件**：测试文件（`*_test.*`、`__tests__/`、`tests/`、`spec/`）、依赖目录（`node_modules/`、`vendor/`、`dist/`）、锁文件。例外：`11_quality_map.md` 可以读取测试文件和测试配置，但只用于判断测试覆盖缺口。

**读代码的顺序**：接口/协议定义 → 核心数据结构 → 主流程 → 边界处理

**遇到不理解的代码**：记录到 `RESEARCH_PLAN.md` 的"待解决疑问"，不要跳过。

**质量标准**：研究完成后，应能用一段话解释项目解决了什么问题，画出核心模块依赖图，追踪任意核心功能的调用链，解释 2-3 个关键设计决策及原因。

---

## 灵活调整

- **"给我一个大概了解"** → 只做架构专题
- **"我想理解 X 功能"** → 重点拆分 X 的机制专题
- **"我想贡献代码"** → 完整执行所有专题
- **"我想阅读源码"** → 学习路径专题 + 架构专题
- **"我想理解系统怎么运转的"** → 架构专题 + 工作流专题
- **"这个系统是怎么演进成这样的"** → 演进历史专题 + 实现地图专题
- **"如果从 0 设计这套系统"** → 第一性原理设计演进专题
- **"我想站在源码作者 Day 0 视角理解需求和技术方案"** → Day 0 产品与技术方案专题 + 设计演进专题
- **"这个项目代码质量怎么样"** → 质量地图专题 + 实现地图专题
- **"对比两个项目"** → 对两个项目各做架构专题，再写对比分析
