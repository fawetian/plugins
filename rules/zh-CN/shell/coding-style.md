---
paths:
  - "**/*.sh"
  - "**/*.bash"
  - "**/*.zsh"
  - "**/*.ksh"
---
# Shell 编码风格

> 本文件扩展了 [common/coding-style.md](../common/coding-style.md) 中的 Shell 特定内容。

## POSIX 兼容性

- 尽可能编写符合 POSIX 标准的脚本，以获得最大的可移植性
- POSIX 脚本使用 `#!/bin/sh`，需要 Bash 特性的脚本使用 `#!/bin/bash`
- 当目标是 `/bin/sh` 时，避免使用 bash 特有语法

## 静态分析

- **shellcheck** — 所有 shell 脚本必须使用
  ```bash
  shellcheck script.sh
  ```
- 提交前解决所有 shellcheck 警告

## 防御性编程

在脚本开头始终使用严格模式：

```bash
#!/bin/bash
set -euo pipefail

# -e: 命令以非零状态退出时立即退出
# -u: 将未设置的变量视为错误
# -o pipefail: 管道的返回值是最后一个以非零状态退出的命令的状态
```

## 变量使用

- 始终引用变量以防止分词和通配符扩展：
  ```bash
  # 好的做法
  echo "$variable"
  rm -rf "$dir"/*

  # 不好的做法
  echo $variable
  rm -rf $dir/*
  ```

- 在函数中使用局部变量：
  ```bash
  my_function() {
      local var="value"
      # ...
  }
  ```

- 环境变量使用大写，局部变量使用小写

## 函数定义

使用显式的函数语法：

```bash
# 好的做法
my_function() {
    echo "Hello"
}

# 避免（可移植性较差）
function my_function {
    echo "Hello"
}
```

## 错误处理

显式检查命令结果：

```bash
if ! command; then
    echo "Command failed" >&2
    exit 1
fi

# 或使用 ||
command || { echo "Command failed" >&2; exit 1; }
```

## 参考

更多全面的 shell 脚本习语和模式，请参见 skill：`shell-patterns`。
