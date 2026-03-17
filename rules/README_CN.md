# Rules 规则系统

## 目录结构

规则按 **common** 通用层加 **语言特定** 目录组织：

```
rules/
├── common/          # 语言无关的原则（始终安装）
│   ├── coding-style.md
│   ├── git-workflow.md
│   ├── testing.md
│   ├── performance.md
│   ├── patterns.md
│   ├── hooks.md
│   ├── agents.md
│   └── security.md
├── typescript/      # TypeScript/JavaScript 专用
├── python/          # Python 专用
├── golang/          # Go 专用
├── rust/            # Rust 专用
├── shell/           # Shell/Bash/Zsh 专用
└── swift/           # Swift 专用
```

- **common/** 包含通用原则 —— 不包含语言特定的代码示例。
- **语言目录** 扩展通用规则，包含框架特定的模式、工具和代码示例。每个文件引用其通用对应文件。

## 安装

### 方式一：安装脚本（推荐）

```bash
# 安装 common + 一个或多个语言专用规则集
./install.sh typescript
./install.sh python
./install.sh golang
./install.sh rust
./install.sh shell
./install.sh swift

# 同时安装多个语言
./install.sh typescript python
```

### 方式二：手动安装

> **重要：** 复制整个目录 —— 不要 用 `/*` 扁平化。
> Common 和语言专用目录包含同名文件。
> 将它们扁平化到一个目录会导致语言专用文件覆盖通用规则，
> 并破坏语言专用文件使用的相对 `../common/` 引用。

```bash
# 安装通用规则（所有项目必需）
cp -r rules/common ~/.claude/rules/common

# 根据项目技术栈安装语言专用规则
cp -r rules/typescript ~/.claude/rules/typescript
cp -r rules/python ~/.claude/rules/python
cp -r rules/golang ~/.claude/rules/golang
cp -r rules/rust ~/.claude/rules/rust
cp -r rules/shell ~/.claude/rules/shell
cp -r rules/swift ~/.claude/rules/swift

# 注意！！！根据实际项目需求配置；此处配置仅供参考。
```

## Rules vs Skills

- **Rules** 定义广泛适用的标准、约定和检查清单（例如，"80% 测试覆盖率"、"无硬编码密钥"）。
- **Skills**（`skills/` 目录）为特定任务提供深入、可操作的参考资料（例如，`python-patterns`、`golang-testing`）。

语言专用规则文件在适当的地方引用相关技能。Rules 告诉你*做什么*；skills 告诉你*怎么做*。

## 添加新语言

要添加对新语言的支持（例如 `rust/`）：

1. 创建 `rules/rust/` 目录
2. 添加扩展通用规则的文件：
   - `coding-style.md` —— 格式化工具、习惯用法、错误处理模式
   - `testing.md` —— 测试框架、覆盖率工具、测试组织
   - `patterns.md` —— 语言特定的设计模式
   - `hooks.md` —— 用于格式化工具、linter、类型检查器的 PostToolUse 钩子
   - `security.md` —— 密钥管理、安全扫描工具
3. 每个文件应以以下内容开头：
   ```
   > 本文件扩展 [common/xxx.md](../common/xxx.md)，添加 <语言> 特定内容。
   ```
4. 引用现有技能（如果有），或在 `skills/` 下创建新技能。

## 规则优先级

当语言专用规则和通用规则冲突时，**语言专用规则优先**（具体覆盖一般）。这遵循标准的分层配置模式（类似于 CSS 特异性或 `.gitignore` 优先级）。

- `rules/common/` 定义适用于所有项目的通用默认值。
- `rules/golang/`、`rules/python/`、`rules/swift/`、`rules/typescript/` 等在用语言习惯用法不同的地方覆盖这些默认值。

### 示例

`common/coding-style.md` 推荐不变性作为默认原则。语言专用的 `golang/coding-style.md` 可以覆盖它：

> 地道的 Go 使用指针接收器进行结构体修改 —— 参见 [common/coding-style.md](../common/coding-style.md) 了解一般原则，但这里优先使用地道的 Go 修改方式。

### 带覆盖说明的通用规则

`rules/common/` 中可能被语言专用文件覆盖的规则标记为：

> **语言说明**：此规则可能被语言专用规则覆盖，适用于该模式不地道的语言。
