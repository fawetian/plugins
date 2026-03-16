---
name: gen-doc
description: 当用户调用 "gen-doc"时使用此 skill。自动检测 REST API 接口变更并生成/更新 OpenAPI 3.0 文档。
---

# gen-doc

检测 REST API 接口变更，并生成或更新符合 OpenAPI 3.0 规范的 `openapi.yaml` 文件。

## 第一阶段：确定模式

从调用参数中读取模式，无需询问用户，直接执行：

- `/gen-doc` 或 `/gen-doc diff` → **diff 模式**：仅分析 `git diff HEAD` 中变更的文件
- `/gen-doc full` → **full 模式**：扫描整个代码库中所有 API 定义

未传参数时默认使用 diff 模式。

diff 模式下，执行 `git diff HEAD` 获取变更文件列表。
full 模式下，通过关键词扫描全局源文件：`router`、`handler`、`controller`、`endpoint`、`route`、`@GetMapping`、`@PostMapping`、`app.get`、`app.post`、`Route::` 等。

## 第二阶段：识别接口变更

使用语言无关的模式匹配识别 REST 接口：

**路由/Handler 识别模式：**
- JavaScript/TypeScript：`router.get/post/put/delete/patch`、`app.get/post/put/delete`、`express.Router`
- Python：`@app.route`、`@router.get/post`、FastAPI/Flask 装饰器
- Java/Kotlin：`@GetMapping`、`@PostMapping`、`@RequestMapping`、`@RestController`
- Go：`http.HandleFunc`、`r.GET/POST`、gin/echo/fiber 路由注册
- PHP：`Route::get/post`、Laravel 路由定义
- Ruby：routes.rb 中的 `get/post/put/delete`、Rails resource 路由

**对每个识别到的接口，提取以下信息：**
- HTTP 方法（GET、POST、PUT、DELETE、PATCH）
- 路径（如 `/api/v1/users/{id}`）
- 路径参数
- 查询参数
- 请求体结构（如有）
- 响应体结构（如有）
- 认证要求（如可见）

整理成结构化接口清单：`{ method, path, params, request_body, responses, summary }`

## 第三阶段：生成或更新 openapi.yaml

**检查已有文件：**
- 在项目根目录、`docs/`、`api/` 或 `src/` 下查找 `openapi.yaml` / `openapi.yml`
- 同时检查 `swagger.yaml` / `swagger.yml`

**已有文件 — 更新模式：**
- 解析已有 YAML
- 对每个变更接口：仅更新对应的 `paths` 条目
- 对已删除接口（如可从 diff 中识别）：标记为 deprecated 或删除
- 保留所有手写描述、示例及未变更的路径

**无文件 — 新建模式：**
- 使用模板 `./templates/openapi_init.yaml` 初始化文件结构

**OpenAPI 3.0 路径条目格式：**
- 每个路径块参考 `./templates/path_entry.yaml` 的结构

将最终 YAML 写入发现的路径，默认为项目根目录下的 `./openapi.yaml`。

## 第四阶段：逐接口核查文档与代码一致性

对写入 `openapi.yaml` 的每个接口，重新读取对应源代码，逐项核查：

- **HTTP 方法**：与路由定义完全一致
- **路径**：与注册的路由字符串一致（包括 `{id}` 等路径参数）
- **路径参数**：路径中每个 `{param}` 在参数列表中有对应条目，类型正确
- **查询参数**：handler 签名中的所有查询参数均已文档化，无多余条目
- **请求体**：字段、类型、required 标记与代码中实际解析的结构体/schema 一致
- **响应体**：文档中的响应结构与 handler 实际返回内容一致
- **认证**：若路由在鉴权中间件之后，`security` 字段须存在；若为公开接口，则须缺省

发现任何不一致，在进入下一阶段前先修正 `openapi.yaml`。

若某字段无法仅从代码中确定（如深层嵌套的动态响应），标注 `description: "TODO: verify manually"`，不得凭猜测填写。

## 第五阶段：汇总输出

输出执行结果：

```
gen-doc 完成

文件：./openapi.yaml
新增：N 个接口
更新：N 个接口
删除：N 个接口

预览方式：
  npx @redocly/cli preview-docs openapi.yaml
  npx swagger-ui-express  （或任意 Swagger UI 工具）
```

## 注意事项

- 不假设具体语言或框架，通过通用模式匹配识别接口
- 保留手写描述，只更新发生变更的部分
- 若 diff 中不包含任何 API 相关变更，报告并退出
- 对于模糊的匹配模式，倾向于包含而非跳过（避免漏报）
- 始终输出合法的 OpenAPI 3.0 YAML
