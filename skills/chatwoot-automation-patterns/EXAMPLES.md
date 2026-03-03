# Automation Pattern Examples

## Example 1: Complete Auto-Assignment System

**Scenario**: Set up automatic conversation routing based on inbox, content, and VIP status.

```
1. profile_get → account_id: 1

2. Create teams
   teams_create(account_id: 1, name: "General Support") → team_id: 1
   teams_create(account_id: 1, name: "Billing") → team_id: 2
   teams_create(account_id: 1, name: "Technical") → team_id: 3
   teams_create(account_id: 1, name: "VIP") → team_id: 4

3. Create routing rules (order matters — first match wins)

   # VIP routing (highest priority)
   automation_rules_create(account_id: 1,
     name: "VIP routing",
     event_name: "conversation_created",
     conditions: [
       { attribute_key: "email", filter_operator: "contains", values: ["@vip-client.com"], query_operator: null }
     ],
     actions: [
       { action_name: "assign_team", action_params: [4] },
       { action_name: "change_priority", action_params: ["high"] },
       { action_name: "add_label", action_params: ["vip"] }
     ])

   # Billing keyword routing
   automation_rules_create(account_id: 1,
     name: "Billing routing",
     event_name: "message_created",
     conditions: [
       { attribute_key: "content", filter_operator: "contains", values: ["billing", "invoice", "payment", "refund"], query_operator: null }
     ],
     actions: [
       { action_name: "assign_team", action_params: [2] },
       { action_name: "add_label", action_params: ["billing"] }
     ])

   # Technical keyword routing
   automation_rules_create(account_id: 1,
     name: "Technical routing",
     event_name: "message_created",
     conditions: [
       { attribute_key: "content", filter_operator: "contains", values: ["bug", "error", "crash", "technical"], query_operator: null }
     ],
     actions: [
       { action_name: "assign_team", action_params: [3] },
       { action_name: "add_label", action_params: ["technical"] }
     ])

   # Default routing (catch-all)
   automation_rules_create(account_id: 1,
     name: "Default routing",
     event_name: "conversation_created",
     conditions: [],
     actions: [
       { action_name: "assign_team", action_params: [1] },
       { action_name: "send_message", action_params: ["Thanks for reaching out! An agent will be with you shortly."] }
     ])
```

## Example 2: Escalation Automation

**Scenario**: Auto-escalate conversations based on priority changes and SLA breaches.

```
1. Create escalation team
   teams_create(account_id: 1, name: "Escalations") → team_id: 5

2. Create rule for urgent priority
   automation_rules_create(account_id: 1,
     name: "Escalate urgent",
     event_name: "conversation_updated",
     conditions: [
       { attribute_key: "priority", filter_operator: "equal_to", values: ["urgent"], query_operator: null }
     ],
     actions: [
       { action_name: "assign_team", action_params: [5] },
       { action_name: "send_email_to_team", action_params: [{ team_ids: [5], message: "Urgent conversation needs immediate attention" }] }
     ])

3. Programmatic SLA check (run periodically with Claude):
   conversations_filter(account_id: 1, payload: [
     { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
     { attribute_key: "created_at", filter_operator: "days_before", values: [1], query_operator: "AND" },
     { attribute_key: "priority", filter_operator: "not_equal_to", values: ["urgent"], query_operator: null }
   ])

   For each overdue conversation:
   conversations_toggle_priority(account_id: 1, conversation_id: <id>, priority: "urgent")
   → This triggers the escalation rule above
```

## Example 3: Bot + Human Hybrid Support

**Scenario**: Set up a bot that handles initial greeting, then transfers to humans.

```
1. Create the bot
   agent_bots_create(account_id: 1,
     name: "Greeter Bot",
     description: "Initial greeting and info collection",
     outgoing_url: "https://your-app.com/greeter-bot")
   → agent_bot_id: 3

2. Attach to website chat inbox
   inboxes_list(account_id: 1) → find "Website Chat" inbox_id: 5
   inboxes_set_agent_bot(account_id: 1, id: 5, agent_bot_id: 3)

3. Create handoff automation
   automation_rules_create(account_id: 1,
     name: "Bot handoff to humans",
     event_name: "conversation_updated",
     conditions: [
       { attribute_key: "inbox_id", filter_operator: "equal_to", values: [5], query_operator: null }
     ],
     actions: [
       { action_name: "assign_team", action_params: [1] }
     ])

4. Create webhook for monitoring bot performance
   webhooks_create(account_id: 1,
     url: "https://your-app.com/bot-analytics",
     subscriptions: ["conversation_created", "message_created", "conversation_status_changed"])
```

## Example 4: Multi-Channel Notification Setup

**Scenario**: Set up comprehensive notifications for important events.

```
1. Create Slack webhook for new conversations
   webhooks_create(account_id: 1,
     url: "https://middleware.com/slack-new-conv",
     subscriptions: ["conversation_created"])

2. Create PagerDuty webhook for urgent issues
   webhooks_create(account_id: 1,
     url: "https://middleware.com/pagerduty-alert",
     subscriptions: ["conversation_status_changed"])

3. Create CRM sync webhook
   webhooks_create(account_id: 1,
     url: "https://middleware.com/crm-sync",
     subscriptions: ["contact_created", "contact_updated"])

4. List all webhooks to verify
   webhooks_list(account_id: 1)
   → Verify 3 webhooks created with correct URLs and subscriptions
```
