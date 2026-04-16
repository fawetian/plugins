# Git 工作流程

## 提交信息格式

```
<type>(<scope>): <描述>

<可选 body>
```

- **scope** 可选，根据项目目录/模块结构自动推断
- 通过 ~/.claude/settings.json 全局禁用了归因

### Type 列表

| type | 用途 |
|------|------|
| feat | 新功能 |
| fix | Bug 修复 |
| docs | 文档修改 |
| style | 代码格式（不影响逻辑） |
| refactor | 重构（非新功能也非修复） |
| perf | 性能优化 |
| test | 测试相关 |
| chore | 构建/工具/依赖等杂项 |
| ci | CI/CD 配置修改 |
| revert | 回滚 |

## 提交行为

默认提交当前 session 的所有变更，除非用户特殊指定。

## 分支保护

- 禁止直接推送到 `main` 或 `master`，需先切换到功能分支。
- 新分支使用 `git push -u origin <branch>` 推送。

## 拉取策略

使用 `git pull --rebase` 保持线性提交历史。
如果 rebase 过程中出现冲突，手动解决后运行 `git rebase --continue`。

## 拉取请求工作流程

创建 PR 时：
1. 分析完整的提交历史（不仅仅是最近一次提交）
2. 使用 `git diff [base-branch]...HEAD` 查看所有更改
3. 起草全面的 PR 摘要
4. 包含带有 TODO 的测试计划
5. 如果是新分支，使用 `-u` 标志推送

> 有关 git 操作之前的完整开发流程（规划、TDD、代码审查），
> 请参阅 [development-workflow.md](development-workflow.md)。
