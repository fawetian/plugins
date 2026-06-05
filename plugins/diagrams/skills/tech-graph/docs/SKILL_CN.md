---
name: tech-graph
description: "创建独立的风格化 HTML 技术图。用户需要技术图、架构图、数据流、流程图、序列图、Agent/Memory 图、概念图、对比图、时间线、思维导图、AI/RAG/系统可视化，或需要可直接在浏览器打开的单文件 HTML 图表时使用。"
---

# Tech Graph

该 skill 用于生成高质量单文件 HTML 技术图。它更适合文档、README、技术文章、方案说明、浏览器可打开的单文件图表和 AI/RAG/Agent 架构图。

## 使用场景

- 技术文章、文档、README、幻灯片中的 HTML 技术配图。
- 用户明确要求 HTML 页面、单文件 HTML、浏览器可打开图表或轻量交互图。
- 架构图、数据流图、流程图、序列图、Agent/Memory 图、概念图、对比图、时间线、思维导图。
- 用户希望使用 Flat Icon、Dark Terminal、Blueprint、Notion Clean、Glassmorphism、Claude-style、OpenAI-style 或 Dark Luxury 等视觉风格。

## 输出

先生成 SVG 作为内部绘图层，校验 XML/SVG 语法，再用 `scripts/generate-html.py` 包装成单文件 HTML。生成的 HTML 工具栏可以下载普通 SVG，也可以下载高清 SVG。

HTML 示例：

```bash
python3 scripts/generate-html.py architecture ./output/arch.html '{"title":"Architecture","nodes":[],"arrows":[]}'
python3 scripts/generate-html.py --svg ./output/arch.svg ./output/arch.html --title "Architecture"
python3 scripts/generate-html.py architecture ./output/arch.html '{"title":"Architecture","nodes":[],"arrows":[]}' --download-svg-scale 3
```

## 来源

基于 [yizhiyanhua-ai/fireworks-tech-graph](https://github.com/yizhiyanhua-ai/fireworks-tech-graph) 的 MIT 许可内容改造，只保留单文件 HTML 技术图工作流。
