# Integration Patterns

## Webhook Payloads

### conversation_created

```json
{
  "event": "conversation_created",
  "data": {
    "id": 42,
    "display_id": 42,
    "inbox_id": 5,
    "status": "open",
    "contact": {
      "id": 100,
      "name": "Jane Smith",
      "email": "jane@example.com"
    },
    "assignee": null,
    "team": null,
    "labels": [],
    "custom_attributes": {}
  }
}
```

### message_created

```json
{
  "event": "message_created",
  "data": {
    "id": 1234,
    "content": "I need help with billing",
    "message_type": "incoming",
    "conversation_id": 42,
    "sender": {
      "id": 100,
      "name": "Jane Smith",
      "type": "contact"
    },
    "created_at": "2026-01-15T10:30:00.000Z"
  }
}
```

### conversation_status_changed

```json
{
  "event": "conversation_status_changed",
  "data": {
    "id": 42,
    "status": "resolved",
    "previous_status": "open",
    "assignee": { "id": 5, "name": "Agent Alice" }
  }
}
```

## Integration Hooks

For deeper Chatwoot integrations using the integrations system:

### List available apps

```
integrations_list_apps(account_id: 1)
→ [{ id: "slack", name: "Slack" }, { id: "webhooks", name: "Webhooks" }, ...]
```

### Create integration hook

```
integrations_create_hook(
  account_id: 1,
  app_id: "slack",
  inbox_id: 5,
  settings: {
    "channel": "#support-alerts"
  }
)
```

### Update hook settings

```
integrations_update_hook(account_id: 1, hook_id: 10, settings: { "channel": "#new-channel" })
```

### Delete hook

```
integrations_delete_hook(account_id: 1, hook_id: 10)
```

## Common Integration Recipes

### Recipe: Slack Alert on New Conversation

```
webhooks_create(account_id: 1,
  url: "https://your-middleware.com/slack-notify",
  subscriptions: ["conversation_created"])
```

Your middleware receives the webhook and posts to Slack:

```
New conversation #42 from Jane Smith (jane@example.com)
Channel: Website Chat | Status: Open
```

### Recipe: CRM Contact Sync

```
webhooks_create(account_id: 1,
  url: "https://your-middleware.com/crm-sync",
  subscriptions: ["contact_created", "contact_updated"])
```

Your middleware:

1. Receives contact data from Chatwoot
2. Creates/updates contact in CRM (Salesforce, HubSpot, etc.)
3. Optionally syncs back: call `contacts_update` with CRM ID as `identifier`

### Recipe: Auto-Create Ticket in Issue Tracker

```
webhooks_create(account_id: 1,
  url: "https://your-middleware.com/ticket-create",
  subscriptions: ["conversation_created"])
```

Your middleware:

1. Receives new conversation data
2. Checks if label includes "bug-report"
3. Creates ticket in Jira/Linear/GitHub Issues
4. Calls `conversations_set_custom_attributes` with ticket reference

### Recipe: CSAT Survey After Resolution

```
webhooks_create(account_id: 1,
  url: "https://your-middleware.com/csat-trigger",
  subscriptions: ["conversation_status_changed"])
```

Your middleware:

1. Checks if new status is "resolved"
2. Waits 5 minutes
3. Sends CSAT survey email via your email service
4. Records response back to contact custom attributes
