# Yao Meta Skill

Use this skill to create, refactor, evaluate, and package reusable agent skills from workflows, prompts, transcripts, docs, or notes.

## When To Use

- Turning a repeated workflow into a reusable skill.
- Refactoring a prompt or notes into a skill with clear trigger boundaries.
- Designing trigger evals, output evals, packaging checks, and release gates.
- Auditing an existing skill for drift, portability, governance, or package readiness.

## When Not To Use

- Ordinary PRDs, product roadmaps, RFCs, ADRs, code review, or implementation planning.
- Simple prompt cleanup when no reusable workflow or skill package is needed.
- Plugin marketplace wiring by itself; use this only when skill design is part of the work.
- Executing an existing skill's domain workflow.

## Local Packaging

This is a wrapper around the upstream project stored at `plugins/yao-meta-skill/vendor/yao-meta-skill/`.

The wrapper keeps the marketplace trigger stable while preserving the upstream update path. The upstream project contains the detailed method references, scripts, reports, registry metadata, and generated evidence.

## Install

Claude Code:

```bash
/plugin install yao-meta-skill@fawetian-plugins
```

Codex:

```bash
codex plugin add yao-meta-skill@fawetian-plugins-codex
```
