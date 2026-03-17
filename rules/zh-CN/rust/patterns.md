---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---
# Rust 模式

> 本文件扩展了 [common/patterns.md](../common/patterns.md)，添加 Rust 特定的内容。

## 迭代器模式

优先使用迭代器而非显式循环：

```rust
// Good: functional style with iterators
let sum: i32 = numbers.iter().filter(|&&x| x > 0).sum();

// Good: using map and collect
let doubled: Vec<i32> = numbers.iter().map(|x| x * 2).collect();
```

## 错误处理模式

### `?` 运算符

优雅地传播错误：

```rust
fn read_and_parse(path: &str) -> Result<Data, Error> {
    let content = fs::read_to_string(path)?;
    let data = serde_json::from_str(&content)?;
    Ok(data)
}
```

### 自定义错误类型

库错误使用 `thiserror`：

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

## Trait 设计

保持 trait 专注且可组合：

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

## 类型状态模式

使用类型系统强制状态转换：

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

## 智能指针模式

- `Box<T>` — 堆分配，已知大小
- `Rc<T>` / `Arc<T>` — 共享所有权（单线程 / 多线程）
- `RefCell<T>` / `Mutex<T>` — 内部可变性（单线程 / 多线程）

## 参考

参见 skill: `rust-patterns` 了解完整的 Rust 惯用法和模式。
