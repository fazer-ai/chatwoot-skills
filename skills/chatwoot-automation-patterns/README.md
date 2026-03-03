# chatwoot-automation-patterns

**Purpose**: Higher-level patterns for automation using agent bots, integrations, webhooks, and automation rules together.

**Activation triggers**: Automation, bots, webhooks, integrations, workflows, routing, escalation, auto-assign, handoff, notifications.

## Files

| File                      | Lines | Description                                                                                                                 |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------- |
| `SKILL.md`                | ~200  | Core guide — 6 automation patterns: auto-assignment, SLA escalation, channel routing, bot handoff, webhooks, categorization |
| `AGENT_BOTS.md`           | ~110  | Agent bot setup, inbox attachment, webhook payloads, management                                                             |
| `INTEGRATION_PATTERNS.md` | ~140  | Webhook payloads, integration hooks, 4 integration recipes                                                                  |
| `EXAMPLES.md`             | ~130  | 4 end-to-end scenarios: routing system, escalation, bot+human hybrid, multi-channel notifications                           |

## Dependencies

- `chatwoot-admin-configuration` — for team/inbox/agent setup
- `chatwoot-mcp-tools-expert` — for general tool patterns
- Requires `@fazer-ai/mcp-chatwoot` MCP server

## Evaluation Coverage

- 4 evaluation scenarios in `evaluations/automation-patterns/`
