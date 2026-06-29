---
name: sequenzy-email-marketing
description: "当用户希望 AI Agent 操作 Sequenzy 邮件营销流程时使用：订阅者、列表、标签、分群、模板、活动、生命周期序列、交易邮件、收件箱回复、Webhook、投递统计或 Sequenzy MCP 配置。"
user_invocable: true
---

# Sequenzy 邮件营销

本技能用于在 Claude Code、Codex 或其他 Agent 运行环境中操作 Sequenzy。Sequenzy 面向已有授权用户/客户的生命周期邮件、营销活动邮件和交易邮件；不要用于未经许可的冷邮件、爬取联系人群发或垃圾邮件。

## 关键入口

- Skill 仓库：`https://github.com/Sequenzy/skills`
- 主技能：`sequenzy-email-marketing`
- MCP 仓库：`https://github.com/Sequenzy/mcp`
- MCP 包：`@sequenzy/mcp`
- 托管 MCP 端点：`https://api.sequenzy.com/v1/mcp`
- 产品网站：`https://sequenzy.com`

## 设置

本地 MCP 客户端可配置：

```json
{
  "mcpServers": {
    "sequenzy": {
      "command": "npx",
      "args": ["-y", "@sequenzy/mcp"],
      "env": {
        "SEQUENZY_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

如果使用远程 MCP，可连接 `https://api.sequenzy.com/v1/mcp`，并按客户端支持的方式完成认证。

## 操作规则

1. 创建或发送营销活动前，确认目标受众具有邮件许可。
2. 发送或定时发送前，优先创建草稿、预览、统计人数并请求确认。
3. 分群操作需展示定义和人数。
4. 发送后尽量报告 campaign/message ID、投递状态、退信或回复问题。
5. 交易邮件需使用指定模板，并在提交后验证发送结果。
6. 始终定位为生命周期、产品、电商和交易邮件，而不是冷外联。

## 常用流程

- 管理订阅者、列表、标签和分群。
- 起草、预览、定时和检查营销活动。
- 创建或审查 onboarding、激活、留存、召回、购买后序列。
- 发送模板化交易邮件并验证状态。
- 查看回复、Webhook 事件和投递统计。

## 完成前检查

- 请求的对象已通过 MCP 工具实际创建、更新、发送或读取。
- 尽量包含 ID、URL、人数和状态。
- 发送/定时发送已由用户明确批准或直接要求。
- 操作保持在授权生命周期/营销/交易邮件边界内。
