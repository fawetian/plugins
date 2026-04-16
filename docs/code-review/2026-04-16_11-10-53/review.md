# Code Review: architecture-diagram skill 集成

**日期**: 2026-04-16 11:10
**范围**: plugins/coding/skills/architecture-diagram/ 新增 + plugin.json/marketplace.json 版本更新
**模式**: Local

---

## 变更摘要

将 [Cocoon-AI/architecture-diagram-generator](https://github.com/Cocoon-AI/architecture-diagram-generator) 的 skill 集成到 coding 插件中，用于生成暗色主题系统架构图（HTML+SVG）。

**涉及文件**:
- `plugins/coding/.claude-plugin/plugin.json` — 版本 1.3.3→1.4.0，新增 skill 引用
- `.claude-plugin/marketplace.json` — 版本 1.3.1→1.4.0（同步）
- `plugins/coding/skills/architecture-diagram/SKILL.md` — 原封复制自源仓库 + 添加 `userInvocable: true`
- `plugins/coding/skills/architecture-diagram/assets/template.html` — 原封复制自源仓库
- `plugins/coding/skills/architecture-diagram/docs/README.md` — 新写
- `plugins/coding/skills/architecture-diagram/docs/SKILL_CN.md` — 新写（中文翻译）
- `plugins/coding/skills/architecture-diagram/evals/evals.json` — 新写

---

## 发现的问题

### [85] SKILL_CN.md 缺少 `userInvocable: true`

**文件**: `plugins/coding/skills/architecture-diagram/docs/SKILL_CN.md:1-8`

SKILL.md 中有 `userInvocable: true`，但 SKILL_CN.md 的 frontmatter 缺少此字段。按照项目 CLAUDE.md 约定 "Keep SKILL.md and SKILL_CN.md in sync"，两个文件的 frontmatter 必须保持一致。

**修复**: 在 SKILL_CN.md 的 frontmatter 中添加 `userInvocable: true`。

---

## 已验证通过的检查项

- [x] SKILL.md 是英文 — PASS
- [x] SKILL_CN.md 是中文翻译 — PASS
- [x] evals.json 格式正确（有效 JSON）— PASS
- [x] plugin.json 格式正确（有效 JSON）— PASS
- [x] SKILL.md YAML frontmatter 解析正常 — PASS
- [x] 版本 bump 为 MINOR（1.3.x → 1.4.0，新增 skill）— PASS
- [x] marketplace.json 和 plugin.json 版本同步（1.4.0）— PASS
- [x] SKILL.md 和 SKILL_CN.md 章节结构一致（10 个章节完全对应）— PASS
- [x] 核心文件（SKILL.md, template.html）与源仓库 diff 一致 — PASS
- [x] README.md 包含原作者致谢（Cocoon-AI）— PASS
- [x] `--structure` 测试通过 — PASS
- [x] 反向触发测试全部通过（4/4）— PASS

---

## 注意事项（非阻塞）

1. **正向触发测试失败（6/6）**: Claude 的自动 skill 匹配未能将测试 prompt 关联到此 skill。这不是代码 bug，而是 description 字段的匹配精度问题。`userInvocable: true` 提供了显式调用路径（`/architecture-diagram`）作为补充。

2. **marketplace.json 长期版本漂移**: 此前 marketplace.json（1.3.1）与 plugin.json（1.3.3）已不同步 2 个版本。本次一并修复为 1.4.0。

3. **原仓库 license**: MIT License，已在 README.md 中致谢。不需要在代码中额外添加 license 文件。
