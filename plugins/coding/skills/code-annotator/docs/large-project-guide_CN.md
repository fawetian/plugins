# 大型项目注释指南

适用于大型代码库（1000+ 文件，10万+ 行代码）的注释指南。

## 概述

大型项目面临独特的挑战：
- **规模**：数千个文件需要系统化处理
- **复杂性**：需要理解模块依赖和架构
- **时间**：完整注释可能需要数小时
- **韧性**：必须优雅处理失败并支持恢复

## 架构

### 脚本 + 提示词混合模型

| 组件 | 职责 |
|------|------|
| `scan-files.sh` | 快速文件发现、元数据提取 |
| `manage-progress.sh` | 状态管理、进度跟踪 |
| `detect-changes.sh` | 增量变更检测 |
| AI (SKILL.md) | 注释执行、质量控制 |

### 输出文件

```
docs/annotation/
├── scan-result.json       # 文件元数据（路径、语言、代码行数、哈希）
├── scan-summary.json      # 扫描统计信息
├── progress-state.json    # 注释进度状态
├── changes.json           # 增量变更检测结果
├── checkpoint-*.json      # 进度检查点
├── ANNOTATION_PLAN.md     # 人类可读的进度报告
└── src/                   # 注释后的文件（镜像结构）
```

## 处理模式

### 1. 全量注释

从头开始注释所有源文件。

```bash
# 步骤 1: 扫描文件
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/scan-files.sh /path/to/project

# 步骤 2: 初始化进度
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh init /path/to/project

# 步骤 3: AI 执行注释（由 SKILL.md 处理）
/code-annotator /path/to/project
```

### 2. 增量注释

只处理新增或修改的文件。

```bash
# 检测变更
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/detect-changes.sh /path/to/project

# AI 仅处理变更文件
/code-annotator --incremental /path/to/project
```

### 3. 断点续传

从上次停止的地方继续注释。

```bash
# 检查当前状态
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh status /path/to/project

# 恢复注释
/code-annotator --resume /path/to/project
```

## 批量处理策略

### 自适应批次大小

批次大小根据文件复杂度动态调整：

| 复杂度 | 代码行数 | 批次大小 |
|--------|----------|----------|
| 低 | < 200 | 8 个文件 |
| 中 | 200 - 1000 | 5 个文件 |
| 高 | 1000 - 3000 | 2 个文件 |
| 超高 | > 3000 | 1 个文件（必要时拆分） |

### 按模块处理

对于超大型项目，按模块/crate 分批处理：

```bash
# 示例：仅处理 core 模块
/code-annotator --module core /path/to/project
```

模块检测来源：
- Rust：`Cargo.toml` crate 结构
- TypeScript：`package.json` workspaces 或目录结构
- Python：包目录

## 并发配置

默认配置（可通过 `.annotationrc.json` 自定义）：

```json
{
  "concurrency": {
    "maxAgents": 5,
    "batchSize": "auto",
    "rateLimitRpm": 60
  },
  "checkpoint": {
    "enabled": true,
    "interval": 50
  },
  "largeFile": {
    "splitThreshold": 5000,
    "maxChunkSize": 2000
  }
}
```

### 并发指南

- **maxAgents**：并行注释代理数量（推荐 3-5）
- **batchSize**：每批文件数（"auto" 为自适应）
- **rateLimitRpm**：每分钟最大请求数（API 限制）

## 检查点策略

### 自动检查点

进度自动保存：
- 每 N 个文件（可配置，默认 50）
- 每个模块完成后
- 任何错误或中断时

