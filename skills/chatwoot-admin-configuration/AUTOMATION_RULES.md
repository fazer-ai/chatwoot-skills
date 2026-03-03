# Automation Rules Reference

## Rule Structure

Every automation rule has:

1. **Event** — What triggers the rule
2. **Conditions** — When to apply (optional filters)
3. **Actions** — What to do when triggered

```
automation_rules_create(
  account_id: 1,
  name: "Rule name",
  description: "What this rule does",
  event_name: "<event>",
  conditions: [<condition>, ...],
  actions: [<action>, ...]
)
```

## Events

| Event                  | Triggers when                |
| ---------------------- | ---------------------------- |
| `conversation_created` | New conversation is created  |
| `conversation_updated` | Conversation is modified     |
| `message_created`      | New message is sent/received |

## Condition Schema

```json
{
  "attribute_key": "<field>",
  "filter_operator": "<operator>",
  "values": ["<value>"],
  "query_operator": "AND" | "OR" | null
}
```

### Condition attributes for conversations

| attribute_key      | Description                                            |
| ------------------ | ------------------------------------------------------ |
| `status`           | Conversation status (open, pending, resolved, snoozed) |
| `inbox_id`         | Source inbox ID                                        |
| `team_id`          | Assigned team ID                                       |
| `priority`         | Priority level                                         |
| `assignee_id`      | Assigned agent ID                                      |
| `content`          | Message content (for `message_created` event)          |
| `email`            | Contact's email                                        |
| `country_code`     | Contact's country                                      |
| `browser_language` | Contact's browser language                             |
| Custom attributes  | Any custom attribute key                               |

### Condition operators

| Operator           | Use with                     |
| ------------------ | ---------------------------- |
| `equal_to`         | Text, number, list           |
| `not_equal_to`     | Text, number, list           |
| `contains`         | Text fields, message content |
| `does_not_contain` | Text fields                  |
| `is_present`       | Any field                    |
| `is_not_present`   | Any field                    |

## Action Schema

```json
{
  "action_name": "<action_type>",
  "action_params": [<params>]
}
```

### Available actions

| action_name          | action_params                             | Description                |
| -------------------- | ----------------------------------------- | -------------------------- |
| `assign_team`        | `[team_id]`                               | Assign to team             |
| `assign_agent`       | `[agent_id]`                              | Assign to specific agent   |
| `add_label`          | `["label_name"]`                          | Add label to conversation  |
| `remove_label`       | `["label_name"]`                          | Remove label               |
| `send_email_to_team` | `[{ "team_ids": [1], "message": "..." }]` | Email notification to team |
| `send_message`       | `["message content"]`                     | Send auto-reply            |
| `change_status`      | `["resolved"]`                            | Change conversation status |
| `change_priority`    | `["high"]`                                | Change priority            |
| `mute_conversation`  | `[]`                                      | Mute notifications         |
| `send_webhook_event` | `["https://url"]`                         | Trigger webhook            |
| `send_attachment`    | `[file_details]`                          | Send file                  |

## Example Rules

### Auto-assign by inbox

Route conversations from specific inboxes to corresponding teams:

```json
{
  "name": "Route email to email team",
  "event_name": "conversation_created",
  "conditions": [
    {
      "attribute_key": "inbox_id",
      "filter_operator": "equal_to",
      "values": [3],
      "query_operator": null
    }
  ],
  "actions": [{ "action_name": "assign_team", "action_params": [5] }]
}
```

### Auto-label by content

Add labels based on message content keywords:

```json
{
  "name": "Label billing conversations",
  "event_name": "message_created",
  "conditions": [
    {
      "attribute_key": "content",
      "filter_operator": "contains",
      "values": ["invoice", "billing", "payment"],
      "query_operator": null
    }
  ],
  "actions": [{ "action_name": "add_label", "action_params": ["billing"] }]
}
```

### Auto-reply to new conversations

Send an immediate acknowledgment:

```json
{
  "name": "Auto-acknowledge",
  "event_name": "conversation_created",
  "conditions": [],
  "actions": [
    {
      "action_name": "send_message",
      "action_params": [
        "Thanks for reaching out! An agent will be with you shortly."
      ]
    }
  ]
}
```

### Escalate high-priority

Notify escalation team when priority is set to urgent:

```json
{
  "name": "Escalate urgent",
  "event_name": "conversation_updated",
  "conditions": [
    {
      "attribute_key": "priority",
      "filter_operator": "equal_to",
      "values": ["urgent"],
      "query_operator": null
    }
  ],
  "actions": [
    { "action_name": "assign_team", "action_params": [4] },
    {
      "action_name": "send_email_to_team",
      "action_params": [
        { "team_ids": [4], "message": "Urgent conversation needs attention" }
      ]
    }
  ]
}
```
