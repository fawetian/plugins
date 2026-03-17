---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Rust specific content.

## Formatting

- **rustfmt** for code formatting — run `cargo fmt` before committing
- **clippy** for static analysis — run `cargo clippy` and address all warnings

## Design Principles

### Ownership and Borrowing

Follow Rust's ownership model strictly:

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

### Error Handling

Use `Result` and `Option` for error handling:

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

- Use `anyhow` for application error handling
- Use `thiserror` for library error types
- Prefer `?` operator over `match` for error propagation

### Immutability

Default to immutability — Rust enforces this at compile time:

```rust
// Good: immutable by default
let data = fetch_data();

// Only use mut when necessary
let mut counter = 0;
```

## Naming Conventions

- Use `snake_case` for variables, functions, and modules
- Use `CamelCase` for types, traits, and enum variants
- Use `SCREAMING_SNAKE_CASE` for constants and statics
- Use `_prefix` for intentionally unused variables

## Reference

See skill: `rust-patterns` for comprehensive Rust idioms and patterns.