### 手动检查点

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh checkpoint /path/to/project
```

### 恢复

恢复时：
1. 加载 `progress-state.json`
2. 跳过所有 `status: "completed"` 的文件
3. 从第一个 `status: "pending"` 的文件继续

## 错误处理

### 失败分类

| 类别 | 处理方式 |
|------|----------|
| 文件读取错误 | 跳过，标记为失败，继续 |
| 解析错误 | 跳过，标记为失败，继续 |
| API 限流 | 等待，带退避重试 |
| 代理超时 | 用更小批次重试 |
| 系统错误 | 保存检查点，停止 |

### 重试策略

```
第1次失败：立即重试
第2次失败：等待 30 秒后重试
第3次失败：标记为失败，继续处理
```

## 性能优化

### 扫描优化

`scan-files.sh` 脚本：
- 使用原生 `find` 命令（最快选项）
- 在扫描时应用排除规则
- 单次遍历计算代码行数和哈希
- 输出结构化 JSON 供 AI 使用

**性能**：1381 个文件在 <1 秒内扫描完成

### 进度状态管理

`manage-progress.sh` 脚本：
- 使用 JSON 存储结构化状态
- 支持 `jq` 和 Python 回退
- 原子文件写入防止损坏
- AI 消耗最小 token

### Token 效率

| 操作 | 纯提示词 | 脚本增强 |
|------|----------|----------|
| 文件扫描 | 10-30秒，高 token | <1秒，~0 token |
| 进度检查 | 5-10秒，中等 token | <0.1秒，~0 token |
| 变更检测 | 手动，易出错 | 自动，可靠 |

## 大文件处理

### 拆分策略

超过 `splitThreshold`（默认 5000 行）的文件将被拆分：

1. **按逻辑区块**：类、函数、模块
2. **区块大小**：每个区块最多 `maxChunkSize` 行
3. **上下文保留**：每个区块包含必要的上下文

### 示例：大文件拆分

```
原始文件: huge_file.rs (8000 行)

拆分为:
├── huge_file.rs.001.rs  (第 1-2000 行，模块导入 + 第一个模块)
├── huge_file.rs.002.rs  (第 1800-3800 行，重叠上下文)
├── huge_file.rs.003.rs  (第 3600-5600 行，重叠上下文)
└── huge_file.rs.004.rs  (第 5400-8000 行，剩余代码)
```

## 监控和报告

### 实时进度

```bash
# 监视进度（每 5 秒更新）
watch -n 5 'bash scripts/manage-progress.sh status /path/to/project'
```

### 最终报告

完成后生成：
- `ANNOTATION_PLAN.md`：人类可读的摘要
- 统计信息：总数、完成数、失败数、时间
- 失败文件列表及错误原因

## 最佳实践

### 1. 从小处开始

在注释 1000+ 文件项目之前：
```bash
# 先在单个模块上测试
/code-annotator --module utils /path/to/project
```

### 2. 验证质量

抽查注释质量：
- 随机检查 5-10 个文件
- 检查三层注释结构是否完整
- 验证中文注释质量

### 3. 使用增量模式

初始注释完成后：
```bash
# 日常更新
/code-annotator --incremental /path/to/project
```

### 4. 定期检查点

对于超长会话：
```bash
# 每 100 个文件创建检查点
bash scripts/manage-progress.sh checkpoint /path/to/project
```

### 5. 处理失败

检查并重试失败文件：
```bash
# 检查状态
bash scripts/manage-progress.sh status /path/to/project

# 重置特定失败文件
bash scripts/manage-progress.sh reset /path/to/project
# 然后重试
```

## 故障排查

### "jq not found" 警告

安装 jq 以获得更好的性能：
```bash
# macOS
brew install jq

# Linux
apt-get install jq
```

脚本会自动回退到 Python。

### 扫描耗时过长

检查排除规则是否应用：
```bash
# 验证扫描结果数量
jq 'length' docs/annotation/scan-result.json
```

如果数量异常高，检查：
- 缺少排除模式
- 嵌套的 node_modules/vendor 目录
- 未排除的生成文件

### 进度状态损坏

从检查点恢复：
```bash
# 列出检查点
ls docs/annotation/checkpoint-*.json

# 恢复最新的
cp docs/annotation/checkpoint-LATEST.json docs/annotation/progress-state.json
```

### 内存问题

对于超大型项目（10K+ 文件）：
1. 按模块处理
2. 减少批次大小
3. 增加检查点频率
