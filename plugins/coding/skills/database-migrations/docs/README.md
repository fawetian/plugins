# Database Migrations

为 PostgreSQL、MySQL 及常见 ORM（Prisma、Drizzle、Django、TypeORM、golang-migrate）提供安全、可回滚的数据库迁移最佳实践。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

该 skill 在以下场景下自动激活，无需显式命令：

- 创建或修改数据库表
- 添加/删除列或索引
- 执行数据迁移（回填、转换）
- 规划零停机 Schema 变更
- 为新项目配置迁移工具

在对话中提及相关操作时即可触发，例如：

- `我需要给 users 表添加一列`
- `如何安全地重命名这个字段`
- `帮我写一个数据回填迁移`

## 使用示例

**场景一：安全地添加非空列**

询问如何在大表上添加 `NOT NULL` 列时，skill 会引导使用三步 expand-contract 模式（先加可空列 → 回填数据 → 添加约束），避免全表锁。

**场景二：无停机创建索引**

创建索引时，skill 会提示使用 `CREATE INDEX CONCURRENTLY`，并说明各 ORM 的处理方式（如 Prisma 需要手动编写 SQL 迁移文件）。

**场景三：批量数据迁移**

需要更新大量行数据时，skill 提供分批处理模板（每批 10,000 行，使用 `FOR UPDATE SKIP LOCKED`），避免长事务锁表。

## 输出

该 skill 以内联指导的方式输出，直接在对话中提供：

- 迁移 SQL 代码片段（包含正确的 UP/DOWN）
- 各 ORM 对应的命令和 Schema 示例
- 迁移安全性检查清单
- 反模式警告及替代方案

不生成独立文件，所有指导内容直接嵌入当前对话上下文。
