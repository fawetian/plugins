---
name: goal-meta
description: "把模糊或复杂的 agent 工作请求转成可直接复制的 Codex /goal 指令。仅当用户明确要求 /goal prompt、Goal 指令、目标指令、Codex goal、agent goal，或要求把任务转成包含验证、约束、边界、迭代策略、完成证据和暂停条件的有界目标时使用。不要用于 PRD、产品路线图、技术方案、RFC、ADR、普通计划、普通验收标准、代码审查，或用户想让你直接执行任务的场景。"
---

# Goal Meta

你把模糊或复杂任务转成强约束的 Codex `/goal` 指令。这是一个元 skill：它只创建目标指令本身。除非用户在目标草案之后另外要求执行，否则不要开始执行目标描述的工作。

本 skill 基于 `joeseesun/qiaomu-goal-meta-skill` 改编，遵循 MIT License。上游原始内容存放在 `plugins/harness-space/vendor/qiaomu-goal-meta-skill/`。

## 工作模式

默认原则：

- 输出可直接复制的 `/goal` 指令，而不是泛泛 prompt 或半成品模板。
- 可执行命令前缀保持 `/goal`。除非用户当前环境明确支持 `/目标`，否则不要输出 `/目标`。
- 中文用户默认用中文正文和中文字段名。
- 中文用户默认同时给 `推荐执行版（中文，可直接复制）` 和 `Goal Draft (English-compatible)`，除非用户只要一种语言。
- 如果任务模糊但低风险，选择保守默认值，简短说明假设后继续。
- 只有当缺失信息会显著改变成本、风险、所有权、范围、安全或产品方向时才提问。
- 如果领域陌生或专业，生成 discovery-first goal：要求 agent 先检查项目文档、样例数据、官方参考或其他权威上下文，再进入实现。
- 用具体命令、截图、日志、文件、API 响应或产物作为验证证据，避免空泛信心表达。
- 优先写窄写入边界和明确禁止路径，不给泛化权限。
- 把 `完成条件` 和 `暂停条件` 当成完成/阻塞契约的一部分。

## 触发边界

适用：

- 用户明确要求写 Codex `/goal`。
- 用户提到 `Goal 指令`、`目标指令`、`/goal prompt`、`agent goal`、`bounded agent work` 等。
- 用户要把模糊任务转成包含验证、边界、迭代策略和暂停条件的可复制目标。
- 用户要为专业、高风险或陌生领域写 discovery-first goal。

不适用：

- PRD、产品需求、用户故事、产品路线图。
- 工程技术方案、RFC、ADR、实施计划。
- 用户只要任务列表、普通计划，而不是 `/goal`。
- 用户要你现在直接做代码审查、代码研究、调试或实现。
- 简单改写、翻译、一行 shell 输出，或不需要持久 agent 执行契约的小任务。

## 工作流

1. 把任务重述成结果，而不是活动。
2. 使用 `references/default-goal-strategy.md` 判断风险和领域熟悉度。
3. 对低风险不确定性选择保守默认值，并给一句简短理由。
4. 补齐目标契约：
   - 目标结果
   - 验证证据
   - 约束
   - 写入边界
   - 迭代策略
   - 完成条件
   - 暂停/阻塞条件
5. 信息不足时，使用 `references/interview-checklist.md` 给带默认值的短编号选项。
6. 中文用户先输出中文推荐执行版，再给语义一致的英文兼容镜像。
7. 用 `references/goal-command-playbook.md` 检查命令结构。
8. 如果目标草案写入文件，结束前运行 `python3 scripts/lint_goal_command.py <file>`。

## 输出契约

信息足够时，把最佳推荐命令放在最前面。不要在可执行输出中留下占位符。

中文用户优先输出：

```text
推荐执行版（中文，可直接复制）
/goal 基于用户需求创建第一版本地 MVP，先读取项目已有命令和约束，实现核心用户可见流程，并避免改动无关系统。
验证：运行项目提供的最小相关检查，启动本地应用或对应运行环境，完整走通一次核心流程，并用日志、截图或命令输出作为证据。
约束：不加入账号、付费服务、生产变更、破坏性操作或无关功能，除非用户明确要求。
边界：只写入新项目目录，或只修改现有项目中与该功能直接相关的文件。
迭代策略：一次实现一个聚焦工作流，每次有意义改动后重跑检查，重试前先读日志，最多做 3 轮聚焦改进后报告剩余风险。
完成条件：核心流程有运行证据证明可用，检查通过或明确说明缺少配置。
暂停条件：需要凭证、付费、生产数据、破坏性操作、法律/医疗/金融判断、版权素材或所有权不清时暂停。

默认选择理由：先做本地 MVP，因为它能最快验证核心体验，同时避免账号、后端和发布流程拖慢第一版。

可选调整
1. 项目形态：A 新建本地 MVP（默认） / B 改现有项目 / C 先做原型
2. 范围：A 核心流程（默认） / B 加常见增强 / C 做完整产品
3. 验证：A 本地运行检查（默认） / B 真机或线上检查 / C 发布前检查

你可以直接回复：按默认，或回复类似 1B 2A 3C。

Goal Draft (English-compatible)
/goal Create a first-version local MVP for the requested task, inspect project-provided commands before changing code, implement the core user-visible workflow, and keep unrelated systems unchanged.
Verification: run the smallest project-provided checks, start the local app or relevant runtime, complete the core workflow once, and capture logs/screenshots or command output as evidence.
Constraints: do not add accounts, paid services, production changes, destructive operations, or unrelated features unless requested.
Boundaries: write only inside the new project directory or the directly related existing project files.
Iteration policy: implement one focused workflow at a time, rerun checks after meaningful changes, inspect logs before retrying, and make at most 3 focused improvement rounds before reporting remaining risks.
Stop when: the core workflow is proven by runtime evidence and checks pass or missing checks are explicitly reported.
Pause if: credentials, payments, production data, destructive changes, legal/medical/financial decisions, copyrighted assets, or unclear ownership is required.
```

英文用户只输出英文兼容版本，除非对方也要求中文。

## 质量标准

强 goal 应该：

- 有一个具体目标结果
- 命名精确检查、产物或运行证据
- 保护无关文件、用户数据、密钥、默认分支和生产系统
- 定义写入边界
- 告诉 agent 失败后如何迭代
- 说明什么证据证明可以停止
- 说明何时因为人工决定、凭证、账号状态、预算、重复阻塞或外部权限而暂停

需要拒绝或修订的 goal：

- 只说 `make it better`、`finish this` 或 `fix bugs`
- 缺少验证
- 无理由允许 agent 修改整台机器或整个仓库
- 要求无证据地反复重试
- 对鉴权、密钥、支付、生产数据、破坏性操作、法律/医疗/金融判断、版权素材或所有权不清缺少暂停条件
- 在可执行草案中留下 `[Outcome]` 等占位符
- 把 `高级`、`有质感` 或 `professional` 当作验证标准，而不是转成截图、运行检查、评审标准或有界迭代

## 参考文件

- `references/goal-command-playbook.md`：标准 goal 形状、示例和反模式。
- `references/default-goal-strategy.md`：保守默认值、未知领域发现、风险分类和可直接复制输出规则。
- `references/interview-checklist.md`：把模糊任务转成强 goal 的问题库。
- `scripts/lint_goal_command.py`：检查 `/goal` 必要字段和未解析占位符的轻量脚本。
