# Technical Design

编写面向工程落地的技术方案、实施计划、RFC、ADR 和架构方案。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

Codex:

```bash
codex plugin add coding@fawetian-plugins-codex
```

## 触发方式

在对话中使用以下表达：

- `technical-design`
- `写一份技术方案`
- `帮我写实施方案`
- `Create an RFC for this refactor`
- `Write an ADR for this architecture decision`

## 使用示例

**场景一：新功能技术方案**

```text
technical-design 给登录态刷新机制写一份技术方案
```

输出默认写入 `docs/technical-design/{topic}.md`，包含背景、目标、当前系统现状、详细设计、测试、风险和实施任务。

**场景二：重构实施计划**

```text
帮我给支付模块拆分写一个实施方案
```

skill 会先读取现有代码和配置，识别模块边界、兼容性要求、迁移步骤、发布和回滚策略。

**场景三：架构决策 ADR**

```text
technical-design 写一个 ADR，对比队列方案和同步调用方案
```

适合记录长期存在的重要技术决策，说明备选方案、取舍和后果。

## 输出内容

默认技术方案结构：

- 背景
- 目标与非目标
- 当前系统现状
- 方案概览
- 详细设计
- 备选方案
- 迁移与发布计划
- 测试与验收
- 风险与应对
- 实施任务拆分
- 待确认问题

## 与其他 skill 的区别

- `code-research`：理解已有代码，不负责提出变更方案。
- `code-review`：审查已有改动，不负责写实施设计。
- `prd-writer`：写产品需求，不负责工程实现细节。
- `technical-design`：把需求和当前代码连接起来，形成可执行的工程方案。
