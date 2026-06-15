---
name: technical-design
description: "Use this skill only for engineering technical design: implementation plans, RFCs, ADRs, architecture proposals, and engineering solutions for features, refactors, migrations, integrations, or production changes. Do not use for PRDs, product requirements, user stories, product roadmaps, code research, or code review. Triggers: technical design, tech spec, implementation plan, RFC, ADR, 技术方案, 架构方案, 实施方案."
userInvocable: true
---

# Technical Design

Write practical engineering design documents grounded in the current codebase and the user's stated requirements.

## Output Rules

- Default all user-facing output and generated documents to Chinese unless the user requests another language.
- Prefer writing a durable Markdown document instead of only answering in chat.
- Default path: `docs/technical-design/{topic-slug}.md`.
- If the user names a path, use that exact path.
- Keep product requirements, implementation design, and task breakdown separate. Do not turn the document into a PRD.
- Do not invent repository facts. Read the relevant code, config, docs, tests, and existing design notes first.
- If a business rule, compatibility requirement, or operational constraint is unclear and materially changes the design, record it under "Open Questions" and ask the user before locking the plan.

## When To Use

Use this skill for:

- New feature technical plans.
- Refactor or migration designs.
- Architecture proposals and RFC-style documents.
- ADRs for important technical decisions.
- Integration plans involving external services, APIs, jobs, data stores, or infrastructure.
- Implementation plans that need risks, rollout, tests, and task sequencing.

Do not use this skill for:

- Pure PRD/product requirement writing. Use product skills instead.
- Existing-code research with no proposed change. Use `code-research`.
- Code review findings. Use `code-review`.
- Simple bug fixes where the user asked for direct implementation and no design is needed.

## Workflow

### 1. Establish Scope

Identify:

- Problem statement and desired outcome.
- In-scope and out-of-scope work.
- Target users or systems affected.
- Required behavior changes.
- Non-functional requirements: performance, reliability, security, privacy, cost, compatibility, observability.

If the request is broad, create a concise scope summary and continue with reasonable assumptions. Ask only when missing information blocks a safe design.

### 2. Inspect The Current System

Read enough real project context to make the design implementable:

- README, architecture docs, AGENTS/CLAUDE instructions.
- Relevant modules, APIs, schemas, configs, jobs, tests, and deployment files.
- Existing patterns for routing, persistence, auth, background work, error handling, logging, and feature flags.
- Similar implementations in the repository.

Capture verified facts separately from assumptions.

### 3. Choose The Design Shape

Compare viable options when more than one path exists. Keep this section concise and decision-oriented:

- Option.
- How it works.
- Benefits.
- Costs and risks.
- Why selected or rejected.

Use ADR format when the user asks for ADR or when the decision is narrow and long-lived.

### 4. Write The Technical Design

Use this structure unless the repository already has a stronger local template:

```markdown
# {Title} 技术方案

## 1. 背景

## 2. 目标与非目标

## 3. 当前系统现状

## 4. 方案概览

## 5. 详细设计

### 5.1 模块边界

### 5.2 数据模型

### 5.3 API / 接口

### 5.4 核心流程

### 5.5 权限、安全与隐私

### 5.6 错误处理与降级

### 5.7 可观测性

## 6. 备选方案

## 7. 迁移与发布计划

## 8. 测试与验收

## 9. 风险与应对

## 10. 实施任务拆分

## 11. 待确认问题
```

For small changes, collapse empty subsections. For migrations, emphasize compatibility, backfill, rollback, monitoring, and data validation.

### 5. Add Diagrams When Helpful

Use Mermaid for architecture, sequence, state, or data-flow diagrams when they clarify the proposal. Keep diagrams close to the section they explain.

### 6. Make The Plan Executable

The implementation section must include:

- Ordered phases.
- Files or modules likely to change.
- Tests to add or update.
- Validation commands.
- Rollout and rollback steps when production behavior changes.

Avoid vague tasks like "update backend". Prefer concrete, reviewable steps.

### 7. Final Response

After writing the document, summarize:

- File path.
- Selected approach.
- Main risks or open questions.
- Validation performed.

Do not claim implementation is complete unless code changes were actually made.
