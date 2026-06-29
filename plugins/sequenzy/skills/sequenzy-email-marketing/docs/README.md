# Sequenzy Plugin

This plugin exposes a Sequenzy email marketing operator skill for Claude Code and Codex, plus an MCP configuration for `@sequenzy/mcp`.

## What it does

Use it when an agent needs to operate permissioned Sequenzy workflows:

- subscribers, lists, tags, and segments
- campaign drafts, schedules, and stats
- lifecycle sequences and automations
- transactional email sends
- inbox replies, webhook events, and delivery checks

Sequenzy is for owned-audience lifecycle, product, ecommerce, and transactional email. It is not a cold-outreach or spam workflow.

## Claude Code install

```bash
/plugin marketplace add fawetian/plugins
/plugin install sequenzy@fawetian-plugins
```

## Codex install

```bash
codex plugin marketplace add fawetian/plugins
codex plugin add sequenzy@fawetian-plugins-codex
```

## MCP configuration

Set `SEQUENZY_API_KEY` in your environment or MCP client secret store. Local clients can run:

```json
{
  "mcpServers": {
    "sequenzy": {
      "command": "npx",
      "args": ["-y", "@sequenzy/mcp"],
      "env": {
        "SEQUENZY_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

Hosted endpoint:

```text
https://api.sequenzy.com/v1/mcp
```

## Example prompts

- "Create a Sequenzy segment of activated trial users who have not completed onboarding, then draft a campaign for approval."
- "Review yesterday's Sequenzy onboarding campaign and summarize bounces, replies, and performance issues."
- "Send a transactional receipt email through Sequenzy and verify delivery status."
