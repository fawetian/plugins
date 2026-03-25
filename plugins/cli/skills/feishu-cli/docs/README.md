# feishu-cli

飞书开放平台命令行工具。项目地址：https://github.com/riba2534/feishu-cli

## 安装

**一键安装（推荐）**

```bash
curl -fsSL https://raw.githubusercontent.com/riba2534/feishu-cli/main/install.sh | bash
```

已安装用户执行同样命令可更新到最新版本。

**其他方式**

```bash
# go install
go install github.com/riba2534/feishu-cli@latest

# 手动下载
# https://github.com/riba2534/feishu-cli/releases/latest
```

## 配置凭证

1. 在[飞书开放平台](https://open.feishu.cn/app)创建应用，获取 App ID 和 App Secret
2. 给应用添加所需权限
3. 配置凭证（二选一）：

```bash
# 方式一：环境变量（推荐）
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"

# 方式二：配置文件
feishu-cli config init
```

## 验证

```bash
feishu-cli --help
feishu-cli doc create --title "Hello Feishu"
```
