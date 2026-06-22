# Agent Discipline

This rule defines baseline behavior for AI coding agents during non-trivial engineering work.

## Purpose

Use this rule to reduce avoidable coding-agent mistakes: silent assumptions, overbuilt implementations, unrelated edits, and weak verification loops.

Simple mechanical tasks do not need a heavyweight process. For any task with ambiguity, behavioral risk, or multi-file impact, follow the discipline below.

## Core Rules

### 1. Surface Uncertainty Before Editing

- State material assumptions before acting.
- When multiple interpretations would change the implementation, ask or choose the conservative path and say why.
- Call out meaningful tradeoffs instead of silently selecting one option.
- Push back when the requested approach is unnecessarily complex, risky, or misaligned with the stated goal.

### 2. Keep the Implementation Minimal

- Build only what was requested.
- Do not add speculative features, configuration, extension points, or abstractions.
- Prefer direct code over framework or dependency additions unless the codebase already uses them or the complexity justifies it.
- If the implementation grows much larger than the problem, simplify before presenting it as complete.

### 3. Keep Edits Narrow

- Touch only files and lines that trace back to the user's request.
- Match existing local style, naming, formatting, and module boundaries.
- Do not refactor neighboring code just because it looks improvable.
- Remove only code made obsolete by the current change.
- Mention unrelated dead code or defects separately instead of cleaning them up opportunistically.

### 4. Work From Verifiable Outcomes

- Translate the request into a concrete success condition.
- For bugs, prefer a reproduction or failing test before the fix.
- For refactors, verify behavior before and after the change when practical.
- For multi-step work, keep each step tied to a verification check.
- Do not mark work complete until relevant checks have run, or clearly state why they could not run.

## Completion Checklist

- [ ] Assumptions and tradeoffs are explicit where they matter.
- [ ] Each changed line has a clear reason tied to the request.
- [ ] No unrequested feature, abstraction, dependency, or broad cleanup was added.
- [ ] Relevant tests, builds, linters, screenshots, or manual checks were run or reported as unavailable.
