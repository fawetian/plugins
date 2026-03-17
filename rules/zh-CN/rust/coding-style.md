---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust 编码风格

> 本文件扩展了 [common/coding-style.md](../common/coding-style.md)，添加 Rust 特定的内容。

## 格式化

- 使用 **rustfmt** 进行代码格式化 — 提交前运行 `cargo fmt`
- 使用 **clippy** 进行静态分析 — 运行 `cargo clippy` 并处理所有警告

## 设计原则

### 所有权与借用

严格遵循 Rust 的所有权模型：

```rust
// Use references to avoid unnecessary cloning
fn process(data: &str) -> Result<String, Error> {
    // ...
}

// Use owned values when the function needs to take ownership
fn consume(data: Vec<u8>) -> Processed {
    // ...
}
```

### 错误处理

使用 `Result` 和 `Option` 进行错误处理：

```rust
use anyhow::{Context, Result};

fn read_config(path: &str) -> Result<Config> {
    let content = std::fs::read_to_string(path)
        .with_context(|| format!("Failed to read config from {}", path))?;

    let config: Config = toml::from_str(&content)
        .context("Failed to parse config file")?;

    Ok(config)
}
```

- 应用程序错误处理使用 `anyhow`
- 库错误类型使用 `thiserror`
- 优先使用 `?` 运算符而非 `match` 进行错误传播

### 不可变性

默认使用不可变 — Rust 在编译时强制执行这一点：

```rust
// Good: immutable by default
let data = fetch_data();

// Only use mut when necessary
let mut counter = 0;
```

## 命名规范

- 变量、函数和模块使用 `snake_case`
- 类型、trait 和枚举变体使用 `CamelCase`
- 常量和静态变量使用 `SCREAMING_SNAKE_CASE`
- 有意不使用的变量使用 `_prefix` 前缀

## 参考

参见 skill: `rust-patterns` 了解完整的 Rust 惯用法和模式。
