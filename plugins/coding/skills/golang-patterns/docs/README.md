# Golang Patterns

为 Go 开发提供惯用模式、最佳实践和编码规范，涵盖错误处理、并发、接口设计、包结构和性能优化。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

该 skill 在以下场景下自动激活，无需显式命令：

- 编写新的 Go 代码
- 审查 Go 代码
- 重构现有 Go 代码
- 设计 Go 包/模块结构

在对话中提及相关操作即可触发，例如：

- `帮我写一个 Go 的 HTTP 处理器`
- `这段 Go 错误处理写法对吗`
- `如何在 Go 中实现并发工作池`

## 使用示例

**场景一：错误处理与上下文包装**

编写函数时，skill 引导使用 `fmt.Errorf("操作描述: %w", err)` 包装错误，保留调用链上下文；提醒不应用 `_` 忽略错误返回值。

**场景二：并发模式**

需要并发处理任务时，skill 提供 Worker Pool、`errgroup` 协调多 goroutine、`context` 超时取消、优雅关闭等完整模式，并指出 goroutine 泄漏的常见原因及修复方法。

**场景三：接口与包设计**

设计模块 API 时，skill 强调"接受接口、返回结构体"的原则，推荐 Functional Options 模式处理可选配置，建议在消费者包中定义接口而非提供者包。

## 输出

该 skill 以内联指导方式输出，直接在对话中提供：

- 惯用 Go 代码示例（含好/坏对比）
- 项目标准目录结构（`cmd/`、`internal/`、`pkg/` 布局）
- 推荐的 `.golangci.yml` linter 配置
- 常用 Go 工具命令（`go test -race`、`go vet`、`golangci-lint` 等）
