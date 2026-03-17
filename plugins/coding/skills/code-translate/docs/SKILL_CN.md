---
name: code-translate
description: 当用户明确输入 "code-translate" 时触发。绝不因一般翻译请求、国际化讨论或文档问题而触发。将英文 Markdown 文档翻译为中文，保留目录结构，技术术语保持英文。
userInvocable: true
---

# Code Translate 代码翻译

将英文 Markdown 文档翻译为中文。翻译后的文件保存到 `docs/code-translate/` 目录，保留原始文件和目录结构。

## 命令

| 命令 | 说明 |
|------|------|
| `/code-translate <path>` | 完整翻译所有 .md 文件 |
| `/code-translate --incremental <path>` | 仅翻译新增/变更文件 |
| `/code-translate --resume <path>` | 恢复中断的翻译 |
| `/code-translate --status <path>` | 显示当前进度 |

## 工作流程

### Phase 1: 文件扫描（脚本）

关键：使用扫描脚本提高效率，特别是对于大型项目。

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/scan-md.sh <project_path>
```

生成的文件：
- `docs/code-translate/scan-result.json` - 文件元数据（路径、相对路径、哈希值、字数）
- `docs/code-translate/scan-summary.json` - 扫描统计信息

**为什么使用脚本？**
- 快速扫描所有 .md 文件，耗时 <1 秒
- 最小的 token 消耗
- 一致的排除规则
- 保留目录结构信息

### Phase 1.5: 自动语言检测和过滤

关键：使用脚本自动检测和过滤已翻译的文件。

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/filter-files.sh <project_path>
```

这将：
1. 分析所有扫描的文件的语言标识
2. 自动标记已翻译文件（zh-CN、ja-JP 等）为已完成
3. 生成 english-files.json 用于实际翻译工作
4. 报告统计信息：
   - 总文件数：XXX
   - 自动跳过（已翻译）：XXX
   - 待翻译英文文件：XXX

**此过滤必须在 Phase 2 之前自动完成** - 用户不应需要手动识别要跳过的文件。

### Phase 2: 进度初始化（脚本）

根据用户请求选择模式：

#### 全量翻译
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh init <project_path>
```

#### 增量翻译
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh init-incremental <project_path>
```

生成的文件：
- `docs/code-translate/progress-state.json` - 翻译进度状态

### Phase 3: 翻译计划

关键：复制 plan 模板以跟踪进度：

```bash
cp ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/templates/TRANSLATION_PLAN.md <project_path>/docs/code-translate/TRANSLATION_PLAN.md
```

然后使用项目特定信息更新模板：
- 项目路径
- 开始时间
- 扫描摘要中的总文件数/总字数
- 基于项目大小的处理策略

Plan 模板包含：
- **统计部分**：跟踪完成数量和百分比
- **当前批次部分**：跟踪正在翻译的文件
- **进度日志部分**：记录带时间戳的已完成批次
- **失败文件部分**：跟踪和重试失败的翻译
- **下一步操作部分**：规划即将进行的工作

在 plan 中使用的状态标记：
- ⏳ Pending（待处理）
- 🔄 In Progress（进行中）
- ✅ Completed（已完成）
- ❌ Failed（失败）

### Phase 4: 并发翻译

关键：持续执行直到所有文件都翻译完成。在遇到不可恢复的错误之前不要停止。

```
- 不要在每个文件后询问用户确认
- 不要在批次之间暂停
- 只在遇到不可恢复错误时停止
- 通过更新 TRANSLATION_PLAN.md 报告进度
- 使用脚本跟踪进度
- 验证每个翻译后的文件存在且包含中文内容
```

#### 翻译验证清单

对于每个翻译的文件，验证：
- [ ] 文件存在于输出目录
- [ ] 文件有中文内容（不是英文）
- [ ] 文件大小合理（>原文件的50%）
- [ ] 技术术语保持英文
- [ ] YAML frontmatter 保留（如有）
- [ ] 代码块未更改

#### 自动并发控制

