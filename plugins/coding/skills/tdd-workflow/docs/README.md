# TDD Workflow

在编写新功能、修复 Bug 或重构代码时，强制执行测试驱动开发（TDD）流程，确保达到 80% 以上的测试覆盖率，覆盖单元测试、集成测试和 E2E 测试。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

该 skill 在以下场景下自动激活，无需显式命令：

- 编写新功能或新逻辑
- 修复 Bug 或问题
- 重构现有代码
- 添加 API 端点
- 创建新组件

在对话中提及相关操作即可触发，例如：

- `帮我实现用户搜索功能`
- `这个 Bug 怎么修`
- `帮我重构这个服务层`

## 使用示例

**场景一：从零开始用 TDD 实现新功能**

skill 引导按 7 步流程推进：编写用户故事 → 生成测试用例 → 运行测试（预期失败）→ 编写最小实现代码 → 再次运行测试（预期通过）→ 重构 → 验证覆盖率达 80%+。每一步都有明确的代码模板（Jest/Vitest 单元测试、API 集成测试、Playwright E2E 测试）。

**场景二：为现有代码补充测试**

重构前，skill 帮助识别当前测试覆盖的盲区，优先补充边界条件、错误路径和空值处理的测试，确保重构不引入回归。

**场景三：Mock 外部依赖**

实现依赖 Supabase、Redis 或 OpenAI 的功能时，skill 提供标准的 `jest.mock` 模式，隔离外部服务，使单元测试可以在无网络环境下稳定运行。

## 输出

该 skill 以内联指导方式输出，直接在对话中提供：

- 单元测试代码（Jest/Vitest + Testing Library）
- API 集成测试代码（NextRequest 模式）
- E2E 测试代码（Playwright）
- 测试文件目录结构建议
- Jest 覆盖率阈值配置（`coverageThresholds` 设置为 80%）
- GitHub Actions CI/CD 集成配置（含 Codecov 上传步骤）
