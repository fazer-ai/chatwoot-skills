---
name: chatwoot-reporting-analytics
description: Analyze Chatwoot metrics — account overview, agent performance, inbox reports, team reports, conversation metrics, and label analytics. Use when generating reports, analyzing support performance, or reviewing KPIs.
---

# Chatwoot Reporting & Analytics

Guide for using Chatwoot's reporting tools to analyze support performance.

## Report Types Overview

Chatwoot offers two generations of reporting APIs:

| API    | Tools                                                                                                          | Best for                                              |
| ------ | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| **V1** | `reports_account_overview`, `reports_account_summary`, `reports_agent_summary`, `reports_conversation_metrics` | Real-time overview, quick summaries                   |
| **V2** | `reports_v2_overview`, `reports_v2_agents`, `reports_v2_inboxes`, `reports_v2_teams`, `reports_v2_labels`      | Detailed breakdowns by dimension, date range analysis |

**Recommendation**: V2 endpoints are more comprehensive. Use V1 for real-time snapshots, V2 for historical analysis.

## Real-Time Overview

### Account overview (V1)

Get an instant snapshot of current conversation state:

```
reports_account_overview(account_id: 1)
```

Returns:

- Open conversations count
- Pending conversations count
- Unattended conversations count
- Agents online count

### Conversation meta counts

For conversation-status breakdowns:

```
conversations_meta(account_id: 1)
→ { open: 45, resolved: 1230, pending: 12, snoozed: 3, all: 1290, ... }
```

## V1 Reports

### Account summary

Summarized metrics for a date range:

```
reports_account_summary(
  account_id: 1,
  since: "2026-01-01",
  until: "2026-01-31",
  type: "account"
)
```

### Agent summary

Per-agent performance metrics:

```
reports_agent_summary(
  account_id: 1,
  since: "2026-01-01",
  until: "2026-01-31"
)
```

Returns per agent:

- Conversations handled
- Average first response time
- Average resolution time

### Conversation metrics

```
reports_conversation_metrics(
  account_id: 1,
  type: "account"
)
```

## V2 Reports (Recommended)

All V2 endpoints accept a consistent parameter set:

| Parameter    | Type    | Description                                         |
| ------------ | ------- | --------------------------------------------------- |
| `account_id` | integer | Required                                            |
| `since`      | string  | Start date (ISO format or Unix timestamp)           |
| `until`      | string  | End date                                            |
| `timezone`   | string  | IANA timezone (e.g., `"America/New_York"`, `"UTC"`) |

### V2 Overview

Aggregate metrics across the account:

```
reports_v2_overview(
  account_id: 1,
  since: "1704067200",
  until: "1706745600",
  timezone: "UTC"
)
```

### V2 Agent Report

Per-agent breakdown:

```
reports_v2_agents(
  account_id: 1,
  since: "1704067200",
  until: "1706745600",
  timezone: "America/New_York"
)
```

Returns per agent:

- `conversations_count` — Total conversations
- `avg_first_response_time` — Average first response (seconds)
- `avg_resolution_time` — Average time to resolve (seconds)
- `resolved_conversations_count` — Number resolved

### V2 Inbox Report

Per-inbox breakdown:

```
reports_v2_inboxes(
  account_id: 1,
  since: "1704067200",
  until: "1706745600",
  timezone: "UTC"
)
```

### V2 Team Report

Per-team breakdown:

```
reports_v2_teams(
  account_id: 1,
  since: "1704067200",
  until: "1706745600",
  timezone: "UTC"
)
```

### V2 Label Report

Per-label breakdown — useful for tracking issue categories:

```
reports_v2_labels(
  account_id: 1,
  since: "1704067200",
  until: "1706745600",
  timezone: "UTC"
)
```

## Key Metrics Explained

| Metric                       | Description                                          | Good benchmark       |
| ---------------------------- | ---------------------------------------------------- | -------------------- |
| **First Response Time**      | Time from conversation creation to first agent reply | < 5 minutes          |
| **Resolution Time**          | Time from creation to resolved status                | < 4 hours            |
| **Conversations Count**      | Total conversations in period                        | Depends on scale     |
| **CSAT**                     | Customer satisfaction score                          | > 4.0 / 5.0          |
| **Unattended Conversations** | Open conversations with no agent response            | Should be 0          |
| **Agent Online**             | Agents currently available                           | Monitor for coverage |

## Date Handling

V2 reports accept dates as **Unix timestamps** (seconds since epoch):

```
# January 1, 2026 00:00:00 UTC → 1767225600
# January 31, 2026 23:59:59 UTC → 1767311999
```

Set `timezone` to match your team's working timezone for accurate daily breakdowns.

## Common Analysis Patterns

See `METRICS_REFERENCE.md` for detailed metric calculations.

See `EXAMPLES.md` for real-world reporting scenarios.
