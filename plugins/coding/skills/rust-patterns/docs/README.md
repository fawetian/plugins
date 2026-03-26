# Rust Patterns

为 Rust 开发提供惯用模式和最佳实践，涵盖所有权与借用、错误处理、枚举状态建模、Trait 与泛型、安全并发和模块组织。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

该 skill 在以下场景下自动激活，无需显式命令：

- 编写新的 Rust 代码
- 审查 Rust 代码
- 重构现有 Rust 代码
- 设计 Crate 结构和模块布局

在对话中提及相关操作即可触发，例如：

- `帮我写一个 Rust 的错误处理`
- `如何在 Rust 中实现并发任务`
- `这段 Rust 代码为什么借用检查失败`

## 使用示例

**场景一：错误处理与传播**

编写函数时，skill 引导使用 `?` 运算符传播错误，配合 `anyhow::Context` 添加上下文信息；对库代码推荐使用 `thiserror` 定义结构化错误类型；强调生产代码中禁止使用 `.unwrap()`。

**场景二：枚举状态建模**

设计业务状态时，skill 推荐用枚举表达所有合法状态（如连接状态机），通过穷尽的 `match` 确保编译期处理所有情况，避免用布尔标志组合表示状态。

**场景三：安全并发**

需要多线程共享状态时，skill 提供 `Arc<Mutex<T>>` 模式和有界 channel（`mpsc::sync_channel`）的完整示例；异步场景推荐 Tokio 配合 `tokio::time::timeout` 处理超时；明确说明何时 `unsafe` 可接受、何时不可接受。

## 输出

该 skill 以内联指导方式输出，直接在对话中提供：

- 惯用 Rust 代码示例（含好/坏对比）
- 推荐的 Crate 目录结构（按领域组织模块）
- Rust 惯用语速查表（借用优先、枚举状态、`?` 传播、新类型模式等）
- 常用 Cargo 命令（`cargo check`、`cargo clippy`、`cargo audit`、`cargo bench`）
- 常见反模式清单（`.unwrap()`、无谓 `.clone()`、`Box<dyn Error>` 在库中等）
