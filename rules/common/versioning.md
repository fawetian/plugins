# Versioning

## Semantic Versioning (SemVer)

默认使用语义化版本号：`MAJOR.MINOR.PATCH`

```
MAJOR - 不兼容的 API 变更
MINOR - 向后兼容的功能新增
PATCH - 向后兼容的问题修复
```

### 递增规则

| 变更类型 | 版本递增 | 示例 |
|---------|---------|------|
| Breaking change | MAJOR | 1.0.0 → 2.0.0 |
| New feature | MINOR | 1.0.0 → 1.1.0 |
| Bug fix | PATCH | 1.0.0 → 1.0.1 |

## Pre-release 版本

预发布版本格式：`MAJOR.MINOR.PATCH-identifier`

```
1.0.0-alpha.1    # 内部测试
1.0.0-beta.1     # 公开测试
1.0.0-rc.1       # 发布候选
```

### Pre-release 优先级

```
alpha < beta < rc < (正式版)
1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-beta < 1.0.0-rc.1 < 1.0.0
```

## 场景规则

### Libraries / SDKs
- 严格遵循 SemVer
- MAJOR: 删除/修改公共 API
- MINOR: 新增公共 API
- PATCH: 修复 bug，不改变 API

### Applications / Services
- MINOR: 新功能、UI 变更、配置变更
- PATCH: Bug 修复、性能优化、文档更新
- MAJOR: 架构重构、重大功能变更

### APIs
- MAJOR: 破坏性变更（删除端点、修改响应结构）
- MINOR: 新增端点、可选参数
- PATCH: 修复、文档、内部优化

### Plugins / Extensions
- MINOR: 新增 skills/agents/hooks
- PATCH: skill 内容调整、bug 修复
- MAJOR: 删除组件、破坏性配置变更

## Build Metadata

构建元数据：`MAJOR.MINOR.PATCH+build`

```
1.0.0+build.123
1.0.0+20240101.gitabc123
```

构建元数据不影响版本优先级。

## Commit Type → Version 映射

| Commit Type | Version 递增 |
|------------|-------------|
| feat | MINOR |
| fix | PATCH |
| refactor | PATCH (无 API 变更时) |
| perf | PATCH |
| docs | 无版本递增 |
| test | 无版本递增 |
| chore | 无版本递增 |

## 自动化版本

### Conventional Commits + 自动化工具

```
feat: new feature      → MINOR
fix: bug fix           → PATCH
feat!: breaking change → MAJOR
```

### 推荐工具
- **standard-version**: 基于 commit 自动生成版本和 CHANGELOG
- **semantic-release**: 完全自动化的版本发布
- **conventional-changelog**: 生成 CHANGELOG

## 版本号检查清单

发布前确认：
- [ ] 版本号已更新
- [ ] CHANGELOG 已更新
- [ ] Git tag 已创建
- [ ] Breaking changes 已在文档中说明
