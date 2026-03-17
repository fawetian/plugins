---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---
# Rust Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Rust specific content.

## Iterator Pattern

Prefer iterators over explicit loops:

```rust
// Good: functional style with iterators
let sum: i32 = numbers.iter().filter(|&&x| x > 0).sum();

// Good: using map and collect
let doubled: Vec<i32> = numbers.iter().map(|x| x * 2).collect();
```

## Error Handling Patterns

### The `?` Operator

Propagate errors cleanly:

```rust
fn read_and_parse(path: &str) -> Result<Data, Error> {
    let content = fs::read_to_string(path)?;
    let data = serde_json::from_str(&content)?;
    Ok(data)
}
```

### Custom Error Types

Use `thiserror` for library errors:

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ConfigError {
    #[error("Missing field: {0}")]
    MissingField(String),

    #[error("Invalid value for {field}: {value}")]
    InvalidValue { field: String, value: String },

    #[error(transparent)]
    Io(#[from] std::io::Error),
}
```

## Trait Design

Keep traits focused and composable:

```rust
// Good: small, focused traits
pub trait Readable {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize>;
}

pub trait Writable {
    fn write(&mut self, buf: &[u8]) -> Result<usize>;
}

// Good: compose traits
trait ReadWrite: Readable + Writable {}
```

## Type State Pattern

Use the type system to enforce state transitions:

```rust
struct Uninitialized;
struct Connected;
struct Disconnected;

struct Client<State> {
    state: PhantomData<State>,
}

impl Client<Uninitialized> {
    fn connect(self) -> Client<Connected> {
        // ...
    }
}

impl Client<Connected> {
    fn disconnect(self) -> Client<Disconnected> {
        // ...
    }
}
```

## Smart Pointer Patterns

- `Box<T>` — heap allocation, known size
- `Rc<T>` / `Arc<T>` — shared ownership (single / multi-threaded)
- `RefCell<T>` / `Mutex<T>` — interior mutability (single / multi-threaded)

## Reference

See skill: `rust-patterns` for comprehensive Rust idioms and patterns.
