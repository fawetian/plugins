---
name: aliyun
description: Use aliyun CLI to interact with Alibaba Cloud services — ECS, OSS, RDS, VPC, CDN, FC, SLB, DNS, and more. Triggers: aliyun, alicloud, 阿里云, aliyun cli, ecs, oss, rds, cdn, serverless, fc, slb, alidns.
---

# aliyun — Alibaba Cloud CLI

`aliyun` CLI (v3.3.2) is installed locally and available in PATH. Use it whenever the user needs to interact with Alibaba Cloud services.

## Self-Discovery Protocol

**Always discover usage via `--help` before running commands. Never guess operation names or parameter names.**

```
# Step 1: list available products
aliyun --help

# Step 2: discover operations for a product
aliyun <product> --help

# Step 3: discover parameters for a specific operation
aliyun <product> <Operation> --help
```

Run these commands first, read the output, then construct the actual command.

## Configuration

The CLI uses profiles for authentication. Check in this order:

1. **Default profile**: `aliyun configure list` — check if a profile is already configured
2. **Specify profile**: `aliyun --profile <profileName> <product> <Operation>`
3. **Inline credentials** (avoid in scripts):
   ```
   aliyun --access-key-id <AK> --access-key-secret <SK> <product> <Operation>
   ```
4. If no profile configured, prompt the user to run `aliyun configure` first.

## Useful Global Flags

| Flag | Purpose |
|------|---------|
| `--region <regionId>` | Specify region (e.g. `cn-hangzhou`, `cn-beijing`) |
| `--profile <name>` | Use a specific credential profile |
| `--output cols=F1,F2` | Filter output to specific fields (table format) |
| `--cli-query <jmespath>` | Filter JSON output with JMESPath |
| `--pager` | Merge paginated results automatically |
| `--dryrun` | Preview request without executing |
| `--debug` | Show HTTP request/response for troubleshooting |
| `--quiet` | Suppress normal output |

## Product Category Index

Use this to identify the right product name, then use `--help` to learn operations:

**Compute**
- `ecs` — Elastic Compute Service (VMs)
- `fc` — Function Compute (serverless)
- `cs` — Container Service (Kubernetes)
- `batch` — Batch Compute

**Storage**
- `oss` — Object Storage Service
- `nas` — Network Attached Storage
- `hbr` — Hybrid Backup Recovery

**Database**
- `rds` — Relational Database Service
- `dds` — MongoDB
- `r-kvstore` — Redis/Memcache
- `polardb` — PolarDB

**Networking**
- `vpc` — Virtual Private Cloud
- `slb` — Server Load Balancer
- `alb` — Application Load Balancer
- `cdn` — Content Delivery Network
- `alidns` — DNS management
- `eip` — Elastic IP

**Security**
- `ram` — Resource Access Management (IAM)
- `sts` — Security Token Service
- `waf` — Web Application Firewall
- `ddoscoo` — DDoS Protection

**Monitoring & Ops**
- `cms` — Cloud Monitor Service
- `actiontrail` — Operation Audit
- `arms` — Application Real-Time Monitoring

**Messaging**
- `mns` — Message Notification Service
- `alikafka` — Kafka
- `ons` — Message Queue

## Usage Principles

1. **Always run `--help` first** — operation names are PascalCase (e.g. `DescribeInstances`, `CreateBucket`); never guess them.
2. **Confirm before mutating operations** — CreateInstance, DeleteInstance, StopInstance, etc. require user confirmation.
3. **Use `--dryrun` for preview** — show the user what will be sent before executing destructive or expensive operations.
4. **Show structured output** — use `--output` or `--cli-query` to present results clearly rather than dumping raw JSON.
5. **Region awareness** — always confirm or ask for region when creating resources; defaults may not match user's intent.
6. **Handle errors** — if a command fails, show the error code and message; suggest checking permissions (RAM policy) or running with `--debug`.
