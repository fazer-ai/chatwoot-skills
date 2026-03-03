# chatwoot-reporting-analytics

**Purpose**: Understanding and using Chatwoot's reporting tools — account overview, agent performance, inbox metrics, label-based reporting, v1 vs v2 APIs.

**Activation triggers**: Reports, analytics, metrics, performance, KPIs, first response time, resolution time, agent performance, inbox performance, team performance.

## Files

| File                   | Lines | Description                                                           |
| ---------------------- | ----- | --------------------------------------------------------------------- |
| `SKILL.md`             | ~160  | Core guide — V1 vs V2 reports, parameters, key metrics, date handling |
| `METRICS_REFERENCE.md` | ~120  | Detailed metric definitions, calculations, derived insights           |
| `EXAMPLES.md`          | ~90   | 3 scenarios: weekly summary, slowest inboxes, workload analysis       |

## Dependencies

- `chatwoot-mcp-tools-expert` — for general tool patterns
- Requires `@fazer-ai/mcp-chatwoot` MCP server

## Evaluation Coverage

- 3 evaluation scenarios in `evaluations/reporting-analytics/`
