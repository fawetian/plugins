---
name: fireworks-tech-graph
description: "创建独立的风格化 SVG/PNG 技术插图。用户需要技术图、架构图、数据流、流程图、序列图、Agent/Memory 图、概念图、对比图、时间线、思维导图、AI/RAG/系统可视化时使用。若用户需要可编辑 draw.io/diagrams.net 文件或精确厂商形状库，优先使用 drawio-skill。"
---

# Fireworks Tech Graph

该 skill 用于生成高质量 SVG 技术图，并导出 PNG。它更适合文档、README、技术文章、方案说明和 AI/RAG/Agent 架构图，而不是可编辑 draw.io 文件。

## 使用场景

- 技术文章、文档、README、幻灯片中的 SVG/PNG 技术配图。
- 架构图、数据流图、流程图、序列图、Agent/Memory 图、概念图、对比图、时间线、思维导图。
- 用户希望使用 Flat Icon、Dark Terminal、Blueprint、Notion Clean、Glassmorphism、Claude-style、OpenAI-style 或 Dark Luxury 等视觉风格。

## 不适合

- 需要 `.drawio` 源文件、diagrams.net 可编辑交付物、官方厂商形状库或后续手动编辑时，使用 `drawio-skill`。

## 输出

先生成 SVG，校验 XML/SVG 语法，再用 `cairosvg`、`rsvg-convert` 或 Puppeteer 导出 PNG。

## 来源

基于 [yizhiyanhua-ai/fireworks-tech-graph](https://github.com/yizhiyanhua-ai/fireworks-tech-graph) 集成，许可证为 MIT。
