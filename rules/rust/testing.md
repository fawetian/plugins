---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---
# Rust Testing

> This file extends [common/testing.md](../common/testing.md) with Rust specific content.

## Framework

Use **cargo test** — Rust's built-in testing framework.

## Test Organization

### Unit Tests

Place unit tests in the same file as the code being tested, in a `tests` module:

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

### Integration Tests

Place integration tests in the `tests/` directory at the project root:

```
project/
├── src/
│   └── lib.rs
└── tests/
    ├── integration_test.rs
    └── helpers/
        └── mod.rs
```

## Test Attributes

- `#[test]` — marks a function as a test
- `#[ignore]` — skips the test unless explicitly requested
- `#[should_panic]` — expects the test to panic
- `#[tokio::test]` — for async tests with tokio

## Coverage

```bash
# Install cargo-tarpaulin for coverage
cargo install cargo-tarpaulin

# Run tests with coverage
cargo tarpaulin --out Html
```

## Reference

See skill: `rust-testing` for detailed Rust testing patterns and helpers.
