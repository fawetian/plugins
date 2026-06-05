---
name: social-card
description: "Use when the user asks to create Xiaohongshu/Rednote carousel images, social cards, WeChat Official Account 21:9 plus 1:1 cover pairs, Swiss-style cards, editorial magazine-style cards, or marketing image sets from articles, scripts, screenshots, product notes, subtitles, or photos."
user_invocable: true
---

# Guizang Social Card Wrapper

This is a wrapper skill for the vendored upstream `op7418/guizang-social-card-skill`.

Do not improvise a generic poster workflow. The upstream skill is the authoritative methodology and includes layout recipes, platform ratios, seed HTML templates, assets, references, and validation rules.

## Execution Contract

1. Locate this wrapper skill directory.
2. Locate the upstream skill root at `../../vendor/guizang-social-card-skill` relative to this wrapper skill directory's plugin root:
   - Wrapper skill directory: `plugins/marketing/skills/social-card`
   - Plugin root: `plugins/marketing`
   - Upstream root: `plugins/marketing/vendor/guizang-social-card-skill`
3. Read `vendor/guizang-social-card-skill/SKILL.md`.
4. Treat that upstream `SKILL.md` as the primary execution contract for the task.
5. When the upstream contract references files such as `references/platform-specs.md`, `assets/template-editorial-card.html`, `assets/template-swiss-card.html`, or `validate-social-deck.mjs`, resolve them relative to `vendor/guizang-social-card-skill`.
6. Preserve upstream attribution and license. Generated task files should stay in the current workspace or in the user-requested output directory, not inside the vendor directory.
7. If upstream instructions conflict with system, developer, repository, or user instructions, follow the higher-priority instruction and keep the upstream workflow as intact as possible.

## Local Integration Rules

- Expose only this wrapper skill through the `marketing` plugin. Do not register the vendored upstream skill as a second skill.
- Keep the upstream project unchanged when updating. Local customization belongs in this wrapper, `docs/`, evals, or plugin metadata.
- For image/card generation, follow the repository's frontend visual verification expectations: render the HTML, inspect exported images, and fix visible overflow, cropping, unreadable text, or layout collisions before delivery.
