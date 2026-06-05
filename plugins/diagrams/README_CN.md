# Diagrams Plugin

图表生成工具集，包含可编辑 draw.io 文件和风格化 SVG/PNG 技术图。

## Skills

- `drawio-skill`：生成可编辑 `.drawio` XML，并在 draw.io 桌面 CLI 可用时导出图片。适合需要后续手动编辑、精确厂商形状库、UML、ERD、网络拓扑、泳道图或 draw.io 原生交付物的场景。
- `fireworks-tech-graph`：生成独立的风格化 SVG 技术图并导出 PNG。适合文档、技术文章、AI/RAG/Agent 架构图、流程图、对比图、时间线和多风格技术说明图。

## 安装

```bash
/plugin install diagrams@fawetian-plugins
```

Codex:

```bash
codex plugin add diagrams@fawetian-plugins-codex
```

## 来源

- `drawio-skill` 基于 [Agents365-ai/drawio-skill](https://github.com/Agents365-ai/drawio-skill) 集成，许可证为 MIT。
- `fireworks-tech-graph` 基于 [yizhiyanhua-ai/fireworks-tech-graph](https://github.com/yizhiyanhua-ai/fireworks-tech-graph) 集成，许可证为 MIT。
