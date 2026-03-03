# Chatwoot Setup Guide

Step-by-step guides for common Chatwoot setup tasks.

## Complete Setup: New Support Team

Set up a new team with agents, inbox, and automation from scratch.

```
Step 1: Get account info
  profile_get → account_id: 1

Step 2: Create the team
  teams_create(account_id: 1, name: "Technical Support",
    description: "Handles technical issues and bug reports")
  → team_id: 5

Step 3: Find or create agents
  agents_list(account_id: 1) → [{ id: 3, name: "Alice" }, { id: 7, name: "Bob" }]

  # Or create new:
  agents_create(account_id: 1, name: "Charlie Davis",
    email: "charlie@company.com", role: "agent")
  → agent_id: 12

Step 4: Add agents to team
  team_members_add(account_id: 1, team_id: 5, user_ids: [3, 7, 12])

Step 5: Create inbox
  inboxes_create(account_id: 1, name: "Tech Support Email",
    channel: { type: "api", webhook_url: "https://app.com/webhook" })
  → inbox_id: 8

Step 6: Assign agents to inbox
  inbox_members_create(account_id: 1, inbox_id: 8, user_ids: [3, 7, 12])

Step 7: Create canned responses
  canned_responses_create(account_id: 1,
    short_code: "tech_greeting",
    content: "Thanks for reaching out to our technical support team. Let me look into this for you.")

  canned_responses_create(account_id: 1,
    short_code: "tech_escalate",
    content: "I'm going to escalate this to our engineering team for a closer look. You'll hear back within 24 hours.")

Step 8: Set up automation rule for routing
  automation_rules_create(account_id: 1,
    name: "Route tech conversations",
    description: "Auto-assign conversations from tech inbox to tech team",
    event_name: "conversation_created",
    conditions: [
      { attribute_key: "inbox_id", filter_operator: "equal_to", values: [8] }
    ],
    actions: [
      { action_name: "assign_team", action_params: [5] }
    ])

Step 9: Create webhook for notifications
  webhooks_create(account_id: 1,
    url: "https://app.com/notifications",
    subscriptions: ["conversation_created", "message_created"])
```

## Setup: Custom Attribute System

Define a structured data model for contacts and conversations.

```
Step 1: Define contact attributes
  custom_attributes_create(account_id: 1,
    attribute_display_name: "Company",
    attribute_display_type: "text",
    attribute_key: "company",
    attribute_model: "contact_attribute")

  custom_attributes_create(account_id: 1,
    attribute_display_name: "Plan",
    attribute_display_type: "list",
    attribute_key: "plan",
    attribute_model: "contact_attribute",
    attribute_values: ["free", "starter", "professional", "enterprise"])

  custom_attributes_create(account_id: 1,
    attribute_display_name: "MRR",
    attribute_display_type: "number",
    attribute_key: "mrr",
    attribute_model: "contact_attribute")

Step 2: Define conversation attributes
  custom_attributes_create(account_id: 1,
    attribute_display_name: "Ticket Reference",
    attribute_display_type: "text",
    attribute_key: "ticket_ref",
    attribute_model: "conversation_attribute")

  custom_attributes_create(account_id: 1,
    attribute_display_name: "Severity",
    attribute_display_type: "list",
    attribute_key: "severity",
    attribute_model: "conversation_attribute",
    attribute_values: ["low", "medium", "high", "critical"])

Step 3: Create saved filters using custom attributes
  custom_filters_create(account_id: 1,
    name: "Enterprise Contacts",
    filter_type: "contact",
    query: { payload: [
      { attribute_key: "plan", filter_operator: "equal_to", values: ["enterprise"], query_operator: null }
    ]})

  custom_filters_create(account_id: 1,
    name: "Critical Conversations",
    filter_type: "conversation",
    query: { payload: [
      { attribute_key: "severity", filter_operator: "equal_to", values: ["critical"], query_operator: "AND" },
      { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: null }
    ]})
```

## Setup: Multi-Team Routing

Configure multiple teams with distinct responsibilities.

```
Step 1: Create teams
  teams_create(name: "Sales") → team_id: 1
  teams_create(name: "Billing") → team_id: 2
  teams_create(name: "Technical") → team_id: 3
  teams_create(name: "Escalations") → team_id: 4

Step 2: Create inboxes per channel
  inboxes_create(name: "Website Chat", channel: { type: "api" }) → inbox_id: 10
  inboxes_create(name: "Email Support", channel: { type: "api" }) → inbox_id: 11

Step 3: Assign agents to teams based on role
  team_members_add(team_id: 1, user_ids: [sales_agent_ids...])
  team_members_add(team_id: 2, user_ids: [billing_agent_ids...])
  team_members_add(team_id: 3, user_ids: [tech_agent_ids...])
  team_members_add(team_id: 4, user_ids: [senior_agent_ids...])

Step 4: Create label-based routing rules
  automation_rules_create(name: "Route billing",
    event_name: "conversation_created",
    conditions: [{ attribute_key: "content", filter_operator: "contains", values: ["billing", "invoice", "payment"] }],
    actions: [{ action_name: "assign_team", action_params: [2] }])
```
