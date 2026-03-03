---
name: chatwoot-conversation-management
description: Manage Chatwoot conversations — create, filter, assign, toggle status and priority, label, send messages, and build conversation workflows. Use when working with conversations, messages, assignments, or conversation lifecycle.
---

# Chatwoot Conversation Management

Master guide for managing conversations end-to-end using mcp-chatwoot MCP tools.

## Conversation Lifecycle

Conversations flow through these statuses:

```
             ┌──────────┐
    New ────►│   OPEN   │◄──── Reopen
             └────┬─────┘
                  │
         ┌───────┼───────┐
         ▼       ▼       ▼
    ┌─────────┐ ┌──────┐ ┌─────────┐
    │ PENDING │ │SNOOZED│ │RESOLVED │
    └─────────┘ └──────┘ └─────────┘
         │       │              │
         └───────┴──────────────┘
                  │
             Back to OPEN
```

### Status meanings

| Status     | Meaning                 | Typical use                            |
| ---------- | ----------------------- | -------------------------------------- |
| `open`     | Active, needs attention | New or reopened conversations          |
| `pending`  | Waiting on customer     | Agent asked a question, awaiting reply |
| `snoozed`  | Temporarily hidden      | Will resurface at a set time           |
| `resolved` | Complete, closed        | Issue resolved                         |

### Changing status

```
conversations_toggle_status(
  account_id: 1,
  conversation_id: 42,
  status: "resolved"
)
```

Valid values: `"open"`, `"resolved"`, `"pending"`, `"snoozed"`

## Priority Levels

| Priority | When to use               |
| -------- | ------------------------- |
| `none`   | Default, no urgency       |
| `low`    | Can wait                  |
| `medium` | Normal priority           |
| `high`   | Needs attention soon      |
| `urgent` | Immediate action required |

```
conversations_toggle_priority(
  account_id: 1,
  conversation_id: 42,
  priority: "high"
)
```

## Creating Conversations

```
conversations_create(
  account_id: 1,
  contact_id: 100,
  inbox_id: 5,
  message: {
    content: "Hello, how can I help you?"
  },
  status: "open"
)
```

Required: `contact_id` + `inbox_id` (or `source_id` for channel-specific creation).

## Messages

### Sending a message

```
messages_create(
  account_id: 1,
  conversation_id: 42,
  content: "Thanks for reaching out! Let me look into this.",
  message_type: "outgoing",
  private: false
)
```

### Message types

| Type       | Direction        | Use case                                     |
| ---------- | ---------------- | -------------------------------------------- |
| `outgoing` | Agent → Customer | Standard reply                               |
| `incoming` | Customer → Agent | Simulate customer message (testing, imports) |
| `activity` | System           | Internal activity note                       |

### Private notes

Set `private: true` to create an internal note visible only to agents:

```
messages_create(
  account_id: 1,
  conversation_id: 42,
  content: "Customer seems upset, escalating to senior agent.",
  message_type: "outgoing",
  private: true
)
```

### Reading message history

```
messages_list(
  account_id: 1,
  conversation_id: 42
)
```

## Assignments

### Assign to agent

```
conversation_assignments_assign(
  account_id: 1,
  conversation_id: 42,
  assignee_id: 7
)
```

### Assign to team

```
conversation_assignments_assign(
  account_id: 1,
  conversation_id: 42,
  team_id: 3
)
```

### Unassign

Set `assignee_id: 0` to remove the agent assignment.

## Labels

Labels are string tags applied to conversations for categorization.

### Get current labels

```
conversations_get_labels(account_id: 1, conversation_id: 42)
→ ["bug", "urgent"]
```

### Set labels (replaces all)

```
conversations_set_labels(
  account_id: 1,
  conversation_id: 42,
  labels: ["bug", "urgent", "reviewed"]
)
```

**⚠️ Important**: This REPLACES all labels. To add a label, read first, merge, then set.

### Add-label pattern

```
1. conversations_get_labels → ["bug", "urgent"]
2. Append new label → ["bug", "urgent", "reviewed"]
3. conversations_set_labels(labels: ["bug", "urgent", "reviewed"])
```

## Custom Attributes

Set arbitrary key-value data on conversations:

```
conversations_set_custom_attributes(
  account_id: 1,
  conversation_id: 42,
  custom_attributes: {
    "product": "Enterprise Plan",
    "ticket_ref": "JIRA-1234",
    "sentiment": "negative"
  }
)
```

Custom attribute definitions must exist first (see admin-configuration skill).

## Filtering Conversations

### Basic listing by status

```
conversations_list(
  account_id: 1,
  status: "open",
  assignee_type: "unassigned",
  page: 1
)
```

### Advanced filtering

```
conversations_filter(
  account_id: 1,
  payload: [
    {
      "attribute_key": "status",
      "filter_operator": "equal_to",
      "values": ["open"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "priority",
      "filter_operator": "equal_to",
      "values": ["high", "urgent"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "team_id",
      "filter_operator": "equal_to",
      "values": [3],
      "query_operator": null
    }
  ]
)
```

See the mcp-tools-expert skill's `SEARCH_GUIDE.md` for full filter syntax reference.

### Get conversation counts

```
conversations_meta(account_id: 1)
→ { open: 45, resolved: 1230, pending: 12, snoozed: 3, ... }
```

## Common Workflow Patterns

See `WORKFLOW_PATTERNS.md` for detailed patterns including triage, escalation, and bulk operations.

See `EXAMPLES.md` for real-world scenario walkthroughs.
