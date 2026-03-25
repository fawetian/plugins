---
name: feishu-cli
description: Use feishu-cli to interact with Feishu (Lark) platform — documents, messages, wiki, tasks, calendar, files, permissions, comments. Triggers: feishu, lark, 飞书, feishu-cli, send message to feishu, feishu doc, feishu wiki, feishu task, feishu calendar.
---

# feishu-cli — Feishu Platform CLI

`feishu-cli` is installed locally and available in PATH. Use it whenever the user needs to interact with the Feishu (Lark) open platform.

## Self-Discovery Protocol

**Always discover usage via `--help` before running commands. Never guess parameter names.**

```
# Step 1: discover top-level commands
feishu-cli --help

# Step 2: discover a module's subcommands
feishu-cli <command> --help

# Step 3: discover a specific operation's flags
feishu-cli <command> <subcommand> --help
```

Run these commands first, read the output, then construct the actual command.

## Configuration

The CLI requires Feishu App credentials. Check in this order:

1. **Environment variables** (preferred):
   ```
   FEISHU_APP_ID=cli_xxx
   FEISHU_APP_SECRET=xxx
   ```
2. **Config file**: `~/.feishu-cli/config.yaml`
3. If neither exists, prompt the user to configure credentials before proceeding.

Use `--debug` flag when troubleshooting to see HTTP request/response details.

## Module Index

Use this as a starting point to select the right module, then use `--help` to learn exact flags:

| Module | Purpose |
|--------|---------|
| `doc` | Create, get, edit, export/import documents, add highlight blocks |
| `wiki` | Knowledge base — get nodes, list spaces, export docs |
| `file` | Cloud storage — list, create, move, copy, delete files |
| `msg` | Send messages, search group chats, view conversation history |
| `task` | Create, view, update, complete tasks |
| `tasklist` | Task list management |
| `calendar` | Calendar and event management |
| `comment` | List, add, delete comments on documents |
| `perm` | Add or update document permissions |
| `user` | Get user info |
| `board` | Whiteboard operations |
| `media` | Upload/download media assets |
| `sheet` | Spreadsheet operations |
| `search` | Search messages and apps (requires user auth) |
| `auth` | User authorization management |
| `dept` | Department operations |
| `chat` | Group chat management |
| `config` | Initialize and manage CLI configuration |

## Usage Principles

1. **Always run `--help` first** — do not guess flags or subcommand names.
2. **Confirm before destructive operations** — deleting files, removing permissions, etc.
3. **Show output to user** — after each command, display the result clearly.
4. **Handle errors gracefully** — if a command fails, show the error and suggest next steps (check credentials, check IDs, run with `--debug`).
5. **Document IDs** — many operations require document/node/user IDs; ask the user if not provided.
