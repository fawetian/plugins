---
name: code-research
description: "Deep research and understanding of the current project. Use this skill when the user wants to deeply understand a project's design philosophy, architectural decisions, Day 0 product and technical-solution intent, evolution history, implementation map, source reading path, prerequisite knowledge modules, source-backed quality map, core mechanisms, data flow, or key algorithms. Trigger: code-research."
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
| How to read the source code | learning_path + architecture | dependencies unless needed |
| What foundation knowledge is needed to understand the project | learning_path + dependencies | workflow unless needed |
| How the system evolved | evolution_history + implementation_map | learning_path, dependencies unless needed |
| How to design X from scratch | design_evolution + mechanism | dependencies, learning_path |
| What the author would design on Day 0 | day0_product_technical_design + design_evolution | dependencies unless needed |
| Code quality and maintainability risks | quality_map + implementation_map | dependencies unless needed |
| Comparing two approaches | mechanism × 2 | everything else |

**Subdirectory workflow**:
1. **Focused Phase 1**: Create a scoped RESEARCH_PLAN.md in `docs/code-research/{topic-slug}/` with only the selected topics.
2. **Reference main research**: Agent prompts must state "Reference existing research at `docs/code-research/` for global context; this subdirectory only covers [topic-specific details]."
3. **Focused Phase 2**: Launch agents only for the selected templates, outputting to the subdirectory.
4. **Focused Phase 3**: Write summary in the subdirectory's RESEARCH_PLAN.md, and add a cross-reference entry in the main RESEARCH_PLAN.md pointing to this subdirectory.

## Workflow

### Phase 1: Quick Scan, Create Research Plan

Read README, directory structure, entry files, dependency files, and Git history to establish initial understanding of the project.

For Git history, inspect the target project, not this skill:
- Use `git log --oneline --decorate --max-count=80` for the overall timeline.
- Use `git log --name-status --format=...` on key directories after the quick scan identifies them.
- Identify milestone commits by capability changes, module boundary changes, data model changes, and large refactors.
- Record when a conclusion is explicit from commits vs. inferred from diff order and current code.

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
- [templates/learning_path.md](templates/learning_path.md) — Source Reading Path and prerequisite knowledge modules from directory and code structure
- [templates/evolution_history.md](templates/evolution_history.md) — Evolution History from Git commits
- [templates/implementation_map.md](templates/implementation_map.md) — Implementation Map connecting evolution to current code
- [templates/design_evolution.md](templates/design_evolution.md) — First-principles design evolution
- [templates/day0_product_technical_design.md](templates/day0_product_technical_design.md) — Day 0 product requirements and technical-solution reconstruction from source evidence
- [templates/quality_map.md](templates/quality_map.md) — Source-backed code quality and maintainability risk map

The default full research output is:
1. `01_architecture.md`
2. `02_mechanism_[name].md`
3. `03_data_flow.md`
4. `04_dependencies.md`
5. `05_workflow.md`
6. `06_learning_path.md` — analyze prerequisite knowledge, project directories, and code structure, then plan a source-reading route
7. `07_evolution_history.md`
8. `08_implementation_map.md`
9. `09_design_evolution.md`
10. `10_day0_product_technical_design.md`
11. `11_quality_map.md`

Dependency rules for the new synthesis topics:
- `06_learning_path.md` must be a standalone source-reading path file. It should explain prerequisite knowledge modules needed to understand the project, adapt the list to the user's background when given (for example backend engineer with weak frontend basics), explain the directory structure from a reader's perspective, identify entry files and core modules, order the files to read, and mark which directories can be skipped at first.
- `07_evolution_history.md` must be based on the target project's Git history and diffs. Do not reconstruct history from current code alone.
- `08_implementation_map.md` should connect the historical stages from `07_evolution_history.md` to current modules, interfaces, data structures, runtime components, and storage/state.
- `09_design_evolution.md` should ignore chronological commit order and reason from first principles: minimal design → exposed problem → added design → complexity cost → current code anchor.
- `10_day0_product_technical_design.md` should reconstruct the author's Day 0 view: requirement origin, target users, MVP boundary, initial technical solution, product pressures that forced later technical choices, and evidence level. It is reverse research of the existing project, not a new future implementation plan. If the user asks to design a new feature or write an RFC/ADR/implementation plan, use `technical-design` instead.
- `11_quality_map.md` must read the target source code directly. Previous research may guide file selection, but it is not evidence. Every conclusion must cite concrete file paths plus functions, types, configs, or call chains and the observed code behavior. High-risk findings require at least two source evidence points; medium/low findings require at least one. Findings without source evidence must go to unresolved questions.
- Quality Map identifies maintainability risks from source evidence; it does not perform line-by-line review, vulnerability scanning, profiling, or code changes. Do not produce a total score. Use module-level Low/Medium/High risk levels.
- If Explore Agents cannot depend on each other, write 07/08/09/10/11 during Phase 3 after the factual topics are complete.

### Phase 3: Summary & Integration

After all topics are complete, add a research summary at the top of `docs/code-research/RESEARCH_PLAN.md`: project core value, index of each topic document, design highlights worth noting.

For full research, the summary must include:
- the prerequisite knowledge modules, source-reading route, and directory-structure highlights from `06_learning_path.md`
- the main historical evolution route from `07_evolution_history.md`
- the current implementation map highlights from `08_implementation_map.md`
- the first-principles design route from `09_design_evolution.md`
- the author-perspective Day 0 product and technical-solution reconstruction from `10_day0_product_technical_design.md`
- the source-backed quality and maintainability risk highlights from `11_quality_map.md`

---

## Research Strategy

**Files to ignore**: Test files (`*_test.*`, `__tests__/`, `tests/`, `spec/`), dependency directories (`node_modules/`, `vendor/`, `dist/`), lock files. Exception: `11_quality_map.md` may read test files and test configuration only to assess test coverage gaps.

**Code reading order**: Interface/Protocol definitions → Core data structures → Main flow → Boundary handling

**When encountering unclear code**: Record to "Unresolved Questions" section in `RESEARCH_PLAN.md`, don't skip.

**Quality standard**: After completing research, should be able to explain what problem the project solves in one paragraph, draw a core module dependency diagram, trace the call chain of any core function, explain 2-3 key design decisions and reasons.

---

## Flexible Adjustments

- **"Give me a rough understanding"** → Only do architecture topic
- **"I want to understand feature X"** → Focus on breaking down X's mechanism topic
- **"I want to contribute code"** → Complete all topics
- **"I want to read the source code"** → Learning Path topic + Architecture topic
- **"I am a backend engineer and my frontend basics are weak"** → Learning Path topic + Dependencies topic
- **"How does this system work?"** → Architecture topic + Workflow topic
- **"How did this system evolve?"** → Evolution History topic + Implementation Map topic
- **"How would we design this from scratch?"** → First-principles Design Evolution topic
- **"I want the author's Day 0 perspective"** → Day 0 Product & Technical Solution topic + Design Evolution topic
- **"How is this codebase's quality?"** → Quality Map topic + Implementation Map topic
- **"Compare two projects"** → Do architecture topic for both projects, then write comparison analysis
