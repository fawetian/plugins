# Code Annotator

为项目源代码文件自动添加全面的中文注释，支持大型项目的增量更新和断点续传。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

在对话中直接输入以下命令触发：

| 命令 | 说明 |
|------|------|
| `/code-annotator <路径>` | 对指定路径的所有源文件进行完整注释 |
| `/code-annotator --incremental <路径>` | 仅处理新增或修改的文件 |
| `/code-annotator --resume <路径>` | 恢复中断的注释任务 |
| `/code-annotator --module <模块名> <路径>` | 仅注释指定模块 |
| `/code-annotator --status <路径>` | 查看当前注释进度 |

## 使用示例

**场景一：为整个项目添加中文注释**

```
/code-annotator ./my-project
```

扫描项目所有源文件，按复杂度分批并发处理，将带注释的文件保存至 `docs/annotation/` 目录，原始文件不变。

**场景二：增量注释（仅处理变更文件）**

```
/code-annotator --incremental ./my-project
```

检测自上次注释以来发生变化的文件，仅对这些文件执行注释，适合在持续开发中定期更新注释。

**场景三：中断后继续执行**

```
/code-annotator --resume ./my-project
```

自动读取进度状态文件，跳过已完成的文件，从断点处继续，无需重新开始。

## 输出

注释结果保存在项目的 `docs/annotation/` 目录下，完整镜像原始目录结构：

```
<项目根目录>/
├── docs/
│   └── annotation/
│       ├── ANNOTATION_PLAN.md   # 注释进度报告
│       ├── scan-result.json     # 文件扫描元数据
│       └── src/                 # 带注释的文件（镜像结构）
│           └── index.ts
└── src/                         # 原始文件（不变）
    └── index.ts
```

所有注释均为中文，采用文件头说明、类/函数文档字符串、关键逻辑行内注释三层结构。
