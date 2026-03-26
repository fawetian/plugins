# 用户故事助手

用户故事创建与管理工具，遵循敏捷最佳实践，帮助你快速编写用户故事、定义验收标准并管理产品 Backlog。

## 安装

```bash
/plugin install product@fawetian-plugins
```

## 触发方式

在对话中使用以下任意触发词即可激活该 skill：

- `user story`
- `write stories`
- `acceptance criteria`
- `backlog`
- `user story mapping`

例如：输入 "请帮我写这个功能的 user story" 即可触发。

## 使用示例

**示例 1：编写单个用户故事**

```
请帮我写一个 user story：用户需要能够重置密码
```

**示例 2：批量生成故事集**

```
请为「购物车」功能 write stories，涵盖添加商品、修改数量、删除商品、结算等核心操作
```

**示例 3：补充验收标准**

```
请为以下用户故事补充 acceptance criteria：作为注册用户，我希望能收藏商品，以便下次快速找到
```

## 输出

生成的用户故事文档保存至 `docs/stories/{epic-name}/`，包含以下内容：

- 用户故事（标准格式：As a... / I want to... / So that...）
- 验收标准（Gherkin 格式：Given / When / Then）
- 故事头部信息（Story ID、Epic 引用、优先级 P0-P3、故事点数）
- 补充信息（UI/UX 备注、技术说明、依赖关系、完成定义清单）
- 用户故事地图（Mermaid 图，展示活动 - 任务 - 故事三层结构）

所有内容均以中文输出，遵循 INVEST 原则确保故事质量。
