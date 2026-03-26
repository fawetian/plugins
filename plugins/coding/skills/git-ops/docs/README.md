# Git Ops

Git 常用操作的快捷命令，支持 `ga`（暂存）、`gc`（提交）、`gp`（推送）、`gpl`（拉取）四个别名，自动生成符合 Conventional Commits 规范的中文提交信息。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

在对话中输入以下任意触发词：

| 触发词 | 对应操作 |
|--------|---------|
| `ga` | `git add`（暂存文件） |
| `gc` | `git commit`（提交，自动生成提交信息） |
| `gp` | `git push`（推送，禁止直接推送 main/master） |
| `gpl` | `git pull --rebase`（拉取并变基） |
| `commit`、`push`、`pull`、`stage`、`add` | 对应各自操作 |

## 使用示例

**场景一：暂存并提交变更**

```
ga
gc
```

`ga` 执行 `git add .` 并显示暂存结果；`gc` 展示 `git diff --cached`，自动推断提交类型（feat/fix/docs 等）和作用域，呈现完整提交信息供确认后执行。

**场景二：仅暂存特定文件**

```
ga src/auth.ts src/middleware.ts
```

仅暂存指定文件，执行后显示 `git status` 确认结果。

**场景三：拉取远程变更后推送**

```
gpl
gp
```

`gpl` 执行 `git pull --rebase` 保持线性历史；`gp` 检查当前分支（若为 main/master 则拒绝执行），推送到远程，远程分支不存在时自动设置 upstream。

## 输出

每个命令执行后在对话中显示对应 git 命令的输出结果（暂存状态、提交日志、推送结果等）。`gc` 会在执行前展示完整的 Conventional Commits 格式提交信息供用户确认，格式如下：

```
<type>(<scope>): <简短描述>

<详细说明（中文）>
```
