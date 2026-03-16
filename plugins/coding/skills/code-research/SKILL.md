---
name: code-research
description: Deep research and understanding of the current project. Use this skill when the user wants to deeply understand a project's design philosophy, architectural decisions, core mechanisms, data flow, or key algorithms. Trigger: code-research.
---

# Code Research

A systematic research workflow for deeply understanding the current codebase.

## Core Philosophy

**Top-down approach**: Start from the big picture, then drill down into details. Understand the whole before the parts.

There are only two core questions when researching code: **What is this module** and **Why is it needed**. "How it's implemented" is the last concern. Every module and design decision must first answer these two questions before discussing implementation details.

## Constraints

- **Use Mermaid for diagrams**: All architecture diagrams, flowcharts, and relationship diagrams must be drawn using Mermaid syntax.

## Workflow

### Phase 1: Quick Scan, Create Research Plan

Read README, directory structure, entry files, dependency files to establish initial understanding of the project.

Then create `docs/research/RESEARCH_PLAN.md`, breaking down research tasks into several **independent topics**. Reference template: [templates/research_plan.md](templates/research_plan.md)

After the plan is written, confirm with user or execute directly (depending on the situation).

### Phase 2: Parallel Research

Launch independent Explore Agents for each topic in parallel.

Each Agent's prompt should include:
- Clear research objectives
- File/module scope to focus on
- Output file path
- **Each module must answer What/Why first, then discuss implementation**

Output templates for each topic are in the `templates/` directory:
- [templates/architecture.md](templates/architecture.md) — Architecture Overview
- [templates/mechanism.md](templates/mechanism.md) — Core Mechanisms
- [templates/data_flow.md](templates/data_flow.md) — Data Flow & State
- [templates/dependencies.md](templates/dependencies.md) — Dependencies & Ecosystem
- [templates/learning_path.md](templates/learning_path.md) — Learning Path

### Phase 3: Summary & Integration

After all topics are complete, add a research summary at the top of `RESEARCH_PLAN.md`: project core value, index of each topic document, design highlights worth noting.

---

## Research Strategy

**Files to ignore**: Test files (`*_test.*`, `__tests__/`, `tests/`, `spec/`), dependency directories (`node_modules/`, `vendor/`, `dist/`), lock files.

**Code reading order**: Interface/Protocol definitions → Core data structures → Main flow → Boundary handling

**When encountering unclear code**: Record to "Unresolved Questions" section in `RESEARCH_PLAN.md`, don't skip.

**Quality standard**: After completing research, should be able to explain what problem the project solves in one paragraph, draw a core module dependency diagram, trace the call chain of any core function, explain 2-3 key design decisions and reasons.

---

## Flexible Adjustments

- **"Give me a rough understanding"** → Only do architecture topic
- **"I want to understand feature X"** → Focus on breaking down X's mechanism topic
- **"I want to contribute code"** → Complete all topics
- **"Compare two projects"** → Do architecture topic for both projects, then write comparison analysis
