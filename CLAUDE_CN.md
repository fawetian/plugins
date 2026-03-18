# CLAUDE_CN.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作时提供指导。

[English](./CLAUDE.md)

## 项目概述

Claude Code 插件市场 - 通过 GitHub 市场分发的插件集合。

## 架构

```
plugins/
├── .claude-plugin/
│   └── marketplace.json    # 市场清单（pluginRoot 指向 ./plugins）
└── plugins/                # 每个子目录是一个独立的插件
    └── {plugin-name}/
        ├── .claude-plugin/
        │   └── plugin.json # 插件清单（skills 数组引用技能目录）
        ├── skills/         # 技能定义
        │   └── {skill}/
        │       ├── SKILL.md
        │       └── docs/
        │           └── SKILL_CN.md
        └── evals/          # 技能评估测试
            └── evals.json
```

## Skill 规范

1. **SKILL.md 使用英文** - AI 加载执行，避免污染上下文
2. **docs/SKILL_CN.md 使用中文** - 独立文件，不被插件系统加载
3. **两个版本保持同步** - 内容一致，仅语言不同，每次改动 2 个版本同步修改

## 新增 Skill/Plugin 前

**务必先阅读官方文档**了解规范：
- 插件: https://code.claude.com/docs/zh-CN/plugins
- 技能: https://code.claude.com/docs/zh-CN/skills
- 市场: https://code.claude.com/docs/zh-CN/plugin-marketplaces

## 关键约定

- **市场 ID**: `fawetian-plugins`
- **安装命令**: `/plugin install {plugin-name}@fawetian-plugins`
- **技能**: 使用包含 `name` 和 `description` 字段的 YAML frontmatter 以便触发
- **提交格式**: 使用中文描述的约定式提交（针对 git-ops 插件）
- **文档同步**: 修改任何文档文件时必须同时更新中英文两个版本
- **版本号更新**: 修改 skill 内容后，必须更新 `plugin.json` 中的版本号：
  - `PATCH` (1.0.x): Bug 修复、skill 内容小调整
  - `MINOR` (1.x.0): 新增 skill、新功能、skill 重大改动
  - `MAJOR` (x.0.0): 破坏性变更、重大重构
  - 这是 Claude Code 通过 `/plugin update` 检测插件更新的必要条件

## 添加新插件

1. 在 `plugins/` 下创建目录
2. 添加 `.claude-plugin/plugin.json`，包含 name、version、description、skills 数组
3. 在 `skills/` 中创建带有 YAML frontmatter 的技能文件
4. 在 `marketplace.json` 的 plugins 数组中注册插件

## 官方文档

- 插件: https://code.claude.com/docs/zh-CN/plugins
- 技能: https://code.claude.com/docs/zh-CN/skills
- 市场: https://code.claude.com/docs/zh-CN/plugin-marketplaces
