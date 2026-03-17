---
name: code-translate
description: STRICT TRIGGER - Only activate when user explicitly types "code-translate". Never activate for general translation requests, i18n discussions, or documentation questions. Translates English markdown documentation to Chinese while preserving directory structure and keeping technical terms in English.
userInvocable: true
---

# Code Translate

Translate English markdown documentation to Chinese. Translated files are saved to `docs/code-translate/` directory, preserving original files and directory structure.

## Commands

| Command | Description |
|---------|-------------|
| `/code-translate <path>` | Full translation of all .md files |
| `/code-translate --incremental <path>` | Only translate new/changed files |
| `/code-translate --resume <path>` | Resume interrupted translation |
| `/code-translate --status <path>` | Show current progress |

## Workflow

### Phase 1: File Scanning and Language Detection

CRITICAL: Use the scan script for efficiency, especially for large projects.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/scan-md.sh <project_path>
```

This generates:
- `docs/code-translate/scan-result.json` - File metadata (path, relative path, hash, word count)
- `docs/code-translate/scan-summary.json` - Scan statistics

**Why use script?**
- Fast scanning of all .md files in <1 second
- Minimal token consumption
- Consistent exclusion rules
- Preserves directory structure information

### Phase 1.5: Automatic Language Detection and Filtering

CRITICAL: Use script to automatically detect and filter translated files.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/filter-files.sh <project_path>
```

This will:
1. Analyze all scanned files for language indicators
2. Auto-mark translated files (zh-CN, ja-JP, etc.) as completed
3. Generate english-files.json for actual translation work
4. Report statistics:
   - Total files: XXX
   - Auto-skipped (already translated): XXX
   - English files to translate: XXX

**This filtering MUST happen automatically before Phase 2** - the user should never need to manually identify which files to skip.

### Phase 2: Progress Initialization (Script)

Choose mode based on user request:

#### Full Translation
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh init <project_path>
```

#### Incremental Translation
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh init-incremental <project_path>
```

This generates:
- `docs/code-translate/progress-state.json` - Translation progress state

### Phase 3: Translation Planning

CRITICAL: Copy the plan template to track progress:

```bash
cp ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/templates/TRANSLATION_PLAN.md <project_path>/docs/code-translate/TRANSLATION_PLAN.md
```

Then update the template with project-specific information:
- Project path
- Start time
- Total files/words from scan-summary.json
- Processing strategy based on project size

The plan template includes:
- **Statistics section**: Track completion counts and percentages
- **Current Batch section**: Track files being translated now
- **Progress Log section**: Record completed batches with timestamps
- **Failed Files section**: Track and retry failed translations
- **Next Actions section**: Plan upcoming work

Status markers to use in the plan:
- ⏳ Pending (待处理)
- 🔄 In Progress (进行中)
- ✅ Completed (已完成)
- ❌ Failed (失败, with reason)

### Phase 4: Concurrent Translation

CRITICAL: Execute continuously until ALL files are translated. Do not stop until progress shows 100%.

```
- Do NOT ask user for confirmation after each file
- Do NOT pause between batches
- Only stop when ALL files are translated or unrecoverable errors occur
- Report progress by updating TRANSLATION_PLAN.md
- Use scripts to track progress
- Verify each translated file exists and has Chinese content
```

#### Translation Verification Checklist

For EACH file translated, verify:
- [ ] File exists in output directory
- [ ] File has Chinese content (not English)
- [ ] File size is reasonable (>50% of original)
- [ ] Technical terms preserved in English
- [ ] YAML frontmatter preserved (if present)
- [ ] Code blocks unchanged

#### Automatic Concurrency Control

