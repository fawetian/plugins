# 产品路线图规划助手

产品路线图规划与可视化工具，帮助你制定产品战略、规划版本发布计划并生成清晰的时间线视图。

## 安装

```bash
/plugin install product@fawetian-plugins
```

## 触发方式

在对话中使用以下任意触发词即可激活该 skill：

- `roadmap`
- `product roadmap`
- `release plan`
- `product strategy`
- `quarterly plan`

例如：输入 "帮我规划一份 2026 年的 product roadmap" 即可触发。

## 使用示例

**示例 1：年度路线图**

```
我们是一款 SaaS 协作工具，请帮我制定 2026 年的 product roadmap，重点方向是 AI 能力和企业级功能
```

**示例 2：季度发布计划**

```
请制定 Q2 的 quarterly plan，我们有 3 个研发团队，主要目标是提升用户留存率
```

**示例 3：干系人沟通视图**

```
请用 roadmap 的 Now/Next/Later 格式整理以下功能列表，帮我和 CEO 做汇报
```

## 输出

生成的路线图文档保存至 `docs/roadmap/{year}-roadmap.md`，包含以下内容：

- 产品愿景与战略方向（3-5 年）
- 季度主题与 OKR
- 时间线视图（Mermaid Gantt 图）
- 功能管道表格（含优先级、季度、状态、负责人）
- 依赖关系说明（技术、跨团队、外部依赖）

支持三种路线图视角：Now/Next/Later（高管沟通）、时间线路线图（详细排期）、看板路线图（敏捷团队）。所有内容均以中文输出。
