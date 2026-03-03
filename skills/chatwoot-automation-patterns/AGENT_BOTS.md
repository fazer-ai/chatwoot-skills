# Agent Bots Guide

## What Are Agent Bots?

Agent bots are automated agents that can:

- Respond to messages within an inbox
- Receive webhook notifications for conversation events
- Process messages via an external URL endpoint

They are NOT chat widgets — they are backend integrations that respond programmatically.

## Creating a Bot

```
agent_bots_create(
  account_id: 1,
  name: "Support Bot",
  description: "Handles initial greeting and FAQ responses",
  outgoing_url: "https://your-app.com/chatwoot-bot"
)
→ { id: 2, name: "Support Bot", access_token: "bot_abc123..." }
```

**Key**: Save the `access_token` — the bot uses it to authenticate API calls back to Chatwoot.

## Attaching to an Inbox

A bot must be attached to an inbox to process messages:

```
inboxes_set_agent_bot(account_id: 1, id: 5, agent_bot_id: 2)
```

### Check current bot on inbox

```
inboxes_get_agent_bot(account_id: 1, id: 5)
→ { id: 2, name: "Support Bot" } | null
```

### Remove bot from inbox

```
inboxes_set_agent_bot(account_id: 1, id: 5, agent_bot_id: null)
```

## How Bots Receive Messages

When a message arrives in the bot's inbox, Chatwoot sends a POST webhook to the bot's `outgoing_url`:

```json
{
  "event": "message_created",
  "content": "I need help with my order",
  "conversation": {
    "id": 42,
    "inbox_id": 5,
    "contact_id": 100,
    "status": "open"
  },
  "sender": {
    "id": 100,
    "name": "Customer Name"
  }
}
```

## Bot Response Patterns

### Simple greeting bot

Bot endpoint logic:

1. On `conversation_created` → Send welcome message
2. On `message_created` → Analyze content, respond or handoff

### FAQ bot

Bot endpoint logic:

1. Receive message content
2. Match against FAQ database
3. If match found → Reply with answer
4. If no match → Assign to human team

### Data collection bot

Bot endpoint logic:

1. Send initial question ("What's your order number?")
2. Collect responses sequentially
3. When all data collected → Set custom attributes on conversation
4. Handoff to human agent with context

## Managing Bots

### List all bots

```
agent_bots_list(account_id: 1)
```

### Update bot

```
agent_bots_update(account_id: 1, id: 2,
  name: "Updated Bot Name",
  outgoing_url: "https://new-url.com/bot")
```

### Delete bot

```
agent_bots_delete(account_id: 1, id: 2)
```

**⚠️ Warning**: Deleting a bot that's attached to an inbox will disconnect it. Detach first with `inboxes_set_agent_bot` if you want to keep the inbox operational.
