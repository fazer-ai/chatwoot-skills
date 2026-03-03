---
name: chatwoot-admin-configuration
description: Configure Chatwoot — manage teams, agents, inboxes, webhooks, automation rules, canned responses, custom attributes, and custom filters. Use when setting up, administering, or configuring a Chatwoot instance.
---

# Chatwoot Admin Configuration

Guide for setting up and managing Chatwoot infrastructure using mcp-chatwoot MCP tools.

## Entity Relationships

```
Account
├── Agents (support staff)
├── Teams (groups of agents)
│   └── Team Members (agents in team)
├── Inboxes (communication channels)
│   ├── Inbox Members (agents handling this inbox)
│   └── Agent Bot (optional bot per inbox)
├── Automation Rules (event-driven actions)
├── Canned Responses (message templates)
├── Custom Attributes (data field definitions)
├── Custom Filters (saved query presets)
└── Webhooks (external notifications)
```

## Teams

### Create a team

```
teams_create(
  account_id: 1,
  name: "Billing Support",
  description: "Handles billing and payment inquiries"
)
→ { id: 3, name: "Billing Support" }
```

### Add agents to team

```
agents_list(account_id: 1)
→ Find agent IDs: [5, 7, 12]

team_members_add(
  account_id: 1,
  team_id: 3,
  user_ids: [5, 7, 12]
)
```

### Remove agents from team

```
team_members_delete(
  account_id: 1,
  team_id: 3,
  user_ids: [12]
)
```

## Agents

### Create an agent

```
agents_create(
  account_id: 1,
  name: "Alice Johnson",
  email: "alice@company.com",
  role: "agent"
)
```

Roles: `"agent"` (standard) or `"administrator"` (full access).

### List all agents

```
agents_list(account_id: 1)
→ [{ id: 5, name: "Alice", role: "agent" }, ...]
```

## Inboxes

Inboxes represent communication channels (email, web chat, API, WhatsApp, etc.).

### Create an inbox

Inbox creation varies by channel type. The `channel` parameter determines the required fields.

**API channel** (most common for programmatic use):

```
inboxes_create(
  account_id: 1,
  name: "API Channel",
  channel: {
    type: "api",
    webhook_url: "https://your-app.com/webhook"
  }
)
```

### Assign agents to inbox

```
inbox_members_create(
  account_id: 1,
  inbox_id: 5,
  user_ids: [5, 7]
)
```

### Attach bot to inbox

```
inboxes_set_agent_bot(
  account_id: 1,
  id: 5,
  agent_bot_id: 2
)
```

## Canned Responses

Reusable message templates that agents can quickly insert.

### Create a canned response

```
canned_responses_create(
  account_id: 1,
  short_code: "greeting",
  content: "Hello! Thanks for reaching out. How can I help you today?"
)
```

Agents type `/greeting` in the chat to insert this response.

### List and search

```
canned_responses_list(account_id: 1, search: "greeting")
```

## Custom Attributes

Define custom data fields for conversations or contacts.

### Create a custom attribute

```
custom_attributes_create(
  account_id: 1,
  attribute_display_name: "Plan Type",
  attribute_display_type: "list",
  attribute_description: "Customer's subscription plan",
  attribute_key: "plan_type",
  attribute_model: "conversation_attribute"
)
```

**`attribute_model`**: `"conversation_attribute"` or `"contact_attribute"`

**`attribute_display_type`**: `"text"`, `"number"`, `"link"`, `"date"`, `"list"`, `"checkbox"`

### List definitions

```
custom_attributes_list(account_id: 1, attribute_model: "contact_attribute")
```

## Custom Filters

Saved search presets for conversations or contacts.

### Create a saved filter

```
custom_filters_create(
  account_id: 1,
  name: "Urgent Unassigned",
  filter_type: "conversation",
  query: {
    "payload": [
      { "attribute_key": "priority", "filter_operator": "equal_to", "values": ["urgent"], "query_operator": "AND" },
      { "attribute_key": "assignee_id", "filter_operator": "is_not_present", "values": [], "query_operator": null }
    ]
  }
)
```

**`filter_type`**: `"conversation"` or `"contact"`

## Webhooks

Receive HTTP notifications when events occur in Chatwoot.

### Create a webhook

```
webhooks_create(
  account_id: 1,
  url: "https://your-app.com/chatwoot-webhook",
  subscriptions: [
    "conversation_created",
    "conversation_status_changed",
    "message_created",
    "message_updated"
  ]
)
```

### Available webhook events

| Event                         | Description           |
| ----------------------------- | --------------------- |
| `conversation_created`        | New conversation      |
| `conversation_status_changed` | Status toggled        |
| `conversation_updated`        | Conversation modified |
| `message_created`             | New message           |
| `message_updated`             | Message edited        |
| `contact_created`             | New contact           |
| `contact_updated`             | Contact modified      |
| `webwidget_triggered`         | Widget event          |

## Automation Rules

See the `chatwoot-automation-patterns` skill for comprehensive automation rule configuration.

See `SETUP_GUIDE.md` for step-by-step setup walkthroughs.

See `AUTOMATION_RULES.md` for automation rule syntax reference.