使用批量翻译脚本进行自动并发管理：

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/batch-translate.sh <project_path> [--max-agents=N]
```

技能根据项目大小自动确定并发度：

**小型项目（< 50 个文件）：**
- 顺序翻译，一次 1 个文件
- 批次大小：5-10 个文件

**中型项目（50-200 个文件）：**
- 3 个并发代理并行翻译
- 批次大小：每个代理 15 个文件

**大型项目（200+ 个文件）：**
- 5 个并发代理并行翻译
- 批次大小：每个代理 20 个文件
- 一个代理完成后立即生成新代理

**自动扩展公式：**
```
concurrent_agents = min(5, max(1, pending_files // 50))
batch_size_per_agent = min(20, max(5, pending_files // concurrent_agents))
```

#### 批量处理和并发代理

**主控制器（父进程）：**

1. 获取待处理文件：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh next <project_path> <batch_size>
```

2. 计算并发度：
   - 计算待处理文件数
   - 设置 concurrent_agents = min(5, max(1, pending_files // 50))
   - 将待处理文件分割为每个代理的批次

3. 为每个并发代理生成翻译任务：
   ```
   任务：翻译文件批次
   - 输入：文件路径数组
   - 操作：翻译每个文件，保存到输出目录，标记完成
   - 输出：每个文件的成功/失败状态
   ```

4. 等待所有代理完成

5. 检查状态并重复，直到 `待处理：0`

**翻译代理（子进程）：**

对于分配的批次中的每个文件：
1. 读取原始文件
2. 按照所有规则翻译
3. 保存到 `docs/code-translate/<镜像路径>`
4. 验证文件存在且包含中文内容
5. 标记为已完成：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh complete <project_path> "<file_path>"
```

6. 失败时标记为失败：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh fail <project_path> "<file_path>" "<错误>"
```

7. 返回批次完成报告

#### 必需完成标准

翻译完成必须满足：
1. `translate-progress.sh status` 显示：`待处理：0`
2. scan-result.json 中的所有文件都有对应的翻译文件
3. 所有翻译文件通过验证（中文内容、正确格式）
4. TRANSLATION_PLAN.md 显示 100% 完成

**关键：必须满足所有 4 个标准才能停止。**

#### 大文件处理

对于 >5000 字的文件：
1. 按章节（标题）拆分
2. 分别翻译每个章节
3. 合并翻译，保持一致性

### Phase 5: 目录结构保留

关键：保持精确的目录结构，包括空目录

1. 所有文件翻译完成后，同步目录结构：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh sync-dirs <project_path>
```

2. 这确保：
   - 源目录中的所有目录在输出中存在
   - 空目录被保留
   - 目录时间戳被保持

### Phase 6: 断点和恢复

#### 自动断点
- 每 50 个文件（可配置）
- 每批完成后
- 任何中断时

#### 手动断点
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh checkpoint <project_path>
```

#### 从断点恢复
```bash
# 检查当前状态
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh status <project_path>

# 继续翻译 - 自动跳过已完成文件
/code-translate --resume <project_path>
```

### Phase 7: 完成

1. 生成最终统计：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh status <project_path>
```

2. 更新 TRANSLATION_PLAN.md 最终状态

3. 输出完成摘要：
   - 总文件数
   - 成功翻译数
   - 失败数（如有）及原因
   - 总翻译字数
   - 时间统计
   - 输出位置

## 输出结构

```
<project>/
├── docs/
│   └── code-translate/
│       ├── scan-result.json       # 文件元数据
│       ├── scan-summary.json      # 扫描统计
│       ├── progress-state.json    # 进度状态
│       ├── TRANSLATION_PLAN.md    # 进度报告
│       ├── README.md              # 翻译后的文件（镜像结构）
│       ├── CONTRIBUTING.md
│       └── docs/                  # 保留的目录结构
│           ├── guide.md
│           └── api/
│               └── reference.md
├── README.md                      # 原始文件（未修改）
├── CONTRIBUTING.md
└── docs/
    ├── guide.md
    └── api/
        └── reference.md
```

## 翻译规则

### YAML Frontmatter

保留 YAML frontmatter 原样，不翻译：
```yaml
---
title: 保持原样
description: 保持原样
---
```

### 标题和章节标题

翻译为中文：
- `# Getting Started` → `# 开始使用`
- `## Installation` → `## 安装`

### 技术术语（保持英文）

**产品名称：**
- Claude, Claude Code, Claude API
- GitHub, GitLab, Bitbucket
- VS Code, IntelliJ, Vim

**技术缩写：**
- API, SDK, CLI, GUI, UI, UX
- HTTP, HTTPS, TCP, IP, URL, URI
- JSON, XML, YAML, CSV
- SQL, NoSQL, DB, Database
- AI, ML, LLM, NLP
- CPU, GPU, RAM, SSD
- OS, VM, Container, Docker, Kubernetes, K8s

**编程术语：**
- Function, Method, Class, Interface, Module, Package, Library
- Variable, Constant, Parameter, Argument, Return value
- Array, List, Map, Dictionary, Object, String, Boolean
- Synchronous, Asynchronous, Concurrent, Parallel
- Compile, Build, Deploy, Runtime, Debug
- Frontend, Backend, Full-stack, Server-side, Client-side
- REST, GraphQL, gRPC, WebSocket, WebHook
- OAuth, JWT, Authentication, Authorization

**框架/工具名称：**
- React, Vue, Angular, Svelte
- Node.js, Deno, Bun
- Express, NestJS, Fastify
- Django, Flask, FastAPI, Spring
- PostgreSQL, MySQL, MongoDB, Redis, Elasticsearch
- AWS, GCP, Azure, Vercel, Netlify
- npm, yarn, pnpm, pip, cargo, maven
- Git, SVN, Mercurial

**保持英文格式：**
- 代码标识符（变量名、函数名、类名）
- 文件路径和目录名
- 命令行示例
- 版本号（v1.0.0, 2.x 等）
- 布尔值（true, false, null, undefined, nil）

### 代码块

保持代码块不变，不翻译：
````markdown
```python
def hello_world():
    print("保持代码原样")
```
````

### 行内代码

保持行内代码不变：
- Use `git push` to push changes → 使用 `git push` 来推送更改

### 链接

翻译链接文本，URL 保持不变：
- [Read more](https://example.com) → [阅读更多](https://example.com)
- [Getting Started Guide](./guide.md) → [入门指南](./guide.md)

### 列表

翻译列表内容，保持格式：
- 无序列表
- 有序列表
- 任务列表（`- [ ]` 和 `- [x]`）

### 表格

翻译表格内容，保持结构：
- 表头单元格
- 表体单元格
- 保持对齐标记（`:---`, `:---:`, `---:`）

### 强调

保留强调标记：
- **bold** → **粗体**
- *italic* → *斜体*
- ~~strikethrough~~ → ~~删除线~~

### 引用块

翻译引用内容：
> This is important → > 这很重要

### 图片

保持图片语法不变：
- `![Alt text](image.png)` - 翻译 alt 文本
- `![](image.png)` - 保持原样

### HTML 元素

保留 Markdown 中的 HTML：
- `<details>`, `<summary>` - 翻译内容，保留标签
- `<kbd>`, `<sub>`, `<sup>` - 翻译内容，保留标签

## 错误处理

- 当单个文件翻译失败时，记录错误原因并继续处理其他文件
- 使用脚本标记失败文件：
  ```bash
  bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh fail <project_path> "<file_path>" "错误原因"
  ```
- 在最终报告中总结所有错误
- 提供重试失败文件的选项

## 语言风格

- 使用简体中文
- 专业和技术性语调
- 全文术语一致
- 自然的中文表达（不是逐字翻译）
- 使用中文标点符号（，。：；""''【】）

## 大型项目指南

对于 100+ Markdown 文件的项目：

1. **批量处理**：根据文件大小使用自适应批次大小
2. **并发代理**：生成 3-5 个翻译代理
3. **断点策略**：每 50 个文件自动保存
4. **进度监控**：每批处理后更新 TRANSLATION_PLAN.md

## 附加资源

### 脚本

- **`scripts/scan-md.sh`** - 快速 Markdown 文件扫描及元数据提取和语言检测
- **`scripts/detect-lang.sh`** - Markdown 文件语言检测（english|translated|unknown）
- **`scripts/filter-files.sh`** - 过滤扫描文件，自动标记已翻译文件为已完成
- **`scripts/batch-translate.sh`** - 自动批量翻译和并发控制
- **`scripts/translate-progress.sh`** - 进度状态管理和目录同步
