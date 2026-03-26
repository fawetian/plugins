# 仓库全量 Code Review

**时间**: 2026-03-25
**范围**: 整个仓库（非 diff 模式）
**审查维度**: 规范合规 · 结构配置 · 内容质量 · 测试覆盖 · 文档一致性

---

## 总结

| 维度 | 状态 | 主要问题 |
|------|------|---------|
| 规范合规 | ⚠️ 部分问题 | plugin.json 缺少 agents 字段声明 |
| 结构配置 | ✅ 基本健康 | source 路径、skills 数组、版本号均一致 |
| 内容质量 | ⚠️ 部分问题 | product 插件 SKILL_CN.md 缺少 frontmatter |
| 测试覆盖 | ❌ 覆盖率低 | 仅 19%（4/21 skills）有 evals.json |
| 文档一致性 | ⚠️ 部分问题 | CLAUDE_CN.md 不同步，zh-CN 翻译缺失 |

---

## 问题清单（置信度 ≥ 80）

### 🔴 高优先级

#### 1. coding / product / devops 的 plugin.json 缺少 `agents` 字段
**置信度**: 100
**位置**:
- `plugins/coding/.claude-plugin/plugin.json`
- `plugins/product/.claude-plugin/plugin.json`
- `plugins/devops/.claude-plugin/plugin.json`

这三个插件都有 `agents/` 目录（coding 11 个、product 2 个、devops 5 个），但 plugin.json 中完全没有 `agents` 数组声明。根据插件规范，agents 需要在 plugin.json 中显式注册才能被插件系统发现。

---

#### 2. 19 个 skills 缺少 `docs/README.md`
**置信度**: 100
**位置**: coding plugin（15 个）+ product plugin（4 个）

CLAUDE.md 规定所有人类面向文档（安装、配置、使用示例）应放在 `docs/README.md`。当前仅 cli 插件的 2 个 skills（aliyun、feishu-cli）有此文件。

缺失列表：
```
plugins/coding/skills/code-annotator/docs/README.md
plugins/coding/skills/code-research/docs/README.md
plugins/coding/skills/code-review/docs/README.md
plugins/coding/skills/code-simplifier/docs/README.md
plugins/coding/skills/code-translate/docs/README.md
plugins/coding/skills/database-migrations/docs/README.md
plugins/coding/skills/e2e-testing/docs/README.md
plugins/coding/skills/gen-doc/docs/README.md
plugins/coding/skills/git-ops/docs/README.md
plugins/coding/skills/golang-patterns/docs/README.md
plugins/coding/skills/postgres-patterns/docs/README.md
plugins/coding/skills/python-patterns/docs/README.md
plugins/coding/skills/rust-patterns/docs/README.md
plugins/coding/skills/security-review/docs/README.md
plugins/coding/skills/tdd-workflow/docs/README.md
plugins/product/skills/prd-writer/docs/README.md
plugins/product/skills/requirement-analysis/docs/README.md
plugins/product/skills/roadmap-planner/docs/README.md
plugins/product/skills/user-story/docs/README.md
```

---

#### 3. CLAUDE.md 与 CLAUDE_CN.md 内容不同步
**置信度**: 100
**位置**: `CLAUDE_CN.md`（104 行 vs CLAUDE.md 117 行）

CLAUDE_CN.md 完全缺少 **Skill Evaluation** 部分，包括：
- evals.json 的作用说明
- 测试脚本使用示例（`./tests/run-all.sh --structure` 等）
- `tests/lib/eval-schema.json` 和 `tests/README.md` 的引用

---

#### 4. product 插件 4 个 SKILL_CN.md 缺少 YAML frontmatter
**置信度**: 95
**位置**:
- `plugins/product/skills/prd-writer/docs/SKILL_CN.md:1`
- `plugins/product/skills/requirement-analysis/docs/SKILL_CN.md:1`
- `plugins/product/skills/roadmap-planner/docs/SKILL_CN.md:1`
- `plugins/product/skills/user-story/docs/SKILL_CN.md:1`

对应的英文 SKILL.md 都有 YAML frontmatter（name + description），但中文版缺失。CLAUDE.md 规范要求 SKILL.md 与 SKILL_CN.md 保持同步。

---

#### 5. 测试覆盖率仅 19%（4/21 skills）
**置信度**: 95
**位置**: 各 plugin 的 `skills/*/evals/evals.json`

已有 evals.json 的 skills：code-review、code-translate、git-ops、prd-writer
缺失 evals.json 的 skills（17 个）：aliyun、feishu-cli、code-annotator、code-research、code-simplifier、database-migrations、e2e-testing、gen-doc、golang-patterns、postgres-patterns、python-patterns、rust-patterns、security-review、tdd-workflow、requirement-analysis、roadmap-planner、user-story

---

#### 6. README.md / README_CN.md 未列出所有插件
**置信度**: 95
**位置**: `README.md:32-49`, `README_CN.md:29-48`

结构示例只展示了 `coding/` 一个插件，实际有 4 个（coding、product、cli、devops）。用户无法从 README 获知插件全貌。

---

### 🟡 中优先级

#### 7. rules/zh-CN/common/ 缺少 versioning.md 翻译
**置信度**: 100
**位置**: `rules/zh-CN/common/`（缺少 versioning.md）

`rules/common/versioning.md` 存在，但 `rules/zh-CN/common/versioning.md` 不存在。rules/README.md 声称 zh-CN 镜像完整目录结构，实际不符。

---

#### 8. validate-plugins.sh 不验证 plugin.json 必要字段
**置信度**: 80
**位置**: `tests/structure/validate-plugins.sh:52-78`

当前脚本仅做 JSON 语法检查和版本一致性校验，不验证 `name`、`version`、`description` 字段是否存在，也不验证版本格式是否符合 semver。`tests/lib/eval-schema.json` 存在但未被任何测试脚本使用。

---

#### 9. devops 插件无任何文档说明
**置信度**: 80
**位置**: `plugins/devops/`

devops 是唯一的 agents-only 插件，无 skills、无 README。marketplace.json 的描述为"开发者工具集：文档查询、代码清理、配置优化、循环监控"，但用户无处了解具体有哪些 agents 及如何使用。

---

## 验证通过项

- ✅ marketplace.json 所有 source 路径真实存在
- ✅ 所有 plugin.json 的 skills 数组与实际目录完全对应（无多余/缺失）
- ✅ devops 插件 name 已从 devtools 正确更新为 devops
- ✅ 所有插件版本符合 semver 格式，marketplace.json 与 plugin.json 版本号同步
- ✅ 所有 SKILL.md 都有正确的 YAML frontmatter（name + description）
- ✅ 所有 agent .md 都有正确的 YAML frontmatter（name + description）
- ✅ coding/product/cli 插件的所有 SKILL.md 与 SKILL_CN.md 成对存在且内容同步
- ✅ 所有 agents 都有对应的 zh-CN 中文版本
- ✅ 已有的 4 个 evals.json 格式符合 eval-schema.json 规范
- ✅ 测试框架脚本结构完整（run-all.sh、5 层测试脚本齐全）
- ✅ skill description 字段均清晰，能正确触发 skill
- ✅ agent description 字段均清晰，能正确判断委派时机
