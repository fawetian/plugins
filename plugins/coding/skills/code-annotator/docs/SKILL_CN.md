---
name: code-annotator
description: 当用户调用 "code-annotator" 或 "/code-annotator" 时使用此 skill。自动为源代码文件添加全面的中文注释。
---

# Code Annotator 代码注释器

为项目源代码文件添加中文注释。注释后的文件保存到 `docs/annotation/` 目录，保留原始文件。

## 工作流程

### Phase 1: 文件扫描

扫描项目中所有源代码文件。排除规则见 `references/exclusion-rules.md`。

生成 `docs/annotation/FILES.md`：列出所有需要注释的源代码文件路径。

### Phase 2: 注释计划

基于 FILES.md，创建 `docs/annotation/ANNOTATION_PLAN.md`：

```markdown
# Annotation Progress

## Statistics
- Total files: X
- Completed: 0
- In progress: 0
- Pending: X

## File List

| Status | File Path | Notes |
|--------|-----------|-------|
| Pending | src/index.ts | |
| Pending | src/utils/helper.ts | |
...
```

状态标记:
- Pending（待处理）
- In progress（进行中）
- Completed（已完成）
- Failed (with reason)（失败及原因）

### Phase 3: 并发注释

关键：持续执行直到完成

```
- 不要在每个文件后询问用户确认
- 不要在批次之间暂停
- 只在遇到不可恢复错误时停止
- 通过更新 ANNOTATION_PLAN.md 报告进度
```

输出位置：
- 注释后的文件保存到 `docs/annotation/src/...`（镜像原始结构）
- 原始源文件不被修改

执行步骤：
1. 使用 TodoWrite 创建注释任务
2. 使用 Task 工具并发生成多个注释代理（每批 3-5 个文件）
3. 每个代理注释一个文件并保存到 `docs/annotation/`
4. 每个文件完成后，立即更新 ANNOTATION_PLAN.md 中的状态
5. 自动继续下一批，直到所有文件完成

### Phase 4: 完成

1. 更新 ANNOTATION_PLAN.md，标记所有任务完成
2. 输出完成摘要：
   - 总文件数
   - 成功注释数
   - 失败数（如有）
   - 时间统计

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

## 示例

**输入：**
```
/code-annotator /path/to/my-project
```

**输出结构：**
```
my-project/
├── docs/
│   └── annotation/
│       ├── FILES.md               # 源代码列表
│       ├── ANNOTATION_PLAN.md     # 进度跟踪
│       └── src/                   # 注释后的文件（镜像结构）
│           ├── index.ts           # (已注释)
│           └── utils/
│               └── helper.ts      # (已注释)
├── src/                           # 原始文件（未修改）
│   ├── index.ts
│   └── utils/
│       └── helper.ts
└── ...
```

## 错误处理

- 当单个文件注释失败时，记录错误原因并继续处理其他文件
- 在 ANNOTATION_PLAN.md 中标记失败的文件和原因
- 在最终报告中总结所有错误

## 附加资源

### 参考文件

- **`references/annotation-standards.md`** - 详细的注释标准、粒度指南和示例
- **`references/exclusion-rules.md`** - 扫描期间的文件排除规则
