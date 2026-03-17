# Translation Progress 翻译进度

## Project Information 项目信息
- **Project Path**: {{PROJECT_PATH}}
- **Started At**: {{START_TIME}}
- **Mode**: {{MODE}} (full/incremental)

## Statistics 统计
- **Total Files**: {{TOTAL_FILES}}
- **Completed**: {{COMPLETED}} ({{COMPLETED_PERCENT}}%)
- **In Progress**: {{IN_PROGRESS}}
- **Pending**: {{PENDING}}
- **Failed**: {{FAILED}}
- **Total Words**: {{TOTAL_WORDS}}

## Processing Strategy 处理策略

{{STRATEGY}}

## Current Batch 当前批次

**Batch {{BATCH_NUMBER}} - {{BATCH_STATUS}}**

| # | Status | File Path | Word Count | Notes |
|---|--------|-----------|------------|-------|
{{BATCH_FILES}}

## Progress Log 进度日志

{{PROGRESS_LOG}}

## Failed Files 失败文件

{{FAILED_FILES}}

## Next Actions 下一步操作

{{NEXT_ACTIONS}}

---

## Usage Instructions 使用说明

### Update Progress 更新进度

After completing a batch, update this file with:

```markdown
### Batch X - Completed YYYY-MM-DD HH:MM
- ✅ file1.md (XXX words)
- ✅ file2.md (XXX words)
```

### Mark File In Progress 标记进行中

```markdown
| 1 | In Progress | docs/guide.md | 1200 | Translating... |
```

### Mark File Failed 标记失败

```markdown
### Failed Files
- ❌ docs/error.md: Error reason here
```

## Completion Checklist 完成检查清单

- [ ] All files translated 所有文件已翻译
- [ ] Directory structure synced 目录结构已同步
- [ ] Failed files reviewed 失败文件已检查
- [ ] Quality verified 质量已验证
