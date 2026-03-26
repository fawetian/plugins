# 需求分析助手

系统化的需求分析与验证工具，帮助你深入理解用户需求、拆解复杂需求并输出结构化分析文档。

## 安装

```bash
/plugin install product@fawetian-plugins
```

## 触发方式

在对话中使用以下任意触发词即可激活该 skill：

- `analyze requirements`
- `requirement analysis`
- `validate requirements`
- `break down requirements`

例如：输入 "请对这个功能进行 requirement analysis" 即可触发。

## 使用示例

**示例 1：分析新需求**

```
请 analyze requirements：产品经理提出要做一个「一键分享」功能，用户可以把商品分享给微信好友
```

**示例 2：验证需求合理性**

```
请 validate requirements：我们计划在首页增加弹窗广告，每次用户打开 App 都展示
```

**示例 3：拆解复杂需求**

```
请 break down requirements：我们要重构整个订单系统，支持多货币、多语言、多时区
```

## 输出

生成的分析文档保存至 `docs/requirements/{feature-name}-analysis.md`，包含以下分析维度：

- 问题发现（核心问题、影响范围、当前解法）
- 干系人地图（利益相关方及其诉求）
- 需求分类（功能性 / 非功能性 / 业务性 / 用户性）
- 优先级矩阵（商业价值、用户影响、技术可行性、成本综合评分）
- 风险评估（技术、业务、时间线、资源风险）

所有内容均以中文输出，关系图和流程图使用 Mermaid 语法绘制。
