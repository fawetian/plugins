---
name: code-annotator
description: Automatically adds comprehensive Chinese comments to source code files. Supports large projects with incremental updates and resume capability. This skill should be used when the user invokes "code-annotator" or "/code-annotator"
userInvocable: true
---

# Code Annotator 代码注释器

为项目源代码文件添加中文注释。注释后的文件保存到 `docs/annotation/` 目录，保留原始文件。

## 命令

| 命令 | 说明 |
|------|------|
| `/code-annotator <path>` | 完整注释所有源文件 |
| `/code-annotator --incremental <path>` | 仅处理新增/修改的文件 |
| `/code-annotator --resume <path>` | 恢复中断的注释任务 |
| `/code-annotator --module <name> <path>` | 仅注释指定模块 |
| `/code-annotator --status <path>` | 查看当前进度 |

## 工作流程

### Phase 1: 文件扫描（脚本）

关键：使用扫描脚本提高效率，特别是对于大型项目。

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/scan-files.sh <project_path>
```

生成的文件：
- `docs/annotation/scan-result.json` - 文件元数据（路径、语言、代码行数、复杂度、哈希）
- `docs/annotation/scan-summary.json` - 扫描统计信息

**为什么使用脚本？**
- 1381 个文件扫描 <1 秒（AI 使用 Glob 需要 10-30 秒）
- 最小的 token 消耗
- 一致的排除规则

排除规则见 `references/exclusion-rules.md`。

### Phase 2: 进度初始化（脚本）

根据用户请求选择模式：

#### 全量注释
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh init <project_path>
```

#### 增量注释
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/detect-changes.sh <project_path>
```

生成的文件：
- `docs/annotation/progress-state.json` - 注释进度状态
- `docs/annotation/changes.json` - 变更检测结果（增量模式）

### Phase 3: 注释计划

基于 `progress-state.json`，创建 `docs/annotation/ANNOTATION_PLAN.md`：

```markdown
# Annotation Progress

## Statistics
- Total files: X
- Completed: 0
- In progress: 0
- Pending: X
- Failed: 0

## Processing Strategy

[大型项目：描述按模块处理的方法]

## File List

| Status | File Path | Complexity | Notes |
|--------|-----------|------------|-------|
| Pending | src/index.ts | low | |
| Pending | src/core/engine.ts | high | |
...
```

状态标记：
- Pending（待处理）
- In progress（进行中）
- Completed（已完成）
- Failed (with reason)（失败及原因）

复杂度级别：`low`、`medium`、`high`、`very_high`

### Phase 4: 并发注释

关键：持续执行直到完成

```
- 不要在每个文件后询问用户确认
- 不要在批次之间暂停
- 只在遇到不可恢复错误时停止
- 通过更新 ANNOTATION_PLAN.md 报告进度
- 使用脚本跟踪进度
```

#### 批量处理

1. 获取下一批文件：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh next <project_path> <batch_size>
```

2. 根据复杂度自适应批次大小：
   - 低复杂度（<200 SLOC）：5-8 个文件/批
   - 中等复杂度（200-1000 SLOC）：3-5 个文件/批
   - 高复杂度（1000-3000 SLOC）：1-2 个文件/批
   - 超高复杂度（>3000 SLOC）：拆分文件处理

3. 对于批次中的每个文件：
   ```bash
   # 标记为进行中
   bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh start <project_path> "<file_path>"
   ```

4. 使用 Task 工具生成注释代理（3-5 个并发代理）

5. 每个代理：
   - 读取原始文件
   - 按照注释标准添加中文注释
   - 保存注释后的文件到 `docs/annotation/<镜像路径>`
   - 不修改原始文件

6. 完成后：
   ```bash
   # 标记为已完成
   bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh complete <project_path> "<file_path>"

   # 如果失败
   bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh fail <project_path> "<file_path>" "错误原因"
   ```

7. 更新 ANNOTATION_PLAN.md 进度

8. 自动继续下一批

#### 大文件处理

对于 >5000 SLOC 的文件：
1. 按逻辑块拆分（模块/函数边界）
2. 分别处理每个块
3. 合并注释，保持一致性

### Phase 5: 断点和恢复

#### 自动断点
- 每 50 个文件（可配置）
- 每个模块完成后
- 任何中断时

#### 手动断点
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh checkpoint <project_path>
```

#### 从断点恢复
```bash
# 检查当前状态
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh status <project_path>

# 继续注释 - 自动跳过已完成文件
/code-annotator --resume <project_path>
```

### Phase 6: 完成

1. 生成最终统计：
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh status <project_path>
```

2. 更新 ANNOTATION_PLAN.md 最终状态

3. 输出完成摘要：
   - 总文件数
   - 成功注释数
   - 失败数（如有）及原因
   - 时间统计
   - 输出位置

## 输出结构

```
<project>/
├── docs/
│   └── annotation/
│       ├── scan-result.json       # 文件元数据
│       ├── scan-summary.json      # 扫描统计
│       ├── progress-state.json    # 进度状态
│       ├── changes.json           # 变更检测（增量）
│       ├── ANNOTATION_PLAN.md     # 进度报告
│       └── src/                   # 注释后的文件（镜像结构）
│           ├── index.ts
│           └── utils/
│               └── helper.ts
├── src/                           # 原始文件（未修改）
│   ├── index.ts
│   └── utils/
│       └── helper.ts
└── ...
```

## 注释标准

详细的注释标准和示例见 `references/annotation-standards.md`。

### 三层结构

1. **文件头** - 解释文件用途
2. **类/函数** - 每个类和函数的文档字符串
3. **内部逻辑** - 复杂业务逻辑、算法或难以理解的代码段的注释

### 关键原则

- 解释**为什么**，而不是什么 - 代码展示做什么，注释解释为什么
- 保持简洁 - 避免冗长的注释，但不要省略关键信息
- 保持同步 - 注释必须准确反映代码行为
- 标记重要信息 - 边界条件、特殊处理、已知问题

### 语言

所有注释使用**中文**。

添加注释时，也检测并将现有的英文注释转换为中文：
- 保持原始位置和格式
- 技术术语可以保留英文（API, HTTP, JSON 等）
- 保持代码示例中的变量名和函数名不变
- 保持 TODO, FIXME, NOTE, HACK, XXX 标记为英文，翻译描述
- 保持版权和许可信息不变

## 错误处理

- 当单个文件注释失败时，记录错误原因并继续处理其他文件
- 使用脚本标记失败文件：
  ```bash
  bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh fail <project_path> "<file_path>" "错误原因"
  ```
- 在最终报告中总结所有错误
- 提供重试失败文件的选项

## 大型项目指南

对于 1000+ 文件的项目，见 `references/large-project-guide.md`，包括：
- 基于模块的处理
- 并发配置
- 断点策略
- 性能优化

## 附加资源

### 参考文件

- **`references/annotation-standards.md`** - 详细的注释标准、粒度指南和示例
- **`references/exclusion-rules.md`** - 扫描期间的文件排除规则
- **`references/large-project-guide.md`** - 大型代码库注释指南

### 脚本

- **`scripts/scan-files.sh`** - 快速文件扫描及元数据提取
- **`scripts/manage-progress.sh`** - 进度状态管理
- **`scripts/detect-changes.sh`** - 增量变更检测
