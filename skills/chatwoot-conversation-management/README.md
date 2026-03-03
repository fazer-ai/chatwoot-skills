# chatwoot-conversation-management

**Purpose**: End-to-end conversation workflows — creating, filtering, assigning, toggling status/priority, managing labels and custom attributes, sending messages.

**Activation triggers**: Conversations, messages, assignments, conversation status, priority, labels, replies, triage, escalation.

## Files

| File                   | Lines | Description                                                                                      |
| ---------------------- | ----- | ------------------------------------------------------------------------------------------------ |
| `SKILL.md`             | ~180  | Core guide — lifecycle, status, priority, messages, assignments, labels, filtering               |
| `WORKFLOW_PATTERNS.md` | ~130  | 6 workflow patterns: triage, escalation, bulk resolution, handoff, SLA monitoring, label routing |
| `EXAMPLES.md`          | ~100  | 4 real-world scenarios with step-by-step tool calls                                              |

## Dependencies

- `chatwoot-mcp-tools-expert` — for tool selection and filter syntax
- Requires `@fazer-ai/mcp-chatwoot` MCP server

## Evaluation Coverage

- 4 evaluation scenarios in `evaluations/conversation-management/`
