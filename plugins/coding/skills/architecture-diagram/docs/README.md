# Architecture Diagram Generator

生成专业级暗色主题系统架构图，输出为自包含的 HTML 文件（内嵌 SVG + CSS），任何浏览器直接打开。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

在对话中描述你的系统架构即可触发：

- `Create an architecture diagram for my web app`
- `帮我画一个微服务架构图`
- `Visualize our AWS infrastructure`
- `Draw a network topology diagram showing how these services connect`

## 使用示例

**场景一：Web 应用架构**

```
Create an architecture diagram for a web application with:
- React frontend
- Node.js/Express API
- PostgreSQL database
- Redis cache
- JWT authentication
```

**场景二：AWS Serverless**

```
Create an architecture diagram showing:
- CloudFront CDN
- API Gateway
- Lambda functions
- DynamoDB
- S3 for static assets
```

**场景三：微服务**

```
Create an architecture diagram for a microservices system with:
- API Gateway
- User Service (Go), Order Service (Java), Product Service (Python)
- PostgreSQL, MongoDB, Elasticsearch
- Kafka for event streaming
- Kubernetes orchestration
```

## 输出

单个自包含 `.html` 文件，包含：

- **Header** — 项目标题 + 状态指示器
- **主图** — SVG 架构图（组件 + 连接箭头）
- **摘要卡片** — 3 个信息卡片展示关键细节
- **Footer** — 元数据

## 颜色系统

| 组件类型 | 颜色 | 用途 |
|---------|------|------|
| Frontend | Cyan | 客户端、UI、边缘设备 |
| Backend | Emerald | 服务器、API、服务 |
| Database | Violet | 数据库、存储、AI/ML |
| Cloud/AWS | Amber | 云服务、基础设施 |
| Security | Rose | 认证、安全组、加密 |
| Message Bus | Orange | 消息队列、事件总线 |
| External | Slate | 通用、外部系统 |

## 迭代

生成后可继续对话迭代调整：

- `Add a CDN layer in front of the frontend`
- `Change the database from PostgreSQL to MongoDB`
- `Add a security group around the backend services`

## 致谢

基于 [Cocoon-AI/architecture-diagram-generator](https://github.com/Cocoon-AI/architecture-diagram-generator) (MIT License) 集成。
