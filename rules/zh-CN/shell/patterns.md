---
paths:
  - "**/*.sh"
  - "**/*.bash"
  - "**/*.zsh"
---
# Shell 模式

> 本文件扩展了 [common/patterns.md](../common/patterns.md) 中的 Shell 特定内容。

## 错误处理

### 捕获信号

脚本退出时进行清理：

```bash
cleanup() {
    rm -rf "$temp_dir"
}
trap cleanup EXIT

trap 'echo "Error on line $LINENO" >&2' ERR
```

### 命令结果

始终检查退出码：

```bash
if command; then
    echo "Success"
else
    echo "Failed with exit code $?" >&2
    exit 1
fi
```

## 日志

使用一致的日志级别：

```bash
log_info() { echo "[INFO] $*"; }
log_warn() { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_debug() { [[ "${DEBUG:-}" ]] && echo "[DEBUG] $*" >&2; }
```

## 临时文件

创建安全的临时文件：

```bash
# 好的做法：mktemp 安全且可移植
temp_file=$(mktemp)
temp_dir=$(mktemp -d)

# 退出时清理
trap 'rm -rf "$temp_file" "$temp_dir"' EXIT
```

## 配置管理

安全地加载配置文件：

```bash
load_config() {
    local config_file="$1"
    if [[ -f "$config_file" ]]; then
        # shellcheck source=/dev/null
        source "$config_file"
    fi
}
```

## 路径处理

可靠地获取脚本目录：

```bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

## 字符串操作

使用参数扩展：

```bash
name="file.txt"
base="${name%.txt}"      # 移除后缀："file"
ext="${name##*.}"       # 获取扩展名："txt"
length="${#name}"        # 字符串长度
default="${unset:-default}"  # 默认值
```

## 数组使用

优先使用数组而非字符串拼接：

```bash
# 好的做法：数组
cmd=("docker" "run" "-it" "--rm" "myimage")
"${cmd[@]}"

# 不好的做法：字符串拼接
cmd="docker run -it --rm myimage"
$cmd  # 存在分词问题
```

## 参考

更多全面的 shell 脚本习语和模式，请参见 skill：`shell-patterns`。
