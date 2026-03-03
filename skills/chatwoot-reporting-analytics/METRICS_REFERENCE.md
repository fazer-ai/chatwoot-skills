# Metrics Reference

## Core Metrics

### First Response Time (FRT)

**Definition**: Time elapsed from when a conversation is created until the first agent (non-bot) reply.

**Measured in**: Seconds

**How it's calculated**:

- Clock starts at `conversation.created_at`
- Clock stops at first `outgoing` message from an agent (not bot, not private note)
- Only counts business hours if configured

**Interpretation**:

- < 1 minute: Excellent (typically bot-assisted)
- < 5 minutes: Good
- < 30 minutes: Acceptable
- \> 1 hour: Needs improvement

### Resolution Time (RT)

**Definition**: Time from conversation creation to when status changes to `resolved`.

**Measured in**: Seconds

**How it's calculated**:

- Clock starts at `conversation.created_at`
- Clock stops at `conversation.status` → `resolved`
- If reopened and re-resolved, uses the latest resolution

**Interpretation**:

- < 1 hour: Excellent (simple queries)
- < 4 hours: Good
- < 24 hours: Acceptable for complex issues
- \> 24 hours: May indicate process issues

### Conversations Count

Broken down by:

- **Created**: New conversations in period
- **Resolved**: Conversations resolved in period
- **Open**: Currently open at end of period

### Agent Metrics

Per-agent measurements:

- `conversations_count` — Total conversations assigned
- `avg_first_response_time` — Mean FRT across conversations
- `avg_resolution_time` — Mean RT across conversations
- `resolved_conversations_count` — Number resolved by agent

### Inbox Metrics

Per-inbox (channel) measurements:

- Same metrics as agent but grouped by source inbox
- Useful for comparing channel performance (email vs chat vs API)

### Team Metrics

Per-team measurements:

- Same metrics grouped by team
- Helps identify overloaded or underperforming teams

### Label Metrics

Per-label measurements:

- Groups conversations by applied labels
- Useful for tracking issue categories (e.g., "billing" label → billing issue volume and resolution time)

## Derived Insights

### Agent Workload Balance

Compare `conversations_count` across agents. High variance suggests uneven distribution.

```
reports_v2_agents → sort by conversations_count
If max/min ratio > 3:1 → Consider rebalancing assignments
```

### Channel Efficiency

Compare per-inbox FRT and RT:

```
reports_v2_inboxes → compare avg_first_response_time
If chat FRT >> email FRT → May need more chat agents
```

### SLA Compliance

Calculate percentage of conversations meeting SLA targets:

```
Total resolved in period: reports_v2_overview → resolved_conversations_count
Filter those within SLA: conversations_filter with time conditions
Compliance = (within_SLA / total_resolved) × 100
```

### Trending Issues

Use label reports to identify volume trends:

```
Week 1: reports_v2_labels(since: week1_start, until: week1_end) → "billing": 20
Week 2: reports_v2_labels(since: week2_start, until: week2_end) → "billing": 35
→ 75% increase in billing issues
```
