# Goal Meta

Generate copy-ready Codex `/goal` commands from vague or complex agent-work requests. The skill turns a loose request into a bounded task contract with outcome, verification, constraints, write boundaries, iteration policy, stop conditions, and pause conditions.

## Installation

This skill is Codex-only in this repository. It is not registered in the Claude Code plugin manifest.

```bash
codex plugin add harness-space@fawetian-plugins-codex
```

## When To Use

Use `goal-meta` when you want to draft a Codex `/goal` before starting a multi-step task.

Examples:

```text
goal-meta 帮我把这个需求写成 Codex /goal：我要做一个 iOS 提词器 MVP
```

```text
把这个模糊任务转成 /goal，包含验证、边界、完成条件和暂停条件。
```

```text
为这个发布任务写一个不能直接推主分支的 /goal。
```

Do not use it for PRDs, product roadmaps, technical designs, RFCs, ADRs, code review, or requests where the user wants the task executed directly.

## Output

Chinese users get:

- `推荐执行版（中文，可直接复制）`
- `默认选择理由`
- `可选调整`
- `你可以直接回复`
- `Goal Draft (English-compatible)`

English users get the English-compatible draft unless they ask for Chinese too.

## Quality Checks

The skill includes a lightweight linter for generated goal drafts:

```bash
python3 plugins/harness-space/skills/goal-meta/scripts/lint_goal_command.py goal.txt
```

It checks for required `/goal` labels, unresolved placeholders, unsafe vague instructions, and verification that lacks concrete evidence.

## Upstream

Adapted from [joeseesun/qiaomu-goal-meta-skill](https://github.com/joeseesun/qiaomu-goal-meta-skill) under the MIT License. The upstream source is vendored in `plugins/harness-space/vendor/qiaomu-goal-meta-skill/`.
