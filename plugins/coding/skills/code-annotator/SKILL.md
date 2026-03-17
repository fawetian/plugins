---
name: code-annotator
description: Automatically adds comprehensive Chinese comments to source code files. Supports large projects with incremental updates and resume capability. This skill should be used when the user invokes "code-annotator" or "/code-annotator"
userInvocable: true
---

# Code Annotator

Add Chinese comments to project source code files. Annotated files are saved to `docs/annotation/` directory, preserving original files.

## Commands

| Command | Description |
|---------|-------------|
| `/code-annotator <path>` | Full annotation of all source files |
| `/code-annotator --incremental <path>` | Only process new/changed files |
| `/code-annotator --resume <path>` | Resume interrupted annotation |
| `/code-annotator --module <name> <path>` | Annotate specific module only |
| `/code-annotator --status <path>` | Show current progress |

## Workflow

### Phase 1: File Scanning (Script)

CRITICAL: Use the scan script for efficiency, especially for large projects.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/scan-files.sh <project_path>
```

This generates:
- `docs/annotation/scan-result.json` - File metadata (path, language, sloc, complexity, hash)
- `docs/annotation/scan-summary.json` - Scan statistics

**Why use script?**
- 1381 files scanned in <1 second (vs 10-30 seconds with AI Glob calls)
- Minimal token consumption
- Consistent exclusion rules

For exclusion rules, see `references/exclusion-rules.md`.

### Phase 2: Progress Initialization (Script)

Choose mode based on user request:

#### Full Annotation
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh init <project_path>
```

#### Incremental Annotation
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/detect-changes.sh <project_path>
```

This generates:
- `docs/annotation/progress-state.json` - Annotation progress state
- `docs/annotation/changes.json` - Change detection result (incremental mode)

### Phase 3: Annotation Planning

Based on `progress-state.json`, create `docs/annotation/ANNOTATION_PLAN.md`:

```markdown
# Annotation Progress

## Statistics
- Total files: X
- Completed: 0
- In progress: 0
- Pending: X
- Failed: 0

## Processing Strategy

[For large projects: Describe module-by-module approach]

## File List

| Status | File Path | Complexity | Notes |
|--------|-----------|------------|-------|
| Pending | src/index.ts | low | |
| Pending | src/core/engine.ts | high | |
...
```

Status markers:
- Pending
- In progress
- Completed
- Failed (with reason)

Complexity levels: `low`, `medium`, `high`, `very_high`

### Phase 4: Concurrent Annotation

CRITICAL: Execute continuously until completion

```
- Do NOT ask user for confirmation after each file
- Do NOT pause between batches
- Only stop when encountering unrecoverable errors
- Report progress by updating ANNOTATION_PLAN.md
- Use scripts to track progress
```

#### Batch Processing

1. Get next batch of files:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh next <project_path> <batch_size>
```

2. Adaptive batch size based on complexity:
   - Low complexity (<200 SLOC): 5-8 files/batch
   - Medium complexity (200-1000 SLOC): 3-5 files/batch
   - High complexity (1000-3000 SLOC): 1-2 files/batch
   - Very high complexity (>3000 SLOC): Split file into chunks

3. For each file in batch:
   ```bash
   # Mark as in progress
   bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh start <project_path> "<file_path>"
   ```

4. Spawn annotation agents using Task tool (3-5 concurrent agents)

5. Each agent:
   - Reads the original file
   - Adds Chinese comments following annotation standards
   - Saves annotated file to `docs/annotation/<mirrored_path>`
   - Does NOT modify original file

6. After completion:
   ```bash
   # Mark as completed
   bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh complete <project_path> "<file_path>"

   # Or if failed
   bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh fail <project_path> "<file_path>" "Error reason"
   ```

7. Update ANNOTATION_PLAN.md with progress

8. Continue to next batch automatically

#### Large File Handling

For files with >5000 SLOC:
1. Split into logical chunks (module/function boundaries)
2. Process each chunk separately
3. Merge annotations maintaining consistency

### Phase 5: Checkpoint and Recovery

#### Automatic Checkpoints
- Every 50 files (configurable)
- After each module completes
- On any interruption

#### Manual Checkpoint
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh checkpoint <project_path>
```

#### Resume from Checkpoint
```bash
# Check current status
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh status <project_path>

# Continue annotation - automatically skips completed files
/code-annotator --resume <project_path>
```

### Phase 6: Completion

1. Generate final statistics:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh status <project_path>
```

2. Update ANNOTATION_PLAN.md with final status

3. Output completion summary:
   - Total files
   - Successfully annotated
   - Failed (if any) with reasons
   - Time statistics
   - Output location

## Output Structure

```
<project>/
├── docs/
│   └── annotation/
│       ├── scan-result.json       # File metadata
│       ├── scan-summary.json      # Scan statistics
│       ├── progress-state.json    # Progress state
│       ├── changes.json           # Change detection (incremental)
│       ├── ANNOTATION_PLAN.md     # Progress report
│       └── src/                   # Annotated files (mirrored)
│           ├── index.ts
│           └── utils/
│               └── helper.ts
├── src/                           # Original files (unchanged)
│   ├── index.ts
│   └── utils/
│       └── helper.ts
└── ...
```

## Annotation Standards

For detailed annotation standards and examples, see `references/annotation-standards.md`.

### Three-Layer Structure

1. **File header** - Explain file purpose
2. **Class/Function** - Document strings for each class and function
3. **Internal logic** - Comments for complex business logic, algorithms, or hard-to-understand code segments

### Key Principles

- Explain **Why**, not What - Code shows what, comments explain why
- Keep concise - Avoid verbose comments, but don't omit key information
- Stay in sync - Comments must accurately reflect code behavior
- Mark important info - Boundary conditions, special handling, known issues

### Language

All comments in **Chinese**.

When adding comments, also detect and convert existing English comments to Chinese:
- Keep original position and format
- Technical terms can remain in English (API, HTTP, JSON, etc.)
- Keep code examples' variable names and function names unchanged
- Keep TODO, FIXME, NOTE, HACK, XXX markers in English, translate descriptions
- Keep copyright and license information unchanged

## Error Handling

- When single file annotation fails, record error reason and continue with other files
- Mark failed files using script:
  ```bash
  bash ${CLAUDE_PLUGIN_ROOT}/skills/code-annotator/scripts/manage-progress.sh fail <project_path> "<file_path>" "Error reason"
  ```
- Summarize all errors in final report
- Provide option to retry failed files

## Large Project Guide

For projects with 1000+ files, see `references/large-project-guide.md` for:
- Module-based processing
- Concurrency configuration
- Checkpoint strategy
- Performance optimization

## Additional Resources

### Reference Files

- **`references/annotation-standards.md`** - Detailed annotation standards, granularity guidelines, and examples
- **`references/exclusion-rules.md`** - File exclusion rules during scanning
- **`references/large-project-guide.md`** - Guide for annotating large codebases

### Scripts

- **`scripts/scan-files.sh`** - Fast file scanning with metadata extraction
- **`scripts/manage-progress.sh`** - Progress state management
- **`scripts/detect-changes.sh`** - Incremental change detection
