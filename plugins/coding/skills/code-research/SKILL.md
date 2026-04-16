---
name: code-research
description: Deep research and understanding of the current project. Use this skill when the user wants to deeply understand a project's design philosophy, architectural decisions, core mechanisms, data flow, or key algorithms. Trigger: code-research.
userInvocable: true
---

# Code Research

A systematic research workflow for deeply understanding the current codebase.

## Core Philosophy

**Top-down approach**: Start from the big picture, then drill down into details. Understand the whole before the parts.

There are only two core questions when researching code: **What is this module** and **Why is it needed**. "How it's implemented" is the last concern. Every module and design decision must first answer these two questions before discussing implementation details.

## Constraints

- **ALL output must be in Chinese (中文)**: All documents, research reports, diagrams, and comments must be written in Chinese. No English allowed in the output.
- **Use Mermaid for diagrams**: All architecture diagrams, flowcharts, and relationship diagrams must be drawn using Mermaid syntax.

## Phase 0: Existing Research Detection

Before starting, check whether `docs/code-research/` already exists with files.

1. Check for `docs/code-research/RESEARCH_PLAN.md` and any `*.md` files in that directory.

2. **Directory does not exist or is empty**: proceed directly to Phase 1.

3. **Directory exists with files**:
   - Read `RESEARCH_PLAN.md` to understand previous research scope.
   - Check which topic output files exist vs. missing.
   - Present applicable options to the user (omit options that don't apply):

   **A. Full re-research (overwrite all)** — Delete existing files, start fresh from Phase 1. Best when the codebase has changed significantly.

   **B. Resume incomplete research** — Only available when some topic files are missing. Read RESEARCH_PLAN.md, identify topics without output files, launch agents only for those. Existing files untouched.

   **C. Archive and restart** — Rename `docs/code-research/` to `docs/code-research/_archived_{YYYY-MM-DD}/` (use current date), then start Phase 1 normally. Old research preserved.

   **D. Research a new topic** — Only available when user's invocation targets a specific area. Create subdirectory `docs/code-research/{topic-slug}/` for focused research. Existing research untouched. See "Option D Scope" below.

   Include a recommendation based on detected state:
   - Some files missing → recommend **B**
   - All files present and complete → recommend **A** (or **C** if old research may be useful)
   - User's request targets a specific area → highlight **D**

4. After user chooses:
   - **A**: Delete existing files → Phase 1
   - **B**: Skip Phase 1 → Phase 2 (only missing topics)
   - **C**: Rename directory → Phase 1
   - **D**: Focused Phase 1 with scoped output paths and template selection (see below)

### Option D: Topic Subdirectory Research Scope

The main directory already provides the global view. The subdirectory should focus only on what's unique about the specific topic — no duplication.

**Scope determination**: Based on the user's topic description, select 1-3 relevant templates:

| User's focus | Relevant templates | Skip |
|-------------|-------------------|------|
| A specific module/mechanism | mechanism + data_flow | architecture, dependencies, learning_path |
| How X works end-to-end | workflow + architecture(local) | dependencies, learning_path |
| Data modeling of X | data_flow + dependencies | workflow, learning_path |
| Comparing two approaches | mechanism × 2 | everything else |

**Subdirectory workflow**:
1. **Focused Phase 1**: Create a scoped RESEARCH_PLAN.md in `docs/code-research/{topic-slug}/` with only the selected topics.
2. **Reference main research**: Agent prompts must state "Reference existing research at `docs/code-research/` for global context; this subdirectory only covers [topic-specific details]."
3. **Focused Phase 2**: Launch agents only for the selected templates, outputting to the subdirectory.
4. **Focused Phase 3**: Write summary in the subdirectory's RESEARCH_PLAN.md, and add a cross-reference entry in the main RESEARCH_PLAN.md pointing to this subdirectory.

## Workflow

### Phase 1: Quick Scan, Create Research Plan

Read README, directory structure, entry files, dependency files to establish initial understanding of the project.

Then create `docs/code-research/RESEARCH_PLAN.md`, breaking down research tasks into several **independent topics**. Reference template: [templates/research_plan.md](templates/research_plan.md)

After the plan is written, confirm with user or execute directly (depending on the situation).

### Phase 2: Parallel Research

Launch independent Explore Agents for each topic in parallel.

Each Agent's prompt should include:
- Clear research objectives
- File/module scope to focus on
- Output file path
- **CRITICAL: ALL content must be written in Chinese (中文)**
- **Each module must answer What/Why first, then discuss implementation**

Output templates for each topic are in the `templates/` directory:
- [templates/architecture.md](templates/architecture.md) — Architecture Overview
- [templates/mechanism.md](templates/mechanism.md) — Core Mechanisms
- [templates/data_flow.md](templates/data_flow.md) — Data Flow & State
- [templates/dependencies.md](templates/dependencies.md) — Dependencies & Ecosystem
- [templates/workflow.md](templates/workflow.md) — Core Workflows
- [templates/learning_path.md](templates/learning_path.md) — Learning Path

### Phase 3: Summary & Integration

After all topics are complete, add a research summary at the top of `docs/code-research/RESEARCH_PLAN.md`: project core value, index of each topic document, design highlights worth noting.

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
- **"How does this system work?"** → Architecture topic + Workflow topic
- **"Compare two projects"** → Do architecture topic for both projects, then write comparison analysis
