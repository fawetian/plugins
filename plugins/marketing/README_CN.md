# Marketing 插件

面向 Claude Code 和 Codex 的运营内容工作流。

## Skills

- `social-card`：对上游 `op7418/guizang-social-card-skill`（AGPL-3.0）的 wrapper，用于小红书 / Rednote 图文组图、公众号封面对和社媒卡片图片集。

## 外部 Skill 集成范式

本插件采用 wrapper + vendor 范式：

- 只注册 `skills/` 下的本地 wrapper skill。
- 上游项目放入 `vendor/`。
- 尽量保持上游文件不变。
- 本地触发语义、marketplace 元数据、文档、evals 和适配说明放在 wrapper 层。
- 在 vendor 的 `UPSTREAM.md` 中记录来源、commit 和更新命令。
- 分发本插件时保留上游 attribution 和 license 文件。

这样能保持插件路由稳定，同时保留外部 skill 的后续更新路径。
