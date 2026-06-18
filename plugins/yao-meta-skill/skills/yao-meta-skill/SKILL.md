---
name: yao-meta-skill
description: "Create, refactor, evaluate, and package reusable agent skills from workflows, prompts, transcripts, docs, or notes. Use for skill authoring, skill improvement, trigger/output evals, packaging, distribution, and governed skill release readiness. Do not use for ordinary PRDs, code review, technical designs, generic prompt cleanup, plugin marketplace wiring alone, or when the user only wants to execute an existing skill."
userInvocable: true
---

# Yao Meta Skill Wrapper

This is a wrapper skill for the vendored upstream `yaojingang/yao-meta-skill`.

Do not improvise a generic skill-authoring checklist. The upstream skill is the authoritative methodology and includes Skill OS operating modes, reference doctrine, eval guidance, packaging checks, trust reports, generated evidence, and scripts.

## Execution Contract

1. Locate this wrapper skill directory.
2. Locate the upstream skill root at `../../vendor/yao-meta-skill` relative to this wrapper skill directory's plugin root:
   - Wrapper skill directory: `plugins/yao-meta-skill/skills/yao-meta-skill`
   - Plugin root: `plugins/yao-meta-skill`
   - Upstream root: `plugins/yao-meta-skill/vendor/yao-meta-skill`
3. Read `vendor/yao-meta-skill/SKILL.md`.
4. Treat that upstream `SKILL.md` as the primary execution contract for the task.
5. When the upstream contract references files such as `references/skill-engineering-method.md`, `references/operating-modes.md`, `references/resource-boundaries.md`, `references/intent-dialogue.md`, `scripts/`, `templates/`, `registry/`, or `reports/`, resolve them relative to `vendor/yao-meta-skill`.
6. If the user's work is one-off, not reusable, or better handled by an existing nearby skill, follow the upstream "Do not create a skill" path and state the decision clearly.
7. Run upstream scripts from the upstream root when deterministic checks are useful. Do not write generated evidence into the vendor directory unless the user is intentionally updating the vendored package.
8. Preserve upstream attribution and license. Generated task files should stay in the current workspace or in the user-requested output directory.
9. If upstream instructions conflict with system, developer, repository, or user instructions, follow the higher-priority instruction and keep the upstream workflow as intact as possible.

## Local Integration Rules

- Expose only this wrapper skill through the `yao-meta-skill` plugin. Do not register the vendored upstream skill as a second skill.
- Keep the upstream project unchanged when updating. Local customization belongs in this wrapper, `docs/`, evals, or plugin metadata.
- Use the lightest upstream operating mode that satisfies the task: Scaffold for exploratory personal skills, Production for team reuse, Library for shared infrastructure, and Governed for high-trust or release-critical packages.
- Do not fabricate telemetry, approvals, benchmarks, client evidence, or release readiness. Mark unavailable evidence as missing evidence.
- When the task is to package a skill for this repository, also follow this repository's plugin conventions: strict YAML frontmatter, bilingual docs, evals, both Claude and Codex manifests, marketplace entries, and structure validation.
