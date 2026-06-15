# Upstream

- Repository: https://github.com/joeseesun/qiaomu-goal-meta-skill
- SSH: git@github.com:joeseesun/qiaomu-goal-meta-skill.git
- Branch: main
- Imported commit: f29e0189f2ea03392c50b4f1c7230886bd838a13
- Imported date: 2026-06-15
- License: MIT

## Update

```bash
tmp=$(mktemp -d /tmp/qiaomu-goal-meta-skill.XXXXXX)
git clone --depth 1 https://github.com/joeseesun/qiaomu-goal-meta-skill.git "$tmp"
new_commit=$(git -C "$tmp" rev-parse HEAD)
rsync -a --delete --exclude .git --exclude UPSTREAM.md "$tmp"/ plugins/harness-space/vendor/qiaomu-goal-meta-skill/
echo "Imported upstream commit: $new_commit"
```

After updating the vendor copy, review whether `plugins/harness-space/skills/goal-meta/` needs local trigger, documentation, reference, or eval changes. Do not register the vendored upstream skill as a second marketplace skill.
