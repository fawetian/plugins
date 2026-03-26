# Gen Doc

自动检测 REST API 变更并生成或更新符合 OpenAPI 3.0 规范的 `openapi.yaml` 文档。

## 安装

```bash
/plugin install coding@fawetian-plugins
```

## 触发方式

以下情况均可触发该 skill：

- 明确输入 `/gen-doc` 或 `gen-doc`
- 提及 `生成 API 文档`、`更新 API 文档`、`API 有变化了`
- 提及 `生成 OpenAPI`、`同步 swagger`

| 命令 | 说明 |
|------|------|
| `/gen-doc` | 差异模式：仅分析 `git diff HEAD` 中变更的文件 |
| `/gen-doc diff` | 同上，明确指定差异模式 |
| `/gen-doc full` | 全量模式：扫描整个代码库的所有 API 定义 |

## 使用示例

**场景一：提交前自动同步 API 文档**

```
/gen-doc
```

分析本次 git 变更中涉及的路由文件，识别新增、修改或删除的 API 端点，更新 `openapi.yaml` 中对应的 `paths` 条目，保留手写的描述和示例，最终输出变更摘要。

**场景二：为新项目生成完整的 OpenAPI 文档**

```
/gen-doc full
```

扫描整个代码库，识别所有路由定义（支持 Express、FastAPI、Gin、Django、Rails 等主流框架），生成完整的 `openapi.yaml`，并逐一对照源码验证 HTTP 方法、路径参数、请求体结构的准确性。

**场景三：更新现有文档中的部分接口**

修改了某几个 API handler 后运行 `/gen-doc`，skill 只更新对应的 paths 条目，不影响其他手动编写的文档内容。

## 输出

生成或更新项目根目录（或 `docs/`、`api/` 目录）下的 `openapi.yaml` 文件，内容为符合 OpenAPI 3.0 规范的有效 YAML。

执行完成后在对话中输出摘要：

```
gen-doc complete

File: ./openapi.yaml
Added:    N endpoints
Updated:  N endpoints
Removed:  N endpoints

Preview with:
  npx @redocly/cli preview-docs openapi.yaml
```
