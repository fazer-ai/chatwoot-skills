# chatwoot-skills — Distribution Packages

This folder contains pre-built distribution packages for installing chatwoot-skills on different Claude platforms.

## Available Packages

### Complete Bundle (Claude Code)

`chatwoot-skills-v1.0.0.zip` — all 8 skills in one package

```bash
# Recommended: install directly from GitHub
claude plugin install fazer-ai/chatwoot-skills

# Or install from local file
claude plugin install /path/to/chatwoot-skills-v1.0.0.zip
```

### Individual Skills (Claude.ai)

Upload each skill separately via **Settings → Capabilities → Skills**:

| File                                          | Skill                                             |
| --------------------------------------------- | ------------------------------------------------- |
| `chatwoot-mcp-tools-expert-v1.0.0.zip`        | Master guide for all 129 MCP tools                |
| `chatwoot-conversation-management-v1.0.0.zip` | Conversation lifecycle, messages, assignments     |
| `chatwoot-contact-operations-v1.0.0.zip`      | Contact CRUD, merging, filtering                  |
| `chatwoot-admin-configuration-v1.0.0.zip`     | Teams, inboxes, agents, automation rules          |
| `chatwoot-reporting-analytics-v1.0.0.zip`     | Reports, metrics, performance analysis            |
| `chatwoot-help-center-v1.0.0.zip`             | Portals, categories, articles                     |
| `chatwoot-automation-patterns-v1.0.0.zip`     | Bots, routing, escalation, integrations           |
| `chatwoot-fazer-ai-extensions-v1.0.0.zip`     | Kanban boards, scheduled messages (fazer.ai only) |

## Which Package Should I Use?

| Platform    | Package                       | Skills            |
| ----------- | ----------------------------- | ----------------- |
| Claude Code | Plugin install or full bundle | All 8 skills      |
| Claude.ai   | Individual skill zips         | Upload separately |

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) or Claude.ai Pro/Team/Enterprise
- A Chatwoot instance with API access
- [@fazer-ai/mcp-chatwoot](https://github.com/fazer-ai/mcp-chatwoot) MCP server configured

See [../docs/INSTALLATION.md](../docs/INSTALLATION.md) for full setup instructions.
