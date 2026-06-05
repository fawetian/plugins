# Upstream

- Repository: https://github.com/op7418/guizang-social-card-skill
- Branch: `main`
- Imported commit: `032782ff67e0a20416bae8159f67000c1e4e7ae2`
- License: AGPL-3.0
- Integration: vendored upstream used by `plugins/marketing/skills/social-card`

## Update

When the worktree is clean, update with:

```bash
git subtree pull \
  --prefix=plugins/marketing/vendor/guizang-social-card-skill \
  https://github.com/op7418/guizang-social-card-skill.git \
  main \
  --squash
```

If the initial import needs to be recreated in a clean branch, use:

```bash
git subtree add \
  --prefix=plugins/marketing/vendor/guizang-social-card-skill \
  https://github.com/op7418/guizang-social-card-skill.git \
  main \
  --squash
```
