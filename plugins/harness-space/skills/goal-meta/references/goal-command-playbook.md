# Goal 指令手册

## 这个 Skill 产出什么

这个 skill 产出 Codex `/goal` 指令。

对于中文用户，goal 正文可以完全使用中文，但斜杠命令仍然应该以 `/goal` 开头。除非当前 Codex 客户端明确支持 `/目标` 别名，否则不要把 `/目标` 当成可执行命令。

普通 prompt 告诉 agent 现在要做什么。goal 定义的是一个持久执行契约：最终结果是什么、如何证明完成、什么不能改、可以在哪里工作、如何迭代、什么时候停止、什么时候暂停。

默认立场：先给最佳可复制 goal。如果用户需求模糊但缺失信息是低风险的，选择保守默认值并给一句短理由，而不是让用户填表。

适合使用 `/goal` 的任务：

- 编码、调试、重构、发布或部署工作
- 需要验证的 UI 或产品改动
- 多步骤研究或文档产出
- 仓库清理、迁移或打包
- 任何必须用命令、产物、截图、日志或外部状态证明 “done” 的任务

不应强行使用 `/goal` 的任务：

- 一句话回答
- 简单改写或翻译
- 快速 shell 输出
- 不需要 agent 持续执行也能明显判断成功的小任务

## Plan-To-Goal 访谈模板

当用户任务模糊，并希望 agent 帮忙写 goal 时，可以使用：

```text
/plan 帮我把这个模糊任务转成一个强 Codex goal。
请围绕成功标准、验证命令、约束、边界、迭代策略和阻塞停止条件采访我。
然后起草最终的 `/goal ...` 指令。
```

## 标准 Goal 模板

```text
/goal [目标结果]。
Verification: [命令 / 产物 / 证据]。
Constraints: [什么不能改变]。
Boundaries: [允许写入位置 / 禁止路径]。
Iteration policy: [一次一个聚焦改动，重跑检查，记录进度]。
Stop when: [哪些证据证明完成]。
Pause if: [阻塞条件 / 人工决定 / 预算上限]。
```

## 中文友好模板

给中文用户时，推荐默认输出这一版。注意：开头仍然是 `/goal`，不是 `/目标`。

```text
/goal [目标结果]。
验证：[命令 / 产物 / 截图 / 日志 / 外部证据]。
约束：[不能改变的行为、接口、数据、风格或分支规则]。
边界：[允许写入的位置 / 禁止触碰的路径或系统]。
迭代策略：[一次只做一个聚焦改动，重跑检查，基于日志调整]。
完成条件：[哪些证据证明可以停止]。
暂停条件：[需要人工决定、凭证、外部权限、预算或破坏性操作的情况]。
```

也可以使用双语字段，适合要兼顾中文可读性和英文模板兼容性的场景：

```text
/goal [目标结果]。
Verification（验证）：[命令 / 产物 / 截图 / 日志 / 外部证据]。
Constraints（约束）：[不能改变的行为、接口、数据、风格或分支规则]。
Boundaries（边界）：[允许写入的位置 / 禁止触碰的路径或系统]。
Iteration policy（迭代策略）：[一次只做一个聚焦改动，重跑检查，基于日志调整]。
Stop when（完成条件）：[哪些证据证明可以停止]。
Pause if（暂停条件）：[需要人工决定、凭证、外部权限、预算或破坏性操作的情况]。
```

## 双语草案策略

当用户使用中文、任务还在收敛中，默认先给可直接复制的推荐版，再给英文兼容镜像：

1. `推荐执行版（中文，可直接复制）`：给用户直接复制，字段名用中文。
2. `Goal Draft (English-compatible)`：给 Codex、团队文档或偏英文工具链复制使用，字段名用英文。

两份草案必须语义一致，不能一份扩大范围、一份缩小范围。英文版是兼容镜像，不是重新发挥。

如果用户明确说“只要中文版”或“只要英文版”，遵从用户要求。

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

六个实用要素：

| 要素 | 回答的问题 | 好内容 |
|---|---|---|
| 目标结果 | 最后要变成什么状态？ | 用户可见或仓库可见的结果 |
| 验证 | 怎么证明完成？ | 命令、测试、构建、截图、日志、API 检查、文件 |
| 约束 | 什么不能变？ | 行为、公开 API、数据结构、风格、密钥、分支规则 |
| 边界 | 可以写哪里？ | 允许目录、禁止路径、不做无关重构 |
| 迭代策略 | 失败后怎么继续？ | 小步改动、重跑检查、先读日志再换策略 |
| 完成/暂停 | 什么时候停止或等人？ | 完成证据、登录/权限阻塞、破坏性选择、预算上限 |

## 起草规则

