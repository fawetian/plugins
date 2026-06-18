# Yao Meta Skill Plugin

Wrapper plugin for [yaojingang/yao-meta-skill](https://github.com/yaojingang/yao-meta-skill), a Skill OS workflow for creating, refactoring, evaluating, and packaging reusable agent skills.

## Install

Claude Code:

```bash
/plugin install yao-meta-skill@fawetian-plugins
```

Codex:

```bash
codex plugin add yao-meta-skill@fawetian-plugins-codex
```

## Skills

- `yao-meta-skill`: creates, refactors, evaluates, and packages reusable agent skills from workflows, prompts, transcripts, docs, or notes.

## Integration Model

This plugin follows the repository's wrapper plus vendor pattern:

- The registered skill is `skills/yao-meta-skill/SKILL.md`.
- The upstream project is stored under `vendor/yao-meta-skill/`.
- Local trigger wording, marketplace metadata, docs, and evals live in the wrapper layer.
- The vendored upstream `SKILL.md` is not registered as a second skill.

## Source Attribution

- Upstream: [yaojingang/yao-meta-skill](https://github.com/yaojingang/yao-meta-skill)
- Imported commit: `31ce04c655d1fc6da7a0eac095f09f78ffa9854f`
- License: MIT
