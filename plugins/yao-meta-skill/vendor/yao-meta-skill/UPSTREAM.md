# Upstream

- Repository: https://github.com/yaojingang/yao-meta-skill
- Branch: `main`
- Imported commit: `31ce04c655d1fc6da7a0eac095f09f78ffa9854f`
- Imported date: 2026-06-18
- License: MIT
- Integration: vendored upstream used by `plugins/yao-meta-skill/skills/yao-meta-skill`

## Update

When the worktree is clean, update the vendor copy with:

```bash
tmp=$(mktemp -d /tmp/yao-meta-skill.XXXXXX)
git clone --depth 1 https://github.com/yaojingang/yao-meta-skill.git "$tmp"
new_commit=$(git -C "$tmp" rev-parse HEAD)
rsync -a --delete \
  --exclude .git \
  --exclude .github \
  --exclude .previews \
  "$tmp"/ plugins/yao-meta-skill/vendor/yao-meta-skill/
printf 'Imported upstream commit: %s\n' "$new_commit"
```

After updating the vendor copy, review whether `plugins/yao-meta-skill/skills/yao-meta-skill/` needs local trigger, documentation, or eval changes. Do not register the vendored upstream skill as a second marketplace skill.
