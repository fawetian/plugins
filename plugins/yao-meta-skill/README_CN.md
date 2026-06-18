# Yao Meta Skill 插件

[yaojingang/yao-meta-skill](https://github.com/yaojingang/yao-meta-skill) 的本地包装插件。它是一套 Skill OS 工作流，用于从工作流、提示词、对话记录、文档或笔记中创建、重构、评估并打包可复用 agent skills。

## 安装

Claude Code:

```bash
/plugin install yao-meta-skill@fawetian-plugins
```

Codex:

```bash
codex plugin add yao-meta-skill@fawetian-plugins-codex
```

## Skills

- `yao-meta-skill`：从工作流、提示词、对话记录、文档或笔记中创建、重构、评估并打包可复用 agent skills。

## 集成方式

本插件遵循仓库的 wrapper + vendor 范式：

- 注册到 marketplace 的 skill 是 `skills/yao-meta-skill/SKILL.md`。
- 上游项目保存在 `vendor/yao-meta-skill/`。
- 本地触发语义、marketplace 元数据、文档和 evals 放在 wrapper 层。
- vendored upstream 的 `SKILL.md` 不会作为第二个 skill 注册。

## 来源标注

- 上游：[yaojingang/yao-meta-skill](https://github.com/yaojingang/yao-meta-skill)
- 导入 commit：`31ce04c655d1fc6da7a0eac095f09f78ffa9854f`
- 许可证：MIT