- 把 outcome 写成结果，而不是 “work on X”。
- 如果仓库暴露了明确命令，把精确命令写入 `验证` 或 `Verification`。
- 如果不知道精确命令，把发现过程写入 goal：先读取 package scripts、Makefile、CI 配置、Xcode schemes、项目文档或本地 runbook。
- 命令不够时，把产物写入 `验证`：变更文件、截图、导出 PDF、发布 URL、GitHub PR、日志或 API 响应。
- 把“什么不能改变”写入 `约束`，不要写到 `边界`。
- 把文件系统和仓库权限写入 `边界`。
- 在 `迭代策略` 中要求重复失败后更换证据来源。
- 在 `完成条件` 中定义证据，不要定义感觉。
- 在 `暂停条件` 中包含任何需要人工判断或外部权限的情况。
- 如果领域陌生或专业，不要编造领域规则。要求先发现权威项目文档、样例数据、官方参考或用户提供材料。
- 可以允许模型在边界内发挥品味和实现判断，但不能允许扩大范围或弱化验证。

## 强示例

### Bug 修复

```text
/goal 修复结账折扣 bug，使百分比优惠券每个订单只应用一次，同时固定金额优惠券仍可与礼品卡余额叠加。
验证：运行仓库的 checkout 单元测试；为百分比优惠券新增或更新回归测试；运行 package scripts 中最小相关 lint/typecheck 命令。
约束：不改变公开 coupon API 名称、数据库 schema、礼品卡行为或无关结账 UI 文案。
边界：只修改结账计价逻辑、coupon 测试和直接需要的 fixtures；不触碰支付服务配置或 migration 文件。
迭代策略：一次做一个聚焦改动，每次改动后重跑失败检查，并先阅读测试输出再换策略。
完成条件：回归测试在修复前失败、修复后通过，且相关 lint/typecheck 命令通过。
暂停条件：需要支付凭证、生产数据、schema migration，或需要产品决定叠加规则时暂停。
```

### UI 打磨

```text
/goal 让编辑器工具栏在移动端可用，不出现水平溢出或控件重叠。
验证：运行已配置的前端检查，打开本地应用，截取桌面和移动端截图，并确认工具栏没有文字或控件重叠。
约束：保留现有编辑器命令、快捷键、保存文档格式和视觉识别。
边界：只修改工具栏布局、组件、样式和直接相关测试；不重新设计编辑器外壳，不改变文档序列化。
迭代策略：一次调整一个布局问题，重跑检查，并用截图对比修改前后。
完成条件：检查通过，且截图显示工具栏在桌面和移动端宽度下都能容纳，所有主控件可访问。
暂停条件：设计需要移除主命令、添加新的设计系统依赖，或改变产品导航时暂停。
```

### Skill 创建

```text
/goal 创建一个名为 qiaomu-example-skill 的本地 agent skill，把提供的工作流打包成可复用的 SKILL.md、README.md、agents/interface.yaml、references 和轻量验证脚本。
验证：检查生成文件；如有 YAML/JSON 则运行语法检查；用样例输出运行验证脚本；确认 skill 目录存在于 ~/.agents/skills/qiaomu-example-skill。
约束：保持 skill 简洁，适当中文优先，并包含向阳乔木 copyright/contact 元数据；除非明确要求，不发布到 GitHub。
边界：只写入 ~/.agents/skills/qiaomu-example-skill 和明确要求的临时验证文件；不修改无关已有 skills。
迭代策略：先创建最小包并验证结构，再只添加能提升可靠性的 references 或 scripts。
完成条件：所有必要文件存在，验证通过，README 说明用法、边界和本地检查。
暂停条件：工作流需要私有凭证、外部发布、所有权不清，或用户要求改名时暂停。
```

## 反模式

弱：

```text
/goal Improve the app.
```

更好：

```text
/goal 减少 dashboard 首屏杂乱感，让回访用户无需滚动即可看到今日关键指标并完成主操作。
验证：运行前端检查，打开本地应用，截取桌面和移动端截图，并确认没有文字重叠或主操作隐藏。
约束：保持现有数据源、路由、鉴权流程和 analytics events 不变。
边界：只修改 dashboard 视图组件、布局样式和直接相关测试。
迭代策略：一次修改一个视觉或流程问题，重跑检查，并在每次有意义布局改动后对比截图。
完成条件：检查通过，且截图显示桌面和移动端首屏都包含关键指标和主操作。
暂停条件：需要新的产品优先级、新 analytics events 或后端 API 变更时暂停。
```

避免：

- `make sure it works` 这种验证
- `edit whatever is needed` 这种边界
- `keep trying` 这种迭代策略
- `when it seems good` 这种完成条件
- 对鉴权、支付、破坏性操作或私有数据缺少暂停条件
