# Plugin Skill Evaluation Suite

Automated testing framework for verifying skill triggering accuracy and output quality across all plugins.

## Quick Start

```bash
# Run structure validation only (fast, no Claude needed)
./tests/run-all.sh --structure

# See what tests would run
./tests/run-all.sh --dry-run

# Run all tests
./tests/run-all.sh

# Test a specific skill
./tests/run-all.sh --trigger --skill git-ops
```

## Requirements

- `jq` (macOS: `brew install jq`)
- `claude` CLI (for trigger/explicit/output tests)

## 5-Layer Test Architecture

| Layer | Script | What it tests | Speed |
|-------|--------|---------------|-------|
| 1. Structure | `structure/validate-plugins.sh` | plugin.json validity, skill/agent frontmatter, marketplace consistency | Instant |
| 2. Positive Trigger | `triggering/run-trigger-tests.sh` | Skills trigger on expected prompts | ~2min/prompt |
| 3. Negative Trigger | `triggering/run-trigger-tests.sh` | Skills do NOT trigger on unrelated prompts | ~2min/prompt |
| 4. Explicit Request | `explicit/run-explicit-tests.sh` | Named skill triggers + no premature actions | ~2min/prompt |
| 5. Output Quality | `output/run-output-tests.sh` | Response content matches expected patterns | ~2min/prompt |

## evals.json Format

Each skill's eval file lives at `plugins/<plugin>/skills/<skill>/evals/evals.json`:

```json
{
  "name": "skill-name",
  "version": "1.0.0",
  "description": "What this eval covers",
  "evals": [
    {
      "name": "trigger-positive-xxx",
      "type": "trigger",
      "prompts": [
        { "input": "user prompt", "expected": true, "reason": "why" }
      ]
    },
    {
      "name": "trigger-negative-xxx",
      "type": "trigger",
      "prompts": [
        { "input": "user prompt", "expected": false, "reason": "why not" }
      ]
    },
    {
      "name": "output-quality-xxx",
      "type": "output",
      "prompt": "the prompt to test",
      "checks": [
        { "name": "check-name", "description": "what to verify", "pattern": "optional grep pattern" }
      ]
    }
  ]
}
```

See `lib/eval-schema.json` for the full JSON Schema.

## Options

```
./tests/run-all.sh [options]
  --structure       Structure validation only (no Claude)
  --trigger         Trigger tests only (positive + negative)
  --explicit        Explicit skill request tests only
  --output          Output quality tests only
  --plugin NAME     Filter to a specific plugin
  --skill NAME      Filter to a specific skill
  --verbose, -v     Detailed output including logs
  --timeout SEC     Timeout per test (default: 120s)
  --dry-run         List tests without executing
```

## Adding Evals for a New Skill

1. Create `evals/evals.json` in the skill directory
2. Add trigger evals (positive + negative prompts)
3. Optionally add output quality checks
4. Run: `./tests/run-all.sh --trigger --skill <name>`

## Directory Structure

```
tests/
├── run-all.sh                   # Main entry point
├── lib/
│   ├── test-helpers.sh          # Assertion library
│   ├── plugin-discovery.sh      # Auto-discover plugins and evals
│   └── eval-schema.json         # evals.json JSON Schema
├── structure/
│   └── validate-plugins.sh      # Plugin structure validation
├── triggering/
│   ├── run-trigger-tests.sh     # Batch trigger tests
│   └── run-single-trigger.sh    # Single prompt test
├── explicit/
│   └── run-explicit-tests.sh    # Explicit naming tests
└── output/
    └── run-output-tests.sh      # Output quality tests
```
