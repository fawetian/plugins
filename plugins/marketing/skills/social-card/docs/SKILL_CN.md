# 归藏社媒卡片 Wrapper

这是对上游 [`op7418/guizang-social-card-skill`](https://github.com/op7418/guizang-social-card-skill) 的本地包装 skill；上游许可证为 AGPL-3.0。

适用场景：

- 小红书 / Rednote 3:4 图文组图。
- 公众号封面对：21:9 头图 + 1:1 分享卡。
- 从文章、脚本、截图、产品笔记、字幕或照片生成瑞士风或电子杂志风社媒卡片。

## 集成范式

本插件采用 wrapper + vendor 范式：

- `skills/social-card/SKILL.md` 是唯一注册给 Claude Code / Codex 的 skill。
- `vendor/guizang-social-card-skill/` 保留上游项目原文和素材。
- wrapper 读取 `vendor/guizang-social-card-skill/SKILL.md`，并从 vendor 根目录解析上游 references、templates、assets 和校验脚本。
- 分发本插件时保留上游 `LICENSE` 文件和 attribution。

这样既能把入口收敛到本地 `marketing` 插件，又能后续跟进上游更新。

## 更新上游

上游来源记录在 `vendor/guizang-social-card-skill/UPSTREAM.md`。

在干净 worktree 中更新：

```bash
git subtree pull \
  --prefix=plugins/marketing/vendor/guizang-social-card-skill \
  https://github.com/op7418/guizang-social-card-skill.git \
  main \
  --squash
```

更新后检查 diff，递增 `marketing` 插件版本和 marketplace 版本，然后运行：

```bash
./tests/run-all.sh --structure
python3 /Users/shanquan/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/marketing
./tests/run-all.sh --trigger --skill social-card
```
