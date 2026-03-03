---
name: chatwoot-automation-patterns
description: Build Chatwoot automations — agent bots, automation rules, webhook integrations, and workflow patterns. Use when automating support operations, setting up bots, creating event-driven workflows, or integrating external services.
---

# Chatwoot Automation Patterns

Guide for building automated workflows using Chatwoot's automation tools.

## Automation Building Blocks

| Tool                  | Purpose                      | When to use                              |
| --------------------- | ---------------------------- | ---------------------------------------- |
| **Automation Rules**  | Event → conditions → actions | Simple routing, labeling, status changes |
| **Agent Bots**        | Programmable bot per inbox   | Custom bot logic, API-driven responses   |
| **Webhooks**          | Notify external services     | Integrate with 3rd party systems         |
| **Integration Hooks** | App-level integrations       | Connect Chatwoot apps                    |

## Pattern 1: Auto-Assignment

### Round-robin by team

Automatically distribute new conversations across team members:

```
automation_rules_create(
  account_id: 1,
  name: "Round-robin assignment",
  description: "Distribute new conversations to team members equally",
  event_name: "conversation_created",
  conditions: [
    { "attribute_key": "inbox_id", "filter_operator": "equal_to", "values": [5], "query_operator": null }
  ],
  actions: [
    { "action_name": "assign_team", "action_params": [3] }
  ]
)
```

When a team is assigned, Chatwoot's internal round-robin distributes to team members.

### Direct agent assignment

For specific routing (e.g., VIP customers to senior agent):

```
automation_rules_create(
  account_id: 1,
  name: "VIP direct assignment",
  event_name: "conversation_created",
  conditions: [
    { "attribute_key": "email", "filter_operator": "contains", "values": ["@vip-client.com"], "query_operator": null }
  ],
  actions: [
    { "action_name": "assign_agent", "action_params": [7] },
    { "action_name": "change_priority", "action_params": ["high"] },
    { "action_name": "add_label", "action_params": ["vip"] }
  ]
)
```

## Pattern 2: SLA-Based Escalation

### Programmatic escalation

Since automation rules can't time-trigger, use Claude + MCP tools for periodic checks:

```
Step 1: Find overdue conversations
  conversations_filter(account_id: 1, payload: [
    { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
    { attribute_key: "created_at", filter_operator: "days_before", values: [1], query_operator: null }
  ])

Step 2: Check first response
  For each: messages_list(account_id: 1, conversation_id: <id>)
  If no outgoing message → SLA breached

Step 3: Escalate
  conversations_toggle_priority(account_id: 1, conversation_id: <id>, priority: "urgent")
  conversation_assignments_assign(account_id: 1, conversation_id: <id>, team_id: <escalation_team>)
  messages_create(account_id: 1, conversation_id: <id>,
    content: "⚠️ SLA Alert: No first response within 24 hours",
    message_type: "outgoing", private: true)
```

## Pattern 3: Channel Routing

Route conversations based on their source inbox:

```
# Chat → immediate response team
automation_rules_create(name: "Route chat",
  event_name: "conversation_created",
  conditions: [{ attribute_key: "inbox_id", filter_operator: "equal_to", values: [<chat_inbox_id>] }],
  actions: [{ action_name: "assign_team", action_params: [<realtime_team_id>] }])

# Email → async team
automation_rules_create(name: "Route email",
  event_name: "conversation_created",
  conditions: [{ attribute_key: "inbox_id", filter_operator: "equal_to", values: [<email_inbox_id>] }],
  actions: [{ action_name: "assign_team", action_params: [<email_team_id>] }])
```

## Pattern 4: Bot-to-Human Handoff

### Setting up the bot

```
1. Create the bot
   agent_bots_create(account_id: 1,
     name: "Welcome Bot",
     description: "Greets customers and collects initial info",
     outgoing_url: "https://your-app.com/bot-webhook")
   → agent_bot_id: 2

2. Attach to inbox
   inboxes_set_agent_bot(account_id: 1, id: 5, agent_bot_id: 2)
```

### Handoff flow

The bot's webhook endpoint should:

1. Handle incoming messages
2. Collect required information
3. When ready for handoff: update conversation to remove bot assignment

On the Chatwoot side, create a rule for handoff:

```
automation_rules_create(name: "Bot handoff",
  event_name: "conversation_updated",
  conditions: [
    { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
    { attribute_key: "inbox_id", filter_operator: "equal_to", values: [5], query_operator: null }
  ],
  actions: [
    { action_name: "assign_team", action_params: [<human_team_id>] }
  ])
```

### Detach bot from inbox

```
inboxes_set_agent_bot(account_id: 1, id: 5, agent_bot_id: null)
```

## Pattern 5: Webhook-Driven Integration

### External notification system

```
1. Create webhook
   webhooks_create(account_id: 1,
     url: "https://your-app.com/chatwoot-events",
     subscriptions: [
       "conversation_created",
       "conversation_status_changed",
       "message_created"
     ])

2. Your endpoint receives POST requests with event data:
   {
     "event": "conversation_created",
     "data": { "id": 42, "inbox_id": 5, "contact": {...}, ... }
   }
```

### Common integrations via webhooks

| Integration         | Webhook events                            | Action at endpoint           |
| ------------------- | ----------------------------------------- | ---------------------------- |
| Slack notifications | `conversation_created`, `message_created` | Post to Slack channel        |
| CRM sync            | `contact_created`, `contact_updated`      | Update CRM records           |
| Issue tracker       | `conversation_created` + label filter     | Create ticket in Jira/Linear |
| Analytics           | All events                                | Log to analytics platform    |
| SLA monitoring      | `conversation_created`                    | Start SLA timer              |

## Pattern 6: Content-Based Categorization

Auto-label conversations based on message content:

```
automation_rules_create(name: "Detect billing issues",
  event_name: "message_created",
  conditions: [
    { attribute_key: "content", filter_operator: "contains",
      values: ["billing", "invoice", "charge", "refund", "payment"], query_operator: null }
  ],
  actions: [
    { action_name: "add_label", action_params: ["billing"] },
    { action_name: "assign_team", action_params: [<billing_team_id>] }
  ])

automation_rules_create(name: "Detect technical issues",
  event_name: "message_created",
  conditions: [
    { attribute_key: "content", filter_operator: "contains",
      values: ["bug", "error", "crash", "broken", "not working"], query_operator: null }
  ],
  actions: [
    { action_name: "add_label", action_params: ["technical"] },
    { action_name: "change_priority", action_params: ["high"] }
  ])
```

See `AGENT_BOTS.md` for detailed bot setup guide.

See `INTEGRATION_PATTERNS.md` for webhook payload formats and integration recipes.

See `EXAMPLES.md` for end-to-end automation scenarios.
