---
name: design-md-selector
description: "Select and apply a matching DESIGN.md from VoltAgent/awesome-design-md. Use when the user asks to choose, find, compare, or apply a visual style, design language, DESIGN.md, brand-inspired UI style, landing page style, app UI style, or website aesthetic for the current project, especially before building a frontend. Do not use for PRDs, product requirements, social card generation, generic UI implementation without style selection, or brand asset creation."
---

# Design.md Selector

## Overview

Choose the three closest upstream `DESIGN.md` files from `VoltAgent/awesome-design-md`, ask the user which one to apply, then copy the confirmed upstream file into the current project as `DESIGN.md`.

Do not summarize or rewrite the selected file. The job is selection, confirmation, and exact application.

## Source

- Repository: `https://github.com/VoltAgent/awesome-design-md`
- Catalog path: `design-md/<slug>/DESIGN.md`
- Raw URL pattern: `https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<slug>/DESIGN.md`

Prefer live GitHub data. Do not keep or trust a bundled list of slugs.

## Workflow

1. Identify the current project root with `git rev-parse --show-toplevel`; fall back to `pwd` when outside Git.
2. Read the user's UI need: product type, audience, page type, density, tone, and any explicit style hints.
3. Fetch the live catalog:
   - First try `gh api repos/VoltAgent/awesome-design-md/contents/design-md --jq '.[].name'`.
   - If `gh` is unavailable, use GitHub's contents API with `curl`.
   - Clone only to a temp directory if both direct options are insufficient.
4. Pick exactly three candidate slugs. Use the README category text and, when needed, the first part of each candidate's `DESIGN.md` to verify fit.
5. Reply with exactly three choices and a short reason for each. Include the expected fit and one caveat when relevant.
6. Ask the user to choose one by rank or slug. Say that `yes` applies rank 1. If `<project-root>/DESIGN.md` already exists, state that applying will replace it.
7. Stop. Do not write files until the user confirms a candidate.

## Apply After Confirmation

When the user confirms:

1. Resolve the selected slug from the prior three choices. If the user replies only `yes`, use rank 1.
2. Fetch the upstream raw `DESIGN.md`.
3. Write the fetched content exactly to `<project-root>/DESIGN.md`.
4. Report the selected slug, source URL, and target path.

If the fetch fails, do not create a partial `DESIGN.md`; report the error and ask whether to retry.

## Selection Heuristics

- Developer tools, AI platforms, SaaS dashboards: prefer options such as `linear.app`, `vercel`, `raycast`, `supabase`, `cursor`, `voltagent`, or `stripe`.
- Editorial, knowledge, docs, or workspace products: prefer `notion`, `mintlify`, `wired`, `theverge`, or `apple`.
- Consumer, ecommerce, media, or brand-heavy surfaces: prefer `airbnb`, `nike`, `spotify`, `shopify`, `figma`, or `pinterest`.
- Finance or trust-heavy products: prefer `stripe`, `wise`, `coinbase`, `mastercard`, or `revolut`.
- If the user's request conflicts with an exact brand clone, choose "inspired by" fit and avoid copying logos, trademarks, or proprietary assets.

## Response Shape

Use this compact shape:

```text
Top 3:
1. <slug> — <why it fits>
2. <slug> — <why it fits>
3. <slug> — <why it fits>

Reply 1/2/3 or a slug to apply it to <project-root>/DESIGN.md. Reply no to skip.
```
