# chatwoot-admin-configuration

**Purpose**: Setting up and managing Chatwoot infrastructure — teams, agents, inboxes, webhooks, automation rules, canned responses, custom attributes/filters.

**Activation triggers**: Admin, setup, configure, teams, agents, inboxes, webhooks, automation rules, canned responses, custom attributes, custom filters.

## Files

| File                  | Lines | Description                                                                                              |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------- |
| `SKILL.md`            | ~180  | Core guide — entity relationships, teams, agents, inboxes, canned responses, custom attributes, webhooks |
| `SETUP_GUIDE.md`      | ~130  | Step-by-step walkthroughs: new team, custom attributes, multi-team routing                               |
| `AUTOMATION_RULES.md` | ~150  | Automation rule syntax: events, conditions, actions, examples                                            |

## Dependencies

- `chatwoot-mcp-tools-expert` — for general tool patterns
- Requires `@fazer-ai/mcp-chatwoot` MCP server

## Evaluation Coverage

- 4 evaluation scenarios in `evaluations/admin-configuration/`
