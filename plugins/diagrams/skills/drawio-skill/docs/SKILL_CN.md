---
name: drawio-skill
description: "创建可编辑的 draw.io 图表并导出图片。用户明确要求 draw.io、diagrams.net、可编辑图表、.drawio XML、厂商图标、UML、ERD、网络拓扑、泳道图或 draw.io 导出的 PNG/SVG/PDF/JPG 时使用。若只需要独立的风格化 SVG/PNG 技术插图，优先使用 fireworks-tech-graph。"
---

# Draw.io 图表

该 skill 用自然语言生成 `.drawio` XML，并在本机 draw.io 桌面 CLI 可用时导出 PNG、SVG、PDF 或 JPG。

## 使用场景

- 用户明确要求 draw.io、diagrams.net、`.drawio`、可编辑图表文件。
- 图表需要后续在 draw.io 中手动微调。
- 图表需要大量官方形状库，例如 AWS、Azure、GCP、Cisco、Kubernetes、UML、BPMN、ERD 或网络图标。
- 需要 UML、ERD、序列图、架构图、网络拓扑、泳道图、机器学习模型结构图。

## 不适合

- 只需要技术文章或 README 中展示的独立 SVG/PNG 插图时，优先用 `fireworks-tech-graph`。
- 需要 Markdown 原生渲染的 diagrams-as-code 时，优先用 Mermaid 或 PlantUML。

## 依赖

导出 PNG/SVG/PDF/JPG 需要本机安装 draw.io 桌面 CLI。若 CLI 不可用或在沙箱环境中崩溃，交付 `.drawio` XML 或 diagrams.net 浏览器 URL。

## 来源

基于 [Agents365-ai/drawio-skill](https://github.com/Agents365-ai/drawio-skill) 集成，许可证为 MIT。
