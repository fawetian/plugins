# Claude Code 插件市场

我的 Claude Code 插件市场。

[English](./README.md)

## 添加市场

将此市场添加到 Claude Code：

```bash
/plugin marketplace add fawetian/plugins
```

或使用完整 URL：

```bash
/plugin marketplace add https://github.com/fawetian/plugins
```

## 安装插件

添加市场后，安装插件：

```bash
/plugin install {plugin-name}@fawetian-plugins
```

## 目录结构

```
plugins/
├── .claude-plugin/
│   └── marketplace.json    # 市场配置
├── plugins/                # 内部插件
└── external_plugins/       # 第三方插件
```

## 插件结构

每个插件遵循标准结构：

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # 插件元数据（必需）
├── .mcp.json            # MCP 服务器配置（可选）
├── commands/            # 斜杠命令（可选）
├── agents/              # 智能体定义（可选）
├── skills/              # 技能定义（可选）
└── README.md            # 文档
```

## 外部源

推荐的外部插件/技能源：

| 源 | 描述 |
|----|------|
| [obra/superpowers](https://github.com/obra/superpowers) | Agentic 技能框架与开发方法论 |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Vercel 官方技能集合（React、Next.js、设计指南） |
| [JimLiu/baoyu-skills](https://github.com/JimLiu/baoyu-skills) | 宝玉技能集合 |
| [anthropics/skills](https://github.com/anthropics/skills) | Anthropic 官方技能 |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Claude 官方插件 |

## 参与贡献

欢迎贡献代码！请提交 Pull Request 来添加你的插件。

## 官方文档

- [插件开发指南](https://code.claude.com/docs/zh-CN/plugins)
- [插件市场配置](https://code.claude.com/docs/zh-CN/plugin-marketplaces)
- [技能开发指南](https://code.claude.com/docs/zh-CN/skills)
- [规则与记忆](https://code.claude.com/docs/zh-CN/memory)
