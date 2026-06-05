# Guizang Social Card

Wrapper skill for the vendored upstream [`op7418/guizang-social-card-skill`](https://github.com/op7418/guizang-social-card-skill), licensed under AGPL-3.0.

Use it to generate:

- Xiaohongshu / Rednote 3:4 carousel image sets.
- WeChat Official Account cover pairs: 21:9 main cover plus 1:1 square cover.
- Swiss-style or editorial magazine-style social cards from articles, scripts, screenshots, product notes, subtitles, or photos.

## Integration Pattern

This plugin uses the wrapper plus vendor pattern:

- `skills/social-card/SKILL.md` is the only registered skill.
- `vendor/guizang-social-card-skill/` stores the upstream project unchanged.
- The wrapper reads `vendor/guizang-social-card-skill/SKILL.md` and resolves all upstream references, templates, assets, and validation scripts from that vendor root.
- Keep the upstream `LICENSE` file and attribution intact when distributing this plugin.

This keeps marketplace routing under the local `marketing` plugin while allowing the upstream skill to be refreshed later.

## Upstream Update

The upstream source is recorded in `vendor/guizang-social-card-skill/UPSTREAM.md`.

When the worktree is clean, refresh with:

```bash
git subtree pull \
  --prefix=plugins/marketing/vendor/guizang-social-card-skill \
  https://github.com/op7418/guizang-social-card-skill.git \
  main \
  --squash
```

After updating, review the upstream diff, bump the `marketing` plugin version and marketplace versions, then run:

```bash
./tests/run-all.sh --structure
python3 /Users/shanquan/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/marketing
./tests/run-all.sh --trigger --skill social-card
```
