# Code Review — 最近 5 次提交

**日期：** 2026-03-24
**模式：** Local（已提交未推送，review 范围 bc89d8d..1f48e5f）
**提交数：** 5 commits, 54 files changed, 640 insertions(+), 9 deletions(-)

## 改动范围

| 提交 | 类型 | 描述 |
|------|------|------|
| `bc89d8d` | feat(cli) | 新增 cli 插件（飞书/阿里云 CLI skills） |
| `cf5c16b` | chore | 添加 .worktrees 到 .gitignore |
| `b5c0950` | feat(plugins) | 将 agents 迁入 plugin 系统，拆分为三个 plugin |
| `35e86da` | chore | 添加 .worktrees 到 .gitignore（重复） |
| `1f48e5f` | chore | 解决 marketplace.json 合并冲突 |

## 发现的问题

### ISSUE 1: marketplace.json 版本号与 plugin.json 不一致 [CRITICAL]

**置信度：** 100
**文件：** `.claude-plugin/marketplace.json`

| 插件 | marketplace.json | plugin.json | 应为 |
|------|-----------------|-------------|------|
| coding | 1.1.1 | 1.2.0 | 1.2.0 |
| product | 1.0.0 | 1.1.0 | 1.1.0 |

**根因：** `1f48e5f` 合并冲突解决时，marketplace.json 采用了旧分支的版本号，未同步 `b5c0950` 中对 coding/product 的版本升级。

**影响：** Claude Code 无法通过 `/plugin update` 正确检测插件更新。

---

### ISSUE 2: marketplace.json 描述与 plugin.json 不一致 [CRITICAL]

**置信度：** 85
**文件：** `.claude-plugin/marketplace.json`

| 插件 | marketplace.json 描述 | plugin.json 描述 |
|------|----------------------|-----------------|
| coding | `代码质量工具集：代码研究、注释、审查、简化、Git操作` | `...、模式指南，内置专项审查和构建修复 Agents` |
| product | `产品经理工具集：需求分析、PRD撰写、用户故事、产品规划` | `...，内置规划和架构设计 Agents` |

marketplace 缺少 agents 迁入后新增的描述信息。product 的 keywords 也未同步（缺少 `agents`, `planning`, `architecture`）。

---

### ISSUE 3: 重复 commit [MEDIUM]

**置信度：** 95
**文件：** `.gitignore`

`cf5c16b` 和 `35e86da` 内容完全相同（添加 `.worktrees/` 到 .gitignore），时间戳也相同。推测为 worktree 分支各自提交后合并导致。不影响功能，但 git 历史冗余。

## 排除的问题（低于阈值 80）

| 问题 | 来源 | 得分 | 排除原因 |
|------|------|------|----------|
| devtools plugin.json 缺少 `skills: []` | Agent 1, 2 | 65 | agents-only 插件省略 skills 字段是合理的 |
| agents 未在 plugin.json 中注册 | Agent 2 | 75 | Claude Code 自动发现 agents/ 目录，无需显式注册 |
| agents/zh-CN/ 目录未在 CLAUDE.md 中记录 | Agent 1 | 70 | 现有惯例，不属于本次变更引入 |
| evals/ 目录标注为可选 | Agent 5 | 65 | 架构图本身已用 optional 标注 |

## 合规检查

| 检查项 | 结果 |
|--------|------|
| SKILL.md 英文 + YAML frontmatter | ✓ |
| docs/SKILL_CN.md 中文同步 | ✓ |
| docs/README.md 安装文档 | ✓ |
| Agent 文件命名（小写+连字符） | ✓ |
| Agent YAML frontmatter (name + description) | ✓ |
| 版本号 semver 语义正确 | ✓ (plugin.json 层面) |
| Conventional Commits 格式 | ✓ |
| 中英文文档同步更新 | ✓ |
| marketplace.json 新增条目格式 | ✓ (cli, devtools) |

## 修复建议

1. **更新 marketplace.json** — 同步 coding (1.2.0) 和 product (1.1.0) 的版本号、描述和关键词
2. **可选** — 通过 rebase 合并重复的 .gitignore commit（仅在推送前有意义）
