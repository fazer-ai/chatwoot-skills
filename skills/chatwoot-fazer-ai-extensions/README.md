# chatwoot-fazer-ai-extensions

**Purpose**: fazer.ai-exclusive Chatwoot features — Kanban boards, tasks, steps, audit events, and scheduled messages.

**⚠️ Requires a fazer.ai Chatwoot instance. Not available on standard Chatwoot.**

**Activation triggers**: Kanban, boards, pipeline, tasks, steps, scheduled messages, fazer.ai features, task management, follow-up scheduling.

## Files

| File                    | Lines | Description                                                                    |
| ----------------------- | ----- | ------------------------------------------------------------------------------ |
| `SKILL.md`              | ~180  | Core guide — Kanban architecture, boards/steps/tasks/audit, scheduled messages |
| `KANBAN_GUIDE.md`       | ~120  | Step-by-step board setup, task management patterns, audit trail                |
| `SCHEDULED_MESSAGES.md` | ~110  | Message scheduling use cases, multi-step sequences, management                 |
| `EXAMPLES.md`           | ~100  | 3 scenarios: pipeline setup, follow-up scheduling, audit review                |

## Dependencies

- `chatwoot-mcp-tools-expert` — for general tool patterns
- Requires `@fazer-ai/mcp-chatwoot` MCP server
- Requires fazer.ai Chatwoot instance

## Evaluation Coverage

- 3 evaluation scenarios in `evaluations/fazer-ai-extensions/`
