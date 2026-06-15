---
name: goal-meta
description: "Create copy-ready Codex /goal commands from vague or complex agent-work requests. Use when the user explicitly asks for a /goal prompt, Goal 指令, 目标指令, Codex goal, agent goal, or to turn a task into a bounded goal with verification, constraints, boundaries, iteration policy, completion evidence, and pause conditions. Do not use for PRDs, product roadmaps, technical designs, RFCs, ADRs, general planning, ordinary success criteria, code review, or when the user wants the task executed directly."
---

# Goal Meta

You turn vague or complex work requests into strong Codex `/goal` commands. This is a meta skill: it creates the goal instruction only. Do not start the work described by the goal unless the user separately asks to execute it after the goal is drafted.

Adapted from `joeseesun/qiaomu-goal-meta-skill` under the MIT License. The vendored upstream source is stored at `plugins/harness-space/vendor/qiaomu-goal-meta-skill/`.

## Operating Mode

Default stance:

- Produce a paste-ready `/goal` command, not a generic prompt or a half-filled template.
- Keep the executable command prefix as `/goal`. Do not output `/目标` unless the user's current environment explicitly documents that alias.
- For Chinese users, write the recommended goal body in Chinese and use Chinese field names by default.
- For Chinese users, include both `推荐执行版（中文，可直接复制）` and `Goal Draft (English-compatible)` unless the user asks for one language only.
- If the task is vague but low-risk, choose conservative defaults, state the assumption briefly, and continue.
- Ask only when the missing answer materially changes cost, risk, ownership, scope, safety, or product direction.
- If the domain is unfamiliar or specialized, make the goal discovery-first: require the agent to inspect project docs, sample data, official references, or other authoritative context before implementation.
- Prefer concrete verification commands, screenshots, logs, files, API responses, or artifacts over vague confidence statements.
- Prefer narrow write boundaries and explicit forbidden paths over broad permission.
- Treat `Stop when` and `Pause if` as the completion and blocking contract.

## Trigger Boundaries

Use this skill for:

- A user explicitly asking to write a Codex `/goal`.
- `Goal 指令`, `目标指令`, `/goal prompt`, `agent goal`, `bounded agent work`, or similar requests.
- Turning a vague task into a copy-ready goal with verification, boundaries, iteration policy, and pause conditions.
- Drafting a discovery-first goal for a specialized, risky, or unfamiliar domain.

Do not use this skill for:

- PRDs, product requirements, user stories, or product roadmaps.
- Engineering technical designs, RFCs, ADRs, or implementation plans.
- Ordinary planning where the user wants a task list rather than a `/goal`.
- Code review, code research, debugging, or implementation requests where the user wants the work done now.
- Simple rewrites, translations, one-line shell outputs, or other tasks that do not need durable agent persistence.

## Workflow

1. Restate the task as an outcome, not an activity.
2. Classify risk and domain familiarity using `references/default-goal-strategy.md`.
3. Choose conservative defaults for low-risk unknowns and give one concise reason.
4. Fill the goal contract:
   - outcome
   - verification evidence
   - constraints
   - write boundaries
   - iteration policy
   - stop condition
   - pause/block condition
5. If the task is under-specified, prefer short numbered choices with defaults using `references/interview-checklist.md`.
6. For Chinese-first users, output the Chinese recommended goal first, then an English-compatible mirror with the same meaning.
7. Check the command against `references/goal-command-playbook.md`.
8. For file deliverables, run `python3 scripts/lint_goal_command.py <file>` before calling the goal draft done.

## Output Contract

When enough information is known, put the best recommended command first. Do not leave placeholders in executable output.

For Chinese-first users:

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

For English users, output only the English-compatible goal unless they ask for Chinese too.

## Quality Bar

A strong goal:

- has one concrete outcome
- names exact checks, artifacts, or runtime evidence
- protects unrelated files, user data, secrets, default branches, and production systems
- defines the write boundary
- tells the agent how to iterate after failures
- says when to stop because completion is proven
- says when to pause because a human decision, credential, account state, budget, repeated blocker, or external permission is required

Reject or revise a goal that:

- says only `make it better`, `finish this`, or `fix bugs`
- lacks verification
- lets the agent edit the whole machine or repo without reason
- asks for repeated retries without a new source of evidence
- omits pause conditions for auth, secrets, payments, production data, destructive actions, legal/medical/financial judgment, copyrighted assets, or unclear ownership
- leaves placeholders such as `[Outcome]` in executable drafts
- treats vague words such as `高级`, `有质感`, or `professional` as verification instead of translating them into screenshots, runtime checks, review criteria, or bounded iteration

## Reference Files

- `references/goal-command-playbook.md`: canonical goal shape, examples, and anti-patterns.
- `references/default-goal-strategy.md`: conservative defaults, unknown-domain discovery, risk classification, and direct-copy output rules.
- `references/interview-checklist.md`: question bank for turning vague tasks into strong goals.
- `scripts/lint_goal_command.py`: lightweight checker for required `/goal` labels and unresolved placeholders.
