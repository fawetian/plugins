# Code Translate

将项目中的英文 Markdown 文档翻译为中文，保留原始目录结构和文件，技术术语保持英文不变。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

必须明确输入 `code-translate` 触发（严格触发，不响应一般翻译请求）：

| 命令 | 说明 |
|------|------|
| `/code-translate <路径>` | 翻译指定路径下所有 `.md` 文件 |
| `/code-translate --incremental <路径>` | 仅翻译新增或修改的文件 |
| `/code-translate --resume <路径>` | 恢复中断的翻译任务 |
| `/code-translate --status <路径>` | 查看当前翻译进度 |

## 使用示例

**场景一：翻译整个项目的文档**

```
/code-translate ./my-project
```

扫描所有 `.md` 文件，自动检测并跳过已是中文的文件，对英文文件执行并发翻译，结果保存至 `docs/code-translate/` 目录，原始文件不变。

**场景二：增量翻译（仅处理新增或变更文件）**

```
/code-translate --incremental ./my-project
```

基于文件哈希检测变化，仅翻译自上次执行以来新增或修改的英文文档，节省时间。

**场景三：中断后继续翻译**

```
/code-translate --resume ./my-project
```

读取进度状态文件，跳过已完成的文件，从上次中断处继续翻译，直至全部完成。

## 输出

翻译结果保存在项目的 `docs/code-translate/` 目录下，完整镜像原始目录结构：

```
<项目根目录>/
├── docs/
│   └── code-translate/
│       ├── TRANSLATION_PLAN.md   # 翻译进度报告
│       ├── README.md             # 翻译后的文件（镜像结构）
│       └── docs/
│           └── guide.md
└── README.md                     # 原始文件（不变）
```

翻译使用简体中文，保持专业技术风格；代码块、YAML frontmatter、命令行示例、技术术语（API、SDK、框架名等）均保留英文原文。
