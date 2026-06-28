# DESIGN.md Selector

Select the three closest `DESIGN.md` files from `VoltAgent/awesome-design-md`, then apply one to the current project after confirmation.

## Install

Claude Code:

```bash
/plugin install design@fawetian-plugins
```

Codex:

```bash
codex plugin add design@fawetian-plugins-codex
```

## Usage

Ask for a visual style before building a frontend:

```text
Pick three DESIGN.md styles for an AI agent landing page, then ask before applying one.
```

The skill returns three candidates. Reply with `1`, `2`, `3`, a slug, or `yes` to apply rank 1.

## Behavior

- Uses the live upstream catalog instead of a bundled list.
- Writes only after confirmation.
- Applies the selected upstream `DESIGN.md` as-is to the project root.
- Does not clone or import the full upstream repository unless direct GitHub access is insufficient.
