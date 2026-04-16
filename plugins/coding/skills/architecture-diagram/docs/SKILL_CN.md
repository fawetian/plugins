---
name: architecture-diagram
description: 创建专业的暗色主题架构图，输出为独立的 HTML 文件（内嵌 SVG 图形）。当用户请求系统架构图、基础设施图、云架构可视化、安全图、网络拓扑图或任何展示系统组件及其关系的技术图表时使用此 skill。
userInvocable: true
license: MIT
metadata:
  version: "1.0"
  author: Cocoon AI (hello@cocoon-ai.com)
---

# 架构图生成 Skill

创建专业的技术架构图，输出为自包含的 HTML 文件，内嵌 SVG 图形和 CSS 样式。

## 设计系统

### 调色板

为不同组件类型使用以下语义化颜色：

| 组件类型 | 填充 (rgba) | 描边 |
|---------|-------------|------|
| Frontend | `rgba(8, 51, 68, 0.4)` | `#22d3ee` (cyan-400) |
| Backend | `rgba(6, 78, 59, 0.4)` | `#34d399` (emerald-400) |
| Database | `rgba(76, 29, 149, 0.4)` | `#a78bfa` (violet-400) |
| AWS/Cloud | `rgba(120, 53, 15, 0.3)` | `#fbbf24` (amber-400) |
| Security | `rgba(136, 19, 55, 0.4)` | `#fb7185` (rose-400) |
| Message Bus | `rgba(251, 146, 60, 0.3)` | `#fb923c` (orange-400) |
| External/Generic | `rgba(30, 41, 59, 0.5)` | `#94a3b8` (slate-400) |

### 排版

所有文字使用 JetBrains Mono（等宽字体，技术美学风格）：
```html
<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
```

字号规范：12px 用于组件名称，9px 用于子标签，8px 用于注释，7px 用于极小标签。

### 视觉元素

**背景：** `#020617` (slate-950) 搭配微妙网格纹理：
```svg
<pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
  <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#1e293b" stroke-width="0.5"/>
</pattern>
```

**组件框：** 圆角矩形（`rx="6"`），1.5px 描边，半透明填充。

**安全组：** 虚线描边（`stroke-dasharray="4,4"`），透明填充，rose 颜色。

**区域边界：** 较大虚线描边（`stroke-dasharray="8,4"`），amber 颜色，`rx="12"`。

**箭头：** 使用 SVG marker 绘制箭头头部：
```svg
<marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
  <polygon points="0 0, 10 3.5, 0 7" fill="#64748b" />
</marker>
```

**箭头 z-order：** 在 SVG 中尽早绘制连接箭头（在背景网格之后），使箭头渲染在组件框的后面。SVG 元素按文档顺序绘制，先绘制的箭头会出现在后绘制的形状之下。

**半透明填充下的箭头遮罩：** 由于组件框使用半透明填充（`rgba(..., 0.4)`），箭头会透过来。要完全遮盖箭头，先绘制一个不透明背景矩形（如 `fill="#0f172a"`），再在其上绘制半透明样式矩形：
```svg
<!-- 不透明背景遮盖箭头 -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="#0f172a"/>
<!-- 上层样式组件 -->
<rect x="X" y="Y" width="W" height="H" rx="6" fill="rgba(76, 29, 149, 0.4)" stroke="#a78bfa" stroke-width="1.5"/>
```

**认证/安全流：** rose 颜色的虚线（`#fb7185`）。

**消息总线 / 事件总线：** 服务之间的小型连接器元素。使用 orange 颜色（`#fb923c` 描边，`rgba(251, 146, 60, 0.3)` 填充）：
```svg
<rect x="X" y="Y" width="120" height="20" rx="4" fill="rgba(251, 146, 60, 0.3)" stroke="#fb923c" stroke-width="1"/>
<text x="CENTER_X" y="Y+14" fill="#fb923c" font-size="7" text-anchor="middle">Kafka / RabbitMQ</text>
```

### 间距规则

**关键：** 垂直堆叠组件时，确保适当的间距以避免重叠：

- **标准组件高度：** 60px 用于服务，80-120px 用于较大组件
- **组件间最小垂直间距：** 40px
- **内嵌连接器（消息总线）：** 放置在组件之间的间隙中，不要重叠

**垂直布局示例：**
```
Component A: y=70,  height=60  → 结束于 y=130
间隙:         y=130 to y=170   → 40px 间隙，消息总线放在 y=140（高 20px）
Component B: y=170, height=60  → 结束于 y=230
```

**错误：** Component B 从 y=170 开始，消息总线放在 y=160（导致重叠）
**正确：** 消息总线放在 y=140，居中于 40px 间隙中（y=130 到 y=170）

### 图例放置

**关键：** 图例必须放在所有边界框（区域边界、集群边界、安全组）**之外**。

- 计算所有边界的结束位置（y 坐标 + 高度）
- 图例至少放在最低边界下方 20px 处
- 如有需要，扩展 SVG viewBox 高度以容纳图例

**示例：**
```
Kubernetes 集群: y=30, height=460 → 结束于 y=490
图例应从 y=510 或更低处开始
SVG viewBox 高度：至少 560 以容纳图例
```

**错误：** 图例在 y=470，位于结束于 y=490 的集群边界内部
**正确：** 图例在 y=510，位于集群边界下方，viewBox 高度已扩展

### 布局结构

1. **头部** - 标题 + 脉冲指示点，副标题
2. **主 SVG 图表** - 包含在圆角边框卡片中
3. **摘要卡片** - 图表下方 3 张信息卡片，展示关键细节
4. **页脚** - 最小化元数据行

### 组件框模式

```svg
<rect x="X" y="Y" width="W" height="H" rx="6" fill="FILL_COLOR" stroke="STROKE_COLOR" stroke-width="1.5"/>
<text x="CENTER_X" y="Y+20" fill="white" font-size="11" font-weight="600" text-anchor="middle">LABEL</text>
<text x="CENTER_X" y="Y+36" fill="#94a3b8" font-size="9" text-anchor="middle">sublabel</text>
```

### 信息卡片模式

```html
<div class="card">
  <div class="card-header">
    <div class="card-dot COLOR"></div>
    <h3>标题</h3>
  </div>
  <ul>
    <li>• 条目一</li>
    <li>• 条目二</li>
  </ul>
</div>
```

## 模板

复制并自定义 `assets/template.html` 中的模板。关键自定义点：

1. 更新 `<title>` 和头部文字
2. 如有需要修改 SVG viewBox 尺寸（默认：`1000 x 680`）
3. 添加/移除/重新定位组件框
4. 在组件之间绘制连接箭头
5. 更新三张摘要卡片
6. 更新页脚元数据

## 输出

始终生成单个自包含的 `.html` 文件：
- 内嵌 CSS（除 Google Fonts 外无外部样式表）
- 内联 SVG（无外部图片）
- 无需 JavaScript（纯 CSS 动画）

文件应可在任何现代浏览器中直接打开并正确渲染。
