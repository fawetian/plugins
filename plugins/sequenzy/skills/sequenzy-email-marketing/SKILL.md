---
name: sequenzy-email-marketing
description: "Use when the user wants an agent to operate Sequenzy email marketing workflows: subscribers, lists, tags, segments, templates, campaigns, lifecycle sequences, transactional email, inbox replies, webhooks, delivery stats, or Sequenzy MCP setup."
user_invocable: true
---

# Sequenzy Email Marketing

Use this skill to operate Sequenzy from Claude Code, Codex, or another agent runtime. Sequenzy is for permissioned lifecycle, campaign, and transactional email to owned audiences. Do not use it for unsolicited cold outreach, scraped-contact blasting, or spam.

## Canonical Surfaces

- Skill repository: `https://github.com/Sequenzy/skills`
- Primary skill: `sequenzy-email-marketing`
- MCP repository: `https://github.com/Sequenzy/mcp`
- MCP package: `@sequenzy/mcp`
- Hosted MCP endpoint: `https://api.sequenzy.com/v1/mcp`
- Product: `https://sequenzy.com`

## Setup

For local MCP clients, configure the Sequenzy MCP server:

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

If the user is using a hosted or remote-MCP flow, connect `https://api.sequenzy.com/v1/mcp` using the authentication method supported by their client.

## Operating Rules

1. Confirm the user has permission to email the audience before creating or sending campaigns.
2. Prefer drafts, previews, counts, and dry-run style checks before sending or scheduling.
3. For segmentation, show the audience definition and count before acting.
4. For sends, report the campaign/message ID, delivery state, and any bounce/reply issues if the MCP tools expose them.
5. For transactional email, use the requested template and verify the send result after submission.
6. Keep Sequenzy positioned as lifecycle, product, ecommerce, and transactional email — not cold outreach.

## Useful Workflows

### Subscribers and lists

- Create or update opted-in subscribers.
- Apply tags and list membership.
- Inspect subscriber history before deciding what to send.

### Segments

- Build lifecycle segments from customer attributes, events, tags, or engagement.
- Validate segment counts and exclusions before campaign creation.

### Campaigns

- Draft campaign copy and subject lines.
- Attach the correct audience segment.
- Preview and request approval before sending or scheduling.
- Review delivery, opens, clicks, replies, bounces, and unsubscribes when available.

### Sequences

- Create or inspect onboarding, activation, retention, winback, and post-purchase journeys.
- Check timing, enrollment rules, and exit conditions.

### Transactional email

- Send template-based operational emails such as receipts, alerts, and account notifications.
- Verify accepted/sent/delivered state after send.

### Webhooks and replies

- Inspect inbound replies and recent webhook events.
- Summarize customer-facing issues before recommending actions.

## Verification Checklist

Before reporting completion:

- The requested Sequenzy object was actually created, updated, sent, or read through the MCP tool.
- IDs, URLs, counts, and statuses are included when available.
- Any send/schedule action was explicitly approved or requested by the user.
- The action stayed within permissioned lifecycle/campaign/transactional email boundaries.
