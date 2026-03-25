# aliyun CLI

阿里云命令行工具。项目地址：https://github.com/aliyun/aliyun-cli

## 安装

**macOS（推荐）**

```bash
brew install aliyun-cli
```

**macOS / Linux 一键脚本**

```bash
/bin/bash -c "$(curl -fsSL https://aliyuncli.alicdn.com/install.sh)"
```

**手动下载**

| 平台 | 下载链接 |
|------|---------|
| macOS (Universal) | https://aliyuncli.alicdn.com/aliyun-cli-macosx-latest-universal.tgz |
| Linux (AMD64) | https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz |
| Linux (ARM64) | https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-arm64.tgz |
| Windows (64bit) | https://aliyuncli.alicdn.com/aliyun-cli-windows-latest-amd64.zip |

所有版本：https://github.com/aliyun/aliyun-cli/releases

## 配置

```bash
aliyun configure
# 按提示输入 Access Key ID、Access Key Secret、默认 Region（如 cn-hangzhou）
```

## 验证

```bash
aliyun --version
aliyun ecs DescribeRegions
```
