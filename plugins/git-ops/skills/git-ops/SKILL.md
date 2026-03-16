---
name: git-ops
description: Git 操作快捷指令，支持 ga（add）、gc（commit）、gp（push）、gpl（pull）。当用户输入 ga、gc、gp、gpl，或说"提交代码"、"推送"、"拉取"、"暂存文件"时触发。gc 强制使用 Conventional Commits 格式，description 和 body 必须用中文填写，commit 前展示暂存内容供确认。gp 禁止直接 push 到 main/master 分支。
---

# Git 操作快捷指令

为老手提供流畅、规范的 git 操作流程。支持四个别名命令：`ga`、`gc`、`gp`、`gpl`。

---

## ga — git add

**用法：**
- `ga` — 暂存所有修改（`git add .`）
- `ga <文件1> <文件2> ...` — 只暂存指定文件

执行后显示当前 `git status`，让用户确认暂存结果。

---

## gc — git commit

**流程：**

1. 运行 `git diff --cached` 展示暂存内容，让用户看清本次 commit 包含哪些变更。
2. 根据变更内容和项目结构，**自动推断**建议的 type 和 scope，然后**一次性**向用户展示建议值并请求确认/修改以下所有字段：
   - **type**（展示建议值 + type 列表供参考）
   - **scope**（分析项目目录/模块结构自动建议，可留空）
   - **description**（必填，中文）
   - **body**（必填，中文）
3. 组装成 Conventional Commits 格式后，展示完整 commit message 让用户确认。
4. 用户确认后执行 `git commit`。

**Commit message 格式：**

```
<type>(<scope>): <中文描述>

<中文 body，可多行>
```

**type 列表：**

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

**示例：**

```
feat(auth): 添加 JWT 登录功能

实现了基于 JWT 的用户认证流程，包括 token 生成、校验和刷新逻辑。
后续需要补充 token 过期时间的配置项。
```

**注意：** 如果暂存区为空（nothing to commit），提示用户先运行 `ga`，不要继续执行 commit。

---

## gp — git push

**流程：**

1. 检查当前分支：
   - 如果是 `master` 或 `main`，**拒绝执行**，提示用户切换到功能分支后再 push。
2. 执行 `git push`。如果远程分支不存在，自动使用 `git push --set-upstream origin <branch>`。
3. 显示 push 结果。

---

## gpl — git pull

执行 `git pull --rebase`，保持线性提交历史。

如果 rebase 过程中出现冲突，提示用户解决冲突后运行 `git rebase --continue`，不要自动处理冲突。

---

## 通用原则

- 每步操作前先确认状态，执行后展示结果，让用户始终清楚当前 git 状态。
- 不跳过任何用户确认步骤，不自作主张批量操作。
- 出错时给出清晰的中文说明和下一步建议。
