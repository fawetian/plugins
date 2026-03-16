# git-ops

Git 操作快捷指令插件，为开发者提供流畅、规范的 git 工作流。

## 功能

- **ga** - `git add` 快捷方式
- **gc** - `git commit`，强制 Conventional Commits 格式，中文描述
- **gp** - `git push`，禁止直接推送到 main/master
- **gpl** - `git pull --rebase`，保持线性历史

## 安装

```bash
/plugin install git-ops@fawetian-plugins
```

## 使用

### ga — 暂存文件

```bash
ga              # 暂存所有修改
ga src/         # 暂存指定目录
ga file1 file2  # 暂存指定文件
```

### gc — 提交代码

```bash
gc
```

自动推断 type 和 scope，引导填写中文 commit message。

### gp — 推送代码

```bash
gp
```

自动检测分支，禁止推送到 main/master。

### gpl — 拉取代码

```bash
gpl
```

使用 rebase 模式拉取，保持线性历史。

## Commit 规范

使用 Conventional Commits 格式：

```
<type>(<scope>): <中文描述>

<中文 body>
```

支持的 type：`feat`、`fix`、`docs`、`style`、`refactor`、`perf`、`test`、`chore`、`ci`、`revert`

## 许可证

MIT
