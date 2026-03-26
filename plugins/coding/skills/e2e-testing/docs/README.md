# E2E Testing

基于 Playwright 的端到端测试模式库，涵盖 Page Object Model、测试配置、CI/CD 集成、测试产物管理及不稳定测试处理策略。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

该 skill 在以下场景下自动激活，无需显式命令：

- 编写 Playwright E2E 测试
- 处理测试不稳定（flaky test）问题
- 配置多浏览器测试环境
- 设置 CI/CD 中的测试流程
- 管理测试截图、视频等产物

在对话中提及相关操作即可触发，例如：

- `帮我写一个登录流程的 E2E 测试`
- `这个测试为什么不稳定`
- `如何在 GitHub Actions 中运行 Playwright`

## 使用示例

**场景一：使用 Page Object Model 组织测试**

当编写新页面的 E2E 测试时，skill 提供标准的 POM 结构模板，将页面元素定位和操作方法封装为类，使测试代码更易维护。

**场景二：诊断并修复不稳定测试**

```bash
npx playwright test tests/search.spec.ts --repeat-each=10
```

skill 会帮助分析不稳定的根本原因（竞态条件、网络时序、动画时序），并提供具体的修复方案，如用 `waitForResponse` 替代 `waitForTimeout`。

**场景三：配置 CI/CD 集成**

为 GitHub Actions 生成完整的 E2E 工作流配置，包括安装 Playwright 浏览器依赖、设置环境变量、上传测试报告产物（保留 30 天）。

## 输出

该 skill 以内联指导方式输出，直接在对话中提供：

- Playwright 测试代码（TypeScript）
- `playwright.config.ts` 配置片段
- GitHub Actions 工作流 YAML
- 测试报告模板（Markdown 格式）

测试产物（截图、视频、Trace）默认保存在项目的 `artifacts/` 目录；HTML 报告保存在 `playwright-report/`。
