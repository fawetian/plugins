---
name: code-annotator
description: This skill should be used when the user invokes "code-annotator" or "/code-annotator". Automatically adds comprehensive Chinese comments to source code files.
userInvocable: true
---

# Code Annotator

Add Chinese comments to project source code files. Annotated files are saved to `docs/annotation/` directory, preserving original files.

## Workflow

### Phase 1: File Scanning

Scan all source code files in the project. For exclusion rules, see `references/exclusion-rules.md`.

Generate `docs/annotation/FILES.md`: list all source code file paths to be annotated.

### Phase 2: Annotation Planning

Based on FILES.md, create `docs/annotation/ANNOTATION_PLAN.md`:

```markdown
# Annotation Progress

## Statistics
- Total files: X
- Completed: 0
- In progress: 0
- Pending: X

## File List

| Status | File Path | Notes |
|--------|-----------|-------|
| Pending | src/index.ts | |
| Pending | src/utils/helper.ts | |
...
```

Status markers:
- Pending
- In progress
- Completed
- Failed (with reason)

### Phase 3: Concurrent Annotation

CRITICAL: Execute continuously until completion

```
- Do NOT ask user for confirmation after each file
- Do NOT pause between batches
- Only stop when encountering unrecoverable errors
- Report progress by updating ANNOTATION_PLAN.md
```

Output location:
- Annotated files are saved to `docs/annotation/src/...` (mirroring original structure)
- Original source files are NOT modified

Execution steps:
1. Create annotation tasks using TodoWrite
2. Use Task tool to concurrently spawn multiple annotation agents (3-5 files per batch)
3. Each agent annotates one file and saves to `docs/annotation/`
4. After each file completes, immediately update status in ANNOTATION_PLAN.md
5. Automatically continue to next batch until all files complete

### Phase 4: Completion

1. Update ANNOTATION_PLAN.md, mark all tasks complete
2. Output completion summary:
   - Total files
   - Successfully annotated
   - Failed (if any)
   - Time statistics

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

## Example

**Input:**
```
/code-annotator /path/to/my-project
```

**Output Structure:**
```
my-project/
├── docs/
│   └── annotation/
│       ├── FILES.md               # Source code list
│       ├── ANNOTATION_PLAN.md     # Progress tracking
│       └── src/                   # Annotated files (mirrored structure)
│           ├── index.ts           # (Annotated)
│           └── utils/
│               └── helper.ts      # (Annotated)
├── src/                           # Original files (unchanged)
│   ├── index.ts
│   └── utils/
│       └── helper.ts
└── ...
```

## Error Handling

- When single file annotation fails, record error reason and continue with other files
- Mark failed files and reasons in ANNOTATION_PLAN.md
- Summarize all errors in final report

## Additional Resources

### Reference Files

- **`references/annotation-standards.md`** - Detailed annotation standards, granularity guidelines, and examples
- **`references/exclusion-rules.md`** - File exclusion rules during scanning
