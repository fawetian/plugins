# Goal 访谈清单

只问写出安全、可测试 goal 所必需的问题。如果某个答案可以低风险推断，就说明假设并继续。

优先使用带默认值的编号选项，而不是开放式问题。用户应该可以回复 `按默认` 或 `1B 2A 3C`。

## 快速访谈

对于非常模糊但低风险的任务，使用这些选项：

1. 项目形态：A 新建本地 MVP（默认） / B 改现有项目 / C 先做原型
2. 范围：A 核心流程（默认） / B 加常见增强 / C 做完整产品
3. 验证：A 本地运行检查（默认） / B 真机或线上检查 / C 发布前检查

你可以直接回复：按默认，或回复类似 `1B 2A 3C`。

只有当选项会掩盖重要决定时，才使用开放式问题。

## 定向问题

### 目标结果

- 期望结果是代码改动、文档、发布产物、干净仓库状态、部署，还是已验证诊断？
- 最终结果的用户或评审者是谁？
- “第一版” 是否可接受，还是任务需要生产级完整度？

### 验证

- 项目是否提供命令：`package.json` scripts、Makefile targets、`scripts/`、CI 配置、Xcode schemes、pytest markers 或部署检查？
- 任务是否需要实时验证：浏览器截图、移动端 viewport、API 调用、GitHub PR 状态、发布 URL 或导出文件？
- agent 应该新增/更新测试，还是只运行现有检查？

### 约束

- 哪些公开行为、文件格式、API 契约、schema 或 UX 必须保持不变？
- 密钥、凭证、生产数据、用户内容或私人笔记是否在范围内？
- 是否禁止直接 push 到默认分支？

### 边界

- 哪些目录允许写入？
- 哪些文件、生成产物、缓存或无关模块不能触碰？
- 是否允许修改文档、测试、mocks 或 fixtures？

### 迭代策略

- agent 是否应该一次只做一个聚焦改动，并在每次改动后重跑检查？
- 重复失败后，应该先读日志、查文档、缩小为最小复现，还是暂停？
- 是否有尝试次数、时间或 token 预算上限？

### 完成与暂停

- 哪些证据足以证明完成并停止？
- 哪些阻塞必须交还用户：登录、2FA、付费服务、破坏性删除、法律/医疗/金融决定、账号所有权或产品方向？
- 部分成功时应该报告剩余人工步骤，还是继续直到完整结果被证明？

## 访谈输出形状

```text
推荐执行版（中文，可直接复制）
/goal 基于用户需求创建第一版本地 MVP，先读取项目已有命令和约束，实现核心用户可见流程，并避免改动无关系统。
验证：运行项目提供的最小相关检查，启动本地应用或对应运行环境，完整走通一次核心流程，并用日志、截图或命令输出作为证据。
约束：不加入账号、付费服务、生产变更、破坏性操作或无关功能，除非用户明确要求。
边界：只写入新项目目录，或只修改现有项目中与该功能直接相关的文件。
迭代策略：一次实现一个聚焦工作流，每次有意义改动后重跑检查，重试前先读日志，最多做 3 轮聚焦改进后报告剩余风险。
完成条件：核心流程有运行证据证明可用，检查通过或明确说明缺少配置。
暂停条件：需要凭证、付费、生产数据、破坏性操作、法律/医疗/金融判断、版权素材或所有权不清时暂停。

默认选择理由：[一句话说明为什么这些默认选项成本最低、风险最稳或最能验证核心价值。]

可选调整
1. [决策点]：A [推荐默认] / B [备选] / C [高成本选项]

你可以直接回复：按默认，或回复类似 1B 2A 3C。
```

## 中文输出形状

中文用户优先用这一版。命令前缀仍然写 `/goal`，不要写 `/目标`。默认先给中文推荐执行版，再给英文兼容版，除非用户明确只要一种语言。

```text
推荐执行版（中文，可直接复制）
/goal 基于用户需求创建第一版本地 MVP，先读取项目已有命令和约束，实现核心用户可见流程，并避免改动无关系统。
验证：运行项目提供的最小相关检查，启动本地应用或对应运行环境，完整走通一次核心流程，并用日志、截图或命令输出作为证据。
约束：不加入账号、付费服务、生产变更、破坏性操作或无关功能，除非用户明确要求。
边界：只写入新项目目录，或只修改现有项目中与该功能直接相关的文件。
迭代策略：一次实现一个聚焦工作流，每次有意义改动后重跑检查，重试前先读日志，最多做 3 轮聚焦改进后报告剩余风险。
完成条件：核心流程有运行证据证明可用，检查通过或明确说明缺少配置。
暂停条件：需要凭证、付费、生产数据、破坏性操作、法律/医疗/金融判断、版权素材或所有权不清时暂停。

默认选择理由：[一句话说明为什么这些默认选项成本最低、风险最稳或最能验证核心价值。]

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

保持访谈简短。目标是降低歧义，不是让用户填表。
