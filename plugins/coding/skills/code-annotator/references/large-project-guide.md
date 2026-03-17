# Large Project Annotation Guide

Guide for annotating large codebases (1000+ files, 100K+ lines of code).

## Overview

Large projects present unique challenges:
- **Scale**: Thousands of files require systematic processing
- **Complexity**: Module dependencies and architecture need understanding
- **Time**: Full annotation can take hours
- **Resilience**: Must handle failures gracefully and support resume

## Architecture

### Script + Prompt Hybrid Model

| Component | Responsibility |
|-----------|---------------|
| `scan-files.sh` | Fast file discovery, metadata extraction |
| `manage-progress.sh` | State management, progress tracking |
| `detect-changes.sh` | Incremental change detection |
| AI (SKILL.md) | Annotation execution, quality control |

### Output Files

```
docs/annotation/
├── scan-result.json       # File metadata (path, language, sloc, hash)
├── scan-summary.json      # Scan statistics
├── progress-state.json    # Annotation progress state
├── changes.json           # Incremental change detection result
├── checkpoint-*.json      # Progress checkpoints
├── ANNOTATION_PLAN.md     # Human-readable progress report
└── src/                   # Annotated files (mirrored structure)
```

## Processing Modes

### 1. Full Annotation

Annotate all source files from scratch.

```bash
# Step 1: Scan files
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/scan-files.sh /path/to/project

# Step 2: Initialize progress
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh init /path/to/project

# Step 3: AI executes annotation (handled by SKILL.md)
/code-annotator /path/to/project
```

### 2. Incremental Annotation

Only process new or changed files.

```bash
# Detect changes
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/detect-changes.sh /path/to/project

# AI processes only changed files
/code-annotator --incremental /path/to/project
```

### 3. Resume Annotation

Continue from where previous annotation stopped.

```bash
# Check current status
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh status /path/to/project

# Resume annotation
/code-annotator --resume /path/to/project
```

## Batch Processing Strategy

### Adaptive Batch Sizing

Batch size adjusts based on file complexity:

| Complexity | SLOC Range | Batch Size |
|------------|------------|------------|
| Low | < 200 | 8 files |
| Medium | 200 - 1000 | 5 files |
| High | 1000 - 3000 | 2 files |
| Very High | > 3000 | 1 file (split if needed) |

### Module-Based Processing

For very large projects, process by module/crate:

```bash
# Example: Process only the core module
/code-annotator --module core /path/to/project
```

Modules are detected from:
- Rust: `Cargo.toml` crate structure
- TypeScript: `package.json` workspaces or directory structure
- Python: Package directories

## Concurrency Configuration

Default configuration (can be customized via `.annotationrc.json`):

```json
{
  "concurrency": {
    "maxAgents": 5,
    "batchSize": "auto",
    "rateLimitRpm": 60
  },
  "checkpoint": {
    "enabled": true,
    "interval": 50
  },
  "largeFile": {
    "splitThreshold": 5000,
    "maxChunkSize": 2000
  }
}
```

### Concurrency Guidelines

- **maxAgents**: Number of parallel annotation agents (3-5 recommended)
- **batchSize**: Files per batch ("auto" for adaptive sizing)
- **rateLimitRpm**: Maximum requests per minute (API limits)

## Checkpoint Strategy

### Automatic Checkpoints

Progress is automatically saved:
- Every N files (configurable, default 50)
- After each module completes
- On any error or interruption

### Manual Checkpoint

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh checkpoint /path/to/project
```

### Recovery

When resuming:
1. Load `progress-state.json`
2. Skip all files with `status: "completed"`
3. Continue from first `status: "pending"` file

## Error Handling

### Failure Categories

| Category | Action |
|----------|--------|
| File read error | Skip, mark as failed, continue |
| Parse error | Skip, mark as failed, continue |
| API rate limit | Wait, retry with backoff |
| Agent timeout | Retry with smaller batch |
| System error | Save checkpoint, stop |

### Retry Strategy

```
1st failure: Immediate retry
2nd failure: Wait 30s, retry
3rd failure: Mark as failed, continue
```

## Performance Optimization

### Scan Optimization

The `scan-files.sh` script:
- Uses native `find` command (fastest option)
- Applies exclusion rules at scan time
- Calculates SLOC and hash in single pass
- Outputs structured JSON for AI consumption

**Performance**: 1381 files scanned in <1 second

### Progress State Management

The `manage-progress.sh` script:
- Uses JSON for structured state
- Supports both `jq` and Python fallback
- Atomic file writes to prevent corruption
- Minimal token consumption for AI

### Token Efficiency

| Operation | Pure Prompt | Script Enhanced |
|-----------|-------------|-----------------|
| File scan | 10-30s, high tokens | <1s, ~0 tokens |
| Progress check | 5-10s, medium tokens | <0.1s, ~0 tokens |
| Change detection | Manual, error-prone | Automated, reliable |

## Large File Handling

### Split Strategy

Files exceeding `splitThreshold` (default 5000 SLOC) are split:

1. **By logical sections**: Classes, functions, modules
2. **Chunk size**: Maximum `maxChunkSize` lines per chunk
3. **Context preservation**: Each chunk includes necessary context

### Example: Large File Split

```
Original: huge_file.rs (8000 lines)

Split into:
├── huge_file.rs.001.rs  (lines 1-2000, module imports + first module)
├── huge_file.rs.002.rs  (lines 1800-3800, overlapping context)
├── huge_file.rs.003.rs  (lines 3600-5600, overlapping context)
└── huge_file.rs.004.rs  (lines 5400-8000, remaining code)
```

## Monitoring and Reporting

### Real-time Progress

```bash
# Watch progress (updates every 5 seconds)
watch -n 5 'bash scripts/manage-progress.sh status /path/to/project'
```

### Final Report

Upon completion, generate:
- `ANNOTATION_PLAN.md`: Human-readable summary
- Statistics: Total, completed, failed, time
- Failed file list with error reasons

## Best Practices

### 1. Start Small

Before annotating a 1000+ file project:
```bash
# Test on single module first
/code-annotator --module utils /path/to/project
```

### 2. Validate Quality

Spot-check annotation quality:
- Review 5-10 random files
- Check all three annotation layers
- Verify Chinese comment quality

### 3. Use Incremental Mode

After initial annotation:
```bash
# Daily updates
/code-annotator --incremental /path/to/project
```

### 4. Regular Checkpoints

For very long sessions:
```bash
# Create checkpoint every 100 files
bash scripts/manage-progress.sh checkpoint /path/to/project
```

### 5. Handle Failures

Review and retry failed files:
```bash
# Check status
bash scripts/manage-progress.sh status /path/to/project

# Reset specific failed file
bash scripts/manage-progress.sh reset /path/to/project
# Then retry
```

## Troubleshooting

### "jq not found" Warning

Install jq for better performance:
```bash
# macOS
brew install jq

# Linux
apt-get install jq
```

Scripts fall back to Python automatically.

### Scan Takes Too Long

Check exclusion rules are applied:
```bash
# Verify scan result count
jq 'length' docs/annotation/scan-result.json
```

If count seems high, check for:
- Missing exclusion patterns
- Nested node_modules/vendor directories
- Generated files not excluded

### Progress State Corruption

Restore from checkpoint:
```bash
# List checkpoints
ls docs/annotation/checkpoint-*.json

# Restore latest
cp docs/annotation/checkpoint-LATEST.json docs/annotation/progress-state.json
```

### Memory Issues

For very large projects (10K+ files):
1. Process by module
2. Reduce batch size
3. Increase checkpoint frequency
