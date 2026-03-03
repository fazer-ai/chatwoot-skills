# Scheduled Messages Guide

## What Are Scheduled Messages?

Scheduled messages let you queue messages to be sent at a specific future time. The message is sent automatically by Chatwoot when the scheduled time arrives.

**Use cases**:

- Follow-up reminders after a set period
- Proactive check-ins after issue resolution
- Time-zone-aware messaging
- Marketing/engagement sequences
- SLA reminder notifications

## Creating Scheduled Messages

### Basic follow-up

```
scheduled_messages_create(
  account_id: 1,
  conversation_id: 42,
  content: "Hi! Just checking in — is everything working well now?",
  scheduled_at: "2026-01-20T10:00:00Z"
)
```

### Business hours follow-up

Schedule for the next business day at 9 AM:

```
scheduled_messages_create(
  account_id: 1,
  conversation_id: 42,
  content: "Good morning! Following up on your request from yesterday. Do you need any further assistance?",
  scheduled_at: "2026-01-21T09:00:00Z"
)
```

### Multi-step follow-up sequence

Create a series of follow-ups:

```
# Day 1: Initial check
scheduled_messages_create(account_id: 1, conversation_id: 42,
  content: "Hi! How's everything going with the solution we provided?",
  scheduled_at: "2026-01-20T10:00:00Z")

# Day 3: Second check
scheduled_messages_create(account_id: 1, conversation_id: 42,
  content: "Just following up — let us know if you need any further help!",
  scheduled_at: "2026-01-22T10:00:00Z")

# Day 7: Final check and close
scheduled_messages_create(account_id: 1, conversation_id: 42,
  content: "It's been a week since our last interaction. If everything is resolved, we'll close this conversation. Feel free to reopen anytime!",
  scheduled_at: "2026-01-26T10:00:00Z")
```

## Managing Scheduled Messages

### View pending messages

```
scheduled_messages_list(account_id: 1, conversation_id: 42)
→ [
    { id: 5, content: "Hi! How's everything...", scheduled_at: "2026-01-20T10:00:00Z" },
    { id: 6, content: "Just following up...", scheduled_at: "2026-01-22T10:00:00Z" },
    { id: 7, content: "It's been a week...", scheduled_at: "2026-01-26T10:00:00Z" }
  ]
```

### Reschedule a message

```
scheduled_messages_update(account_id: 1, conversation_id: 42, id: 5,
  scheduled_at: "2026-01-21T14:00:00Z")
```

### Update content

```
scheduled_messages_update(account_id: 1, conversation_id: 42, id: 5,
  content: "Updated message content with new information")
```

### Cancel a scheduled message

If the customer responds before the scheduled time:

```
scheduled_messages_delete(account_id: 1, conversation_id: 42, id: 5)
```

### Cancel all pending follow-ups

When a conversation is resolved early:

```
scheduled_messages_list(account_id: 1, conversation_id: 42)
→ Get all pending message IDs

For each:
  scheduled_messages_delete(account_id: 1, conversation_id: 42, id: <message_id>)
```

## Date/Time Formatting

- Use **ISO 8601** format: `"2026-01-20T10:00:00Z"`
- Always specify timezone (use `Z` for UTC, or offset like `+05:30`)
- Schedule at least a few minutes in the future
- Consider the customer's timezone for optimal delivery
