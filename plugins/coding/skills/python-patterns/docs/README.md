# Python Patterns

为 Python 开发提供 Pythonic 惯用模式、PEP 8 规范、类型标注和最佳实践，涵盖错误处理、并发、数据类、装饰器和性能优化。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

该 skill 在以下场景下自动激活，无需显式命令：

- 编写新的 Python 代码
- 审查 Python 代码
- 重构现有 Python 代码
- 设计 Python 包/模块结构

在对话中提及相关操作即可触发，例如：

- `帮我写一个 Python 的数据处理函数`
- `如何用 Python 处理并发 I/O`
- `这段 Python 代码有什么问题`

## 使用示例

**场景一：类型标注与 Protocol**

编写函数时，skill 引导添加完整的类型标注，推荐 Python 3.9+ 内置泛型语法（`list[str]` 而非 `List[str]`），并在需要鸭子类型时建议使用 `Protocol` 替代抽象基类。

**场景二：并发模式选择**

需要并发处理任务时，skill 根据任务类型给出建议：I/O 密集型任务使用 `ThreadPoolExecutor` 或 `asyncio`；CPU 密集型任务使用 `ProcessPoolExecutor`；并提供完整的异步/同步代码示例。

**场景三：数据容器设计**

设计数据模型时，skill 推荐使用 `@dataclass` 自动生成 `__init__`/`__repr__`/`__eq__`，配合 `__post_init__` 添加验证逻辑；对不可变数据推荐 `NamedTuple`；频繁实例化时建议使用 `__slots__` 节省内存。

## 输出

该 skill 以内联指导方式输出，直接在对话中提供：

- 惯用 Python 代码示例（含好/坏对比）
- 推荐的项目目录结构（`src/` 布局）
- `pyproject.toml` 配置模板（black、ruff、mypy、pytest）
- 常用工具命令（`black`、`ruff`、`mypy`、`pytest --cov`、`bandit`）
- Python 常见反模式清单（可变默认参数、裸 except、`type()` 比较等）
