# Marketing Plugin

Marketing content workflows for Claude Code and Codex.

## Skills

- `social-card`: wrapper for the vendored upstream `op7418/guizang-social-card-skill` (AGPL-3.0), used for Xiaohongshu/Rednote carousel images, WeChat Official Account cover pairs, and social card image sets.

## External Skill Integration Pattern

This plugin uses a wrapper plus vendor pattern:

- Register only local wrapper skills under `skills/`.
- Store upstream projects under `vendor/`.
- Keep upstream files unchanged whenever possible.
- Put local trigger wording, marketplace metadata, docs, evals, and adaptation notes in the wrapper layer.
- Record upstream source, commit, and update commands in the vendor `UPSTREAM.md`.
- Preserve upstream attribution and license files when distributing this plugin.

This keeps plugin routing stable while preserving an update path for external skills.