Use the batch translation script for automatic concurrency management:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/batch-translate.sh <project_path> [--max-agents=N]
```

The skill automatically determines concurrency based on project size:

**Small projects (< 50 files):**
- Sequential translation, 1 file at a time
- Batch size: 5-10 files

**Medium projects (50-200 files):**
- Parallel translation with 3 concurrent agents
- Batch size: 15 files per agent

**Large projects (200+ files):**
- Parallel translation with 5 concurrent agents
- Batch size: 20 files per agent
- Spawn new agents as soon as one completes

**Auto-scaling formula:**
```
concurrent_agents = min(5, max(1, pending_files // 50))
batch_size_per_agent = min(20, max(5, pending_files // concurrent_agents))
```

#### Batch Processing with Concurrent Agents

**MAIN CONTROLLER (parent process):**

1. Get pending files:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh next <project_path> <batch_size>
```

2. Calculate concurrency:
   - Count pending files
   - Set concurrent_agents = min(5, max(1, pending_files // 50))
   - Split pending files into batches for each agent

3. For EACH concurrent agent, spawn translation task:
   ```
   Task: Translate batch of files
   - Input: Array of file paths
   - Action: Translate each file, save to output, mark complete
   - Output: Success/failure for each file
   ```

4. Wait for all agents to complete

5. Check status and repeat until `Pending: 0`

**TRANSLATION AGENT (subprocess):**

For each file in assigned batch:
1. Read original file
2. Translate following all rules
3. Save to `docs/code-translate/<mirrored_path>`
4. Verify file exists and has Chinese content
5. Mark as completed:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh complete <project_path> "<file_path>"
```

6. On failure, mark as failed:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh fail <project_path> "<file_path>" "<error>"
```

7. Return batch completion report

#### Required Completion Criteria

Translation is NOT complete until:
1. `translate-progress.sh status` shows: `Pending: 0`
2. All files in scan-result.json have corresponding translated files
3. All translated files pass verification (Chinese content, proper formatting)
4. TRANSLATION_PLAN.md shows 100% completion

**CRITICAL: Do not stop until ALL 4 criteria are met.**

#### Required Completion Criteria

Translation is NOT complete until:
1. `translate-progress.sh status` shows: `Pending: 0`
2. All files in scan-result.json have corresponding translated files
3. All translated files pass verification (Chinese content, proper formatting)
4. TRANSLATION_PLAN.md shows 100% completion

#### Large File Handling

For files with >5000 words:
1. Split by sections (headers)
2. Translate each section separately
3. Merge translations maintaining consistency

### Phase 5: Directory Structure Preservation

CRITICAL: Maintain exact directory structure including empty directories

1. After all files are translated, sync directory structure:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh sync-dirs <project_path>
```

2. This ensures:
   - All directories from source exist in output
   - Empty directories are preserved
   - Directory timestamps are maintained

### Phase 6: Checkpoint and Recovery

#### Automatic Checkpoints
- Every 50 files (configurable)
- After each batch completes
- On any interruption

#### Manual Checkpoint
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh checkpoint <project_path>
```

#### Resume from Checkpoint
```bash
# Check current status
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh status <project_path>

# Continue translation - automatically skips completed files
/code-translate --resume <project_path>
```

### Phase 7: Completion

1. Generate final statistics:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh status <project_path>
```

2. Update TRANSLATION_PLAN.md with final status

3. Output completion summary:
   - Total files
   - Successfully translated
   - Failed (if any) with reasons
   - Total words translated
   - Time statistics
   - Output location

## Output Structure

```
<project>/
├── docs/
│   └── code-translate/
│       ├── scan-result.json       # File metadata
│       ├── scan-summary.json      # Scan statistics
│       ├── progress-state.json    # Progress state
│       ├── TRANSLATION_PLAN.md    # Progress report
│       ├── README.md              # Translated files (mirrored structure)
│       ├── CONTRIBUTING.md
│       └── docs/                  # Preserved directory structure
│           ├── guide.md
│           └── api/
│               └── reference.md
├── README.md                      # Original files (unchanged)
├── CONTRIBUTING.md
└── docs/
    ├── guide.md
    └── api/
        └── reference.md
```

## Translation Rules

### YAML Frontmatter

Preserve YAML frontmatter exactly as-is, do not translate:
```yaml
---
title: Keep as-is
description: Keep as-is
---
```

### Headers and Titles

Translate to Chinese:
- `# Getting Started` → `# 开始使用`
- `## Installation` → `## 安装`

### Technical Terms (Keep in English)

**Product Names:**
- Claude, Claude Code, Claude API
- GitHub, GitLab, Bitbucket
- VS Code, IntelliJ, Vim

**Technical Abbreviations:**
- API, SDK, CLI, GUI, UI, UX
- HTTP, HTTPS, TCP, IP, URL, URI
- JSON, XML, YAML, CSV
- SQL, NoSQL, DB, Database
- AI, ML, LLM, NLP
- CPU, GPU, RAM, SSD
- OS, VM, Container, Docker, Kubernetes, K8s

**Programming Terms:**
- Function, Method, Class, Interface, Module, Package, Library
- Variable, Constant, Parameter, Argument, Return value
- Array, List, Map, Dictionary, Object, String, Boolean
- Synchronous, Asynchronous, Concurrent, Parallel
- Compile, Build, Deploy, Runtime, Debug
- Frontend, Backend, Full-stack, Server-side, Client-side
- REST, GraphQL, gRPC, WebSocket, WebHook
- OAuth, JWT, Authentication, Authorization

**Framework/Tool Names:**
- React, Vue, Angular, Svelte
- Node.js, Deno, Bun
- Express, NestJS, Fastify
- Django, Flask, FastAPI, Spring
- PostgreSQL, MySQL, MongoDB, Redis, Elasticsearch
- AWS, GCP, Azure, Vercel, Netlify
- npm, yarn, pnpm, pip, cargo, maven
- Git, SVN, Mercurial

**Keep in English Format:**
- Code identifiers (variable names, function names, class names)
- File paths and directory names
- Command line examples
- Version numbers (v1.0.0, 2.x, etc.)
- Boolean values (true, false, null, undefined, nil)

### Code Blocks

Keep code blocks unchanged, do not translate:
````markdown
```python
def hello_world():
    print("Keep code as-is")
```
````

### Inline Code

Keep inline code unchanged:
- Use `git push` to push changes → 使用 `git push` 来推送更改

### Links

Translate link text, keep URL unchanged:
- [Read more](https://example.com) → [阅读更多](https://example.com)
- [Getting Started Guide](./guide.md) → [入门指南](./guide.md)

### Lists

Translate list content, keep formatting:
- Bullet points
- Numbered lists
- Task lists (`- [ ]` and `- [x]`)

### Tables

Translate table content, keep structure:
- Header cells
- Body cells
- Keep alignment markers (`:---`, `:---:`, `---:`)

### Emphasis

Preserve emphasis markers:
- **bold** → **粗体**
- *italic* → *斜体*
- ~~strikethrough~~ → ~~删除线~~

### Blockquotes

Translate quote content:
> This is important → > 这很重要

### Images

Keep image syntax unchanged:
- `![Alt text](image.png)` - translate alt text
- `![](image.png)` - keep as-is

### HTML Elements

Preserve HTML in markdown:
- `<details>`, `<summary>` - translate content, keep tags
- `<kbd>`, `<sub>`, `<sup>` - translate content, keep tags

## Error Handling

- When single file translation fails, record error reason and continue with other files
- Mark failed files using script:
  ```bash
  bash ${CLAUDE_PLUGIN_ROOT}/skills/code-translate/scripts/translate-progress.sh fail <project_path> "<file_path>" "Error reason"
  ```
- Summarize all errors in final report
- Provide option to retry failed files

## Language Style

- Use Simplified Chinese (简体中文)
- Professional and technical tone
- Consistent terminology throughout
- Natural Chinese expression (not literal word-for-word translation)
- Use Chinese punctuation marks (，。：；""''【】)

## Large Project Guide

For projects with 100+ markdown files:

1. **Batch Processing**: Use adaptive batch sizes based on file sizes
2. **Concurrent Agents**: Spawn 3-5 translation agents
3. **Checkpoint Strategy**: Auto-save every 50 files
4. **Progress Monitoring**: Update TRANSLATION_PLAN.md after each batch

## Additional Resources

### Scripts

- **`scripts/scan-md.sh`** - Fast markdown file scanning with metadata extraction and language detection
- **`scripts/detect-lang.sh`** - Language detection for markdown files (english|translated|unknown)
- **`scripts/filter-files.sh`** - Filter scanned files, auto-mark translated files as completed
- **`scripts/batch-translate.sh`** - Automated batch translation with concurrency control
- **`scripts/translate-progress.sh`** - Progress state management and directory sync
