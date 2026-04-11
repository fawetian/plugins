# Code Research

对当前项目进行深度研究，系统性地理解项目的设计哲学、架构决策、核心机制与数据流。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

在对话中输入 `code-research` 触发，例如：

- `code-research`
- `帮我深入理解这个项目的架构`（结合 `code-research` 触发词使用效果最佳）

## 使用示例

**场景一：快速了解项目整体架构**

```
code-research 给我一个大致的理解
```

仅执行架构主题分析，输出项目核心模块关系图和设计概览，适合快速上手新项目。

**场景二：深入理解某个特定功能**

```
code-research 我想理解认证模块的实现
```

聚焦于指定功能，拆解其核心机制，追踪调用链，解释关键设计决策。

**场景三：准备参与贡献代码**

```
code-research 我想为这个项目贡献代码
```

执行完整研究流程，并行启动多个专项研究 Agent，覆盖架构、核心机制、数据流、依赖关系和学习路径五个主题，最终汇总为完整研究报告。

## 输出

研究结果以中文输出，保存在项目的 `docs/code-research/` 目录下：

- `RESEARCH_PLAN.md` — 研究计划与汇总，包含各主题文档索引
- `architecture.md` — 架构概览（含 Mermaid 图表）
- `mechanism.md` — 核心机制说明
- `data_flow.md` — 数据流与状态管理
- `dependencies.md` — 依赖关系与生态
- `workflow.md` — 核心工作流（端到端业务流程 + 模块内部执行流程）
- `learning_path.md` — 学习路径建议
