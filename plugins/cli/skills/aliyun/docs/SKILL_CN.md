---
name: aliyun
description: 使用 aliyun CLI 与阿里云服务交互——ECS、OSS、RDS、VPC、CDN、FC、SLB、DNS 等。触发词：aliyun、alicloud、阿里云、aliyun cli、ecs、oss、rds、cdn、serverless、fc、slb、alidns。
---

# aliyun — 阿里云命令行工具

`aliyun` CLI（v3.3.2）已安装在本地并可在 PATH 中使用。当用户需要与阿里云服务交互时，使用此工具。

## 自主探索协议

**执行命令前，始终通过 `--help` 发现用法，不猜测操作名称或参数名称。**

```
# 第一步：列出可用产品
aliyun --help

# 第二步：查看某产品的操作列表
aliyun <product> --help

# 第三步：查看具体操作的参数
aliyun <product> <Operation> --help
```

先运行这些命令读取输出，再构造实际命令。

## 配置方式

CLI 使用 profile 进行认证，按以下顺序检查：

1. **默认 profile**：`aliyun configure list` — 检查是否已配置 profile
2. **指定 profile**：`aliyun --profile <profileName> <product> <Operation>`
3. **内联凭证**（脚本中避免使用）：
   ```
   aliyun --access-key-id <AK> --access-key-secret <SK> <product> <Operation>
   ```
4. 若未配置 profile，提示用户先运行 `aliyun configure`。

## 常用全局参数

| 参数 | 用途 |
|------|------|
| `--region <regionId>` | 指定地域（如 `cn-hangzhou`、`cn-beijing`） |
| `--profile <name>` | 使用指定凭证 profile |
| `--output cols=F1,F2` | 过滤输出为指定字段（表格格式） |
| `--cli-query <jmespath>` | 用 JMESPath 过滤 JSON 输出 |
| `--pager` | 自动合并分页结果 |
| `--dryrun` | 预览请求，不实际执行 |
| `--debug` | 显示 HTTP 请求/响应，用于排障 |
| `--quiet` | 关闭正常输出 |

## 产品分类索引

以此确认正确的产品名称，再通过 `--help` 了解具体操作：

**计算**
- `ecs` — 云服务器 ECS（虚拟机）
- `fc` — 函数计算（Serverless）
- `cs` — 容器服务（Kubernetes）
- `batch` — 批量计算

**存储**
- `oss` — 对象存储 OSS
- `nas` — 文件存储 NAS
- `hbr` — 混合云备份

**数据库**
- `rds` — 云数据库 RDS
- `dds` — MongoDB
- `r-kvstore` — Redis/Memcache
- `polardb` — PolarDB

**网络**
- `vpc` — 专有网络 VPC
- `slb` — 负载均衡 SLB
- `alb` — 应用型负载均衡
- `cdn` — 内容分发网络
- `alidns` — 云解析 DNS
- `eip` — 弹性公网 IP

**安全**
- `ram` — 访问控制（IAM）
- `sts` — 安全令牌服务
- `waf` — Web 应用防火墙
- `ddoscoo` — DDoS 高防

**监控运维**
- `cms` — 云监控
- `actiontrail` — 操作审计
- `arms` — 应用实时监控

**消息**
- `mns` — 消息服务
- `alikafka` — 消息队列 Kafka
- `ons` — 消息队列

## 使用原则

1. **始终先运行 `--help`** — 操作名称为 PascalCase（如 `DescribeInstances`、`CreateBucket`），不猜测名称。
2. **变更操作前确认** — CreateInstance、DeleteInstance、StopInstance 等操作需用户确认。
3. **使用 `--dryrun` 预览** — 对破坏性或高成本操作，先展示请求内容再执行。
4. **展示结构化输出** — 使用 `--output` 或 `--cli-query` 清晰呈现结果，而非直接输出原始 JSON。
5. **地域意识** — 创建资源时始终确认或询问地域；默认值可能不符合用户意图。
6. **处理错误** — 命令失败时，展示错误码和信息；建议检查权限（RAM 策略）或使用 `--debug`。
