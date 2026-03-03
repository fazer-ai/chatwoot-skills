# Reporting Examples

## Example 1: Weekly Team Performance Summary

**Scenario**: Generate a summary of how the support team performed last week.

```
1. profile_get → account_id: 1

2. Get real-time snapshot
   reports_account_overview(account_id: 1)
   → { open_conversations: 23, pending: 5, unattended: 2, agents_online: 4 }

3. Get weekly summary (V2 for detail)
   reports_v2_overview(account_id: 1,
     since: "<monday_unix>", until: "<sunday_unix>", timezone: "America/New_York")
   → { conversations_count: 156, avg_first_response_time: 180, avg_resolution_time: 7200, resolved: 142 }

4. Get per-agent breakdown
   reports_v2_agents(account_id: 1,
     since: "<monday_unix>", until: "<sunday_unix>", timezone: "America/New_York")
   → [{ agent: "Alice", conversations: 45, avg_frt: 120 }, { agent: "Bob", conversations: 38, avg_frt: 240 }, ...]

5. Summarize:
   "Last week: 156 conversations, 142 resolved (91% resolution rate).
    Average first response: 3 minutes. Average resolution: 2 hours.
    Top performer: Alice (45 convos, 2-min FRT).
    Needs attention: 2 currently unattended conversations."
```

## Example 2: Identify Slowest Inboxes

**Scenario**: Find which communication channels have the worst response times.

```
1. profile_get → account_id: 1

2. reports_v2_inboxes(account_id: 1,
     since: "<month_start_unix>", until: "<month_end_unix>", timezone: "UTC")
   → [
       { inbox: "Website Chat", avg_frt: 60, avg_rt: 3600, count: 200 },
       { inbox: "Email Support", avg_frt: 900, avg_rt: 28800, count: 150 },
       { inbox: "API Channel", avg_frt: 30, avg_rt: 1800, count: 50 }
     ]

3. Analysis:
   "Email Support has 15-minute average FRT (vs 1-minute for chat).
    Consider adding more agents to email inbox or setting up auto-acknowledgment."

4. Check email inbox members
   inboxes_list(account_id: 1) → find email inbox_id
   inbox_members_list(account_id: 1, inbox_id: <email_inbox_id>)
   → only 2 agents assigned

5. Recommendation: Add more agents to email inbox
```

## Example 3: Agent Workload Analysis

**Scenario**: Determine if workload is evenly distributed.

```
1. profile_get → account_id: 1

2. reports_v2_agents(account_id: 1,
     since: "<week_start>", until: "<week_end>", timezone: "UTC")
   → [
       { agent: "Alice", conversations: 52, resolved: 48, avg_frt: 90 },
       { agent: "Bob", conversations: 15, resolved: 14, avg_frt: 300 },
       { agent: "Charlie", conversations: 48, resolved: 40, avg_frt: 120 }
     ]

3. Analysis:
   "Alice: 52 conversations (highest load, fast FRT)
    Bob: 15 conversations (significantly under-loaded, slow FRT)
    Charlie: 48 conversations (balanced)

    Bob has 3.5x fewer conversations than Alice. Consider:
    - Checking Bob's inbox assignments
    - Reviewing auto-assignment rules
    - Checking if Bob is online during peak hours"

4. Verify Bob's team/inbox assignments
   agents_list(account_id: 1) → find Bob's agent_id
   teams_list(account_id: 1) → check team memberships
```
