# Integration Patterns

## Webhook Payloads

> **Full reference**: See `WEBHOOK_PAYLOADS.md` for complete payload structures with real examples for all 8+ event types.

### Key facts

- Payloads are **flat** — fields at top level, NO `data` wrapper
- In conversation payloads, the `id` field IS `display_id` — use it directly for API calls
- `message_type` is a string at top level ("incoming"), but integer inside `conversation.messages[]` (0=incoming)
- `sender` in message events is a Contact (incoming) or User (outgoing)
- Contact events only go to account-level webhooks, not API inbox webhooks

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
