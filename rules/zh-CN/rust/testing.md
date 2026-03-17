---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---
# Rust 测试

> 本文件扩展了 [common/testing.md](../common/testing.md)，添加 Rust 特定的内容。

## 测试框架

使用 **cargo test** — Rust 内置的测试框架。

## 测试组织

### 单元测试

将单元测试放在被测试代码的同一文件中，放在 `tests` 模块里：

```rust
// src/calculator.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    #[should_panic(expected = "divide by zero")]
    fn test_divide_by_zero() {
        divide(10, 0);
    }
}
```

### 集成测试

将集成测试放在项目根目录的 `tests/` 目录中：

```
project/
├── src/
│   └── lib.rs
└── tests/
    ├── integration_test.rs
    └── helpers/
        └── mod.rs
```

## 测试属性

- `#[test]` — 将函数标记为测试
- `#[ignore]` — 跳过测试，除非显式请求执行
- `#[should_panic]` — 期望测试发生 panic
- `#[tokio::test]` — 用于 tokio 异步测试

## 测试覆盖率

```bash
# Install cargo-tarpaulin for coverage
cargo install cargo-tarpaulin

# Run tests with coverage
cargo tarpaulin --out Html
```

## 参考

参见 skill: `rust-testing` 了解详细的 Rust 测试模式和辅助工具。
