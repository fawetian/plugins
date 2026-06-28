---
name: design-md-selector
description: "从 VoltAgent/awesome-design-md 选择并应用匹配的 DESIGN.md。当用户要求为当前项目选择、查找、比较或应用视觉风格、设计语言、DESIGN.md、品牌启发式 UI 风格、落地页风格、应用界面风格或网站美学时使用，尤其适用于开始前端实现之前。不要用于 PRD、产品需求、社媒卡片生成、未要求选择风格的普通 UI 实现或品牌资产创建。"
---

# DESIGN.md Selector

## 概览

从 `VoltAgent/awesome-design-md` 中选择最贴近当前需求的三个上游 `DESIGN.md`，询问用户要应用哪一个，然后把确认后的上游文件复制到当前项目的 `DESIGN.md`。

不要总结或重写被选中的文件。这个 skill 只负责选择、确认和原样应用。

## 来源

- 仓库：`https://github.com/VoltAgent/awesome-design-md`
- 目录：`design-md/<slug>/DESIGN.md`
- Raw URL：`https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<slug>/DESIGN.md`

优先使用 GitHub 实时数据。不要维护或依赖内置 slug 列表。

## 工作流

1. 用 `git rev-parse --show-toplevel` 判断当前项目根目录；如果不在 Git 仓库中，退回到 `pwd`。
2. 读取用户的 UI 需求：产品类型、受众、页面类型、信息密度、气质和明确的风格提示。
3. 获取实时目录：
   - 优先使用 `gh api repos/VoltAgent/awesome-design-md/contents/design-md --jq '.[].name'`。
   - 如果没有 `gh`，使用 GitHub contents API 和 `curl`。
   - 只有直接访问不足时，才临时 clone 到临时目录。
4. 选择正好三个候选 slug。使用 README 分类说明，并在需要时读取候选 `DESIGN.md` 的开头来验证匹配度。
5. 回复三个选项，每个选项只给简短理由。需要时写出一个注意点。
6. 让用户用序号或 slug 选择。说明 `yes` 会应用第一个。如果 `<project-root>/DESIGN.md` 已存在，明确说明应用会替换它。
7. 停止。用户确认前不要写文件。

## 确认后应用

用户确认后：

1. 从前三个候选中解析被选中的 slug。如果用户只回复 `yes`，使用第一名。
2. 拉取上游 raw `DESIGN.md`。
3. 把拉取到的内容原样写入 `<project-root>/DESIGN.md`。
4. 报告所选 slug、来源 URL 和目标路径。

如果拉取失败，不要创建半截 `DESIGN.md`；报告错误并询问是否重试。

## 选择启发

- 开发者工具、AI 平台、SaaS dashboard：优先考虑 `linear.app`、`vercel`、`raycast`、`supabase`、`cursor`、`voltagent` 或 `stripe`。
- 编辑、知识、文档或 workspace 产品：优先考虑 `notion`、`mintlify`、`wired`、`theverge` 或 `apple`。
- 消费、电商、媒体或强品牌界面：优先考虑 `airbnb`、`nike`、`spotify`、`shopify`、`figma` 或 `pinterest`。
- 金融或信任感强的产品：优先考虑 `stripe`、`wise`、`coinbase`、`mastercard` 或 `revolut`。
- 如果用户需求接近品牌复刻，选择“受其启发”的视觉匹配，不复制 logo、商标或专有资产。

## 回复格式

使用紧凑格式：

```text
Top 3:
1. <slug> — <为什么匹配>
2. <slug> — <为什么匹配>
3. <slug> — <为什么匹配>

回复 1/2/3 或 slug，我会应用到 <project-root>/DESIGN.md。回复 no 跳过。
```
