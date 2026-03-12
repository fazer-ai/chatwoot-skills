# Webhook Payload Reference

Complete reference for Chatwoot webhook event payloads, based on actual source code.

## How Payloads Are Built

Each event type builds its payload from model `webhook_data` methods:

- **Message events** (`message_created`, `message_updated`): `Message#webhook_data` merged with `{ event: "..." }`
- **Conversation events** (`conversation_created`, `conversation_updated`, `conversation_status_changed`): `Conversation#webhook_data` (via `Conversations::EventDataPresenter#push_data`) merged with `{ event: "..." }`. Status/update events also include `changed_attributes`.
- **Contact events** (`contact_created`, `contact_updated`): `Contact#webhook_data` merged with `{ event: "..." }`. Update events also include `changed_attributes`.
- **Typing events** (`conversation_typing_on`, `conversation_typing_off`): Custom payload with `user`, `conversation`, `is_private`.

> **Critical**: Payloads are **flat** — fields are at the top level, NOT nested under a `data` key.

## Shared Objects

### Account Object

```json
{ "id": 8, "name": "Clínica Moreira" }
```

### Inbox Object

```json
{ "id": 27, "name": "WhatsApp" }
```

### Contact Object (in `sender` field of message events)

```json
{
  "account": { "id": 8, "name": "Clínica Moreira" },
  "additional_attributes": {},
  "avatar": "",
  "custom_attributes": {},
  "email": null,
  "id": 177,
  "identifier": null,
  "name": "L.",
  "phone_number": "+553491228732",
  "thumbnail": "",
  "blocked": false
}
```

### Contact Object (in `meta.sender` of conversation object)

Simplified, no `account` field:

```json
{
  "additional_attributes": {},
  "custom_attributes": {},
  "email": null,
  "id": 177,
  "identifier": null,
  "name": "L.",
  "phone_number": "+553491228732",
  "thumbnail": "",
  "blocked": false,
  "type": "contact"
}
```

### User/Assignee Object

```json
{
  "id": 8,
  "name": "Secretária IA",
  "available_name": "Secretária IA",
  "avatar_url": "https://...",
  "type": "user",
  "availability_status": null,
  "thumbnail": "https://..."
}
```

### Conversation Object

Used inside message event payloads and as the base for conversation events:

```json
{
  "additional_attributes": {},
  "can_reply": true,
  "channel": "Channel::Whatsapp",
  "contact_inbox": {
    "id": 196,
    "contact_id": 177,
    "inbox_id": 27,
    "source_id": "553491228732",
    "created_at": "2026-03-12T01:57:17.568Z",
    "updated_at": "2026-03-12T01:57:17.568Z",
    "hmac_verified": false,
    "pubsub_token": "snpx3dRbypQpXy7bJftDCdqi"
  },
  "id": 26,
  "inbox_id": 27,
  "messages": [ /* array with last message push_event_data */ ],
  "labels": [],
  "meta": {
    "sender": { /* Contact push_event_data */ },
    "assignee": { /* User push_event_data or null */ },
    "assignee_type": "User",
    "team": null,
    "hmac_verified": false
  },
  "status": "open",
  "custom_attributes": {},
  "snoozed_until": null,
  "unread_count": 0,
  "first_reply_created_at": null,
  "priority": null,
  "waiting_since": 1773280637,
  "agent_last_seen_at": 1773281224,
  "contact_last_seen_at": 0,
  "last_activity_at": 1773281224,
  "timestamp": 1773281224,
  "created_at": 1773280637,
  "updated_at": 1773281224.012227
}
```

> **⚡ fazer.ai**: Conversation objects may include a `kanban_task` field with board/step data. See the fazer-ai-extensions skill.

### Message Object (inside `conversation.messages[]`)

This is `Message#push_event_data`, used inside the conversation's `messages` array:

```json
{
  "id": 3064,
  "content": "Huffy",
  "account_id": 8,
  "inbox_id": 27,
  "conversation_id": 26,
  "message_type": 0,
  "created_at": 1773281224,
  "updated_at": "2026-03-12T02:07:04.006Z",
  "private": false,
  "status": "sent",
  "source_id": "wamid.HBgMNTUzNDkxMjI4NzMyFQIAEhgUM0E3OTA5ODM4MTg4OEE0Rjg0RUMA",
  "content_type": "text",
  "content_attributes": { "external_created_at": 1773281222 },
  "sender_type": "Contact",
  "sender_id": 177,
  "external_source_ids": {},
  "additional_attributes": {},
  "processed_message_content": "Huffy",
  "sentiment": {},
  "conversation": {
    "assignee_id": 8,
    "unread_count": 0,
    "last_activity_at": 1773281224,
    "contact_inbox": { "source_id": "553491228732" }
  },
  "sender": { /* Contact push_event_data */ }
}
```

> **Note**: `message_type` inside `messages[]` is an **integer** (0=incoming, 1=outgoing, 2=activity, 3=template). At the top level of `message_created` event, `message_type` is a **string** ("incoming", "outgoing", etc.).

---

## Event: `message_created`

Triggered when a new message is created. Only fires for incoming, outgoing, and template messages.

### Top-level structure

The payload is `Message#webhook_data` — fields are **flat at the top level**:

```json
{
  "account": { "id": 8, "name": "Clínica Moreira" },
  "additional_attributes": {},
  "content_attributes": { "external_created_at": 1773281222 },
  "content_type": "text",
  "content": "Huffy",
  "conversation": { /* Full Conversation Object — see above */ },
  "created_at": "2026-03-12T02:07:04.006Z",
  "id": 3064,
  "inbox": { "id": 27, "name": "WhatsApp" },
  "message_type": "incoming",
  "private": false,
  "sender": {
    "account": { "id": 8, "name": "Clínica Moreira" },
    "additional_attributes": {},
    "avatar": "",
    "custom_attributes": {},
    "email": null,
    "id": 177,
    "identifier": null,
    "name": "L.",
    "phone_number": "+553491228732",
    "thumbnail": "",
    "blocked": false
  },
  "source_id": "wamid.HBgMNTU...",
  "event": "message_created"
}
```

### Key fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Message database ID |
| `content` | string | Message text content |
| `content_type` | string | "text", "input_select", "cards", "form", "incoming_email", etc. |
| `message_type` | string | "incoming", "outgoing", "activity", "template" |
| `private` | boolean | Whether this is a private/internal note |
| `source_id` | string | External message ID (e.g., WhatsApp message ID) |
| `conversation` | object | Full conversation data including messages, meta, status |
| `conversation.id` | integer | **This is `display_id`** — use this for API calls |
| `conversation.status` | string | "open", "resolved", "pending", "snoozed" |
| `conversation.meta.sender` | object | Contact who started the conversation |
| `conversation.meta.assignee` | object | Currently assigned agent/bot, or null |
| `sender` | object | Who sent this specific message (Contact or User) |
| `inbox` | object | Inbox `{ id, name }` |
| `account` | object | Account `{ id, name }` |
| `event` | string | Always "message_created" |

### Extracting key information

```
# From a message_created webhook payload:
account_id    = payload["account"]["id"]        # → 8
conversation_id = payload["conversation"]["id"] # → 26 (this IS display_id)
message_id    = payload["id"]                   # → 3064
content       = payload["content"]              # → "Huffy"
sender_name   = payload["sender"]["name"]       # → "L."
sender_phone  = payload["sender"]["phone_number"] # → "+553491228732"
inbox_name    = payload["inbox"]["name"]        # → "WhatsApp"
is_incoming   = payload["message_type"] == "incoming"
assignee      = payload["conversation"]["meta"]["assignee"]  # agent or null
status        = payload["conversation"]["status"]  # → "open"
```

---

## Event: `message_updated`

Same structure as `message_created`, fired when a message is edited.

```json
{
  "account": { "id": 8, "name": "..." },
  "content": "Updated message text",
  "conversation": { /* Full Conversation Object */ },
  "id": 3064,
  "inbox": { "id": 27, "name": "WhatsApp" },
  "message_type": "outgoing",
  "event": "message_updated"
}
```

---

## Event: `conversation_created`

Triggered when a new conversation starts. Payload is `Conversation#webhook_data` (= `Conversations::EventDataPresenter#push_data`).

```json
{
  "additional_attributes": {},
  "can_reply": true,
  "channel": "Channel::Whatsapp",
  "contact_inbox": {
    "id": 196,
    "contact_id": 177,
    "inbox_id": 27,
    "source_id": "553491228732",
    "created_at": "2026-03-12T01:57:17.568Z",
    "updated_at": "2026-03-12T01:57:17.568Z",
    "hmac_verified": false,
    "pubsub_token": "..."
  },
  "id": 26,
  "inbox_id": 27,
  "messages": [],
  "labels": [],
  "meta": {
    "sender": {
      "additional_attributes": {},
      "custom_attributes": {},
      "email": null,
      "id": 177,
      "identifier": null,
      "name": "L.",
      "phone_number": "+553491228732",
      "thumbnail": "",
      "blocked": false,
      "type": "contact"
    },
    "assignee": null,
    "assignee_type": null,
    "team": null,
    "hmac_verified": false
  },
  "status": "open",
  "custom_attributes": {},
  "snoozed_until": null,
  "unread_count": 0,
  "first_reply_created_at": null,
  "priority": null,
  "waiting_since": 1773280637,
  "agent_last_seen_at": 0,
  "contact_last_seen_at": 0,
  "last_activity_at": 1773280637,
  "timestamp": 1773280637,
  "created_at": 1773280637,
  "updated_at": 1773280637.0,
  "event": "conversation_created"
}
```

### Key fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | **This is `display_id`** — use for API calls |
| `inbox_id` | integer | Inbox database ID |
| `channel` | string | Channel type ("Channel::Whatsapp", "Channel::WebWidget", etc.) |
| `status` | string | Initial status ("open" or "pending" if bot is active) |
| `meta.sender` | object | Contact who initiated |
| `meta.assignee` | object/null | Assigned agent |
| `contact_inbox.source_id` | string | External contact ID (e.g., phone number for WhatsApp) |
| `labels` | array | Label names |
| `custom_attributes` | object | Custom attributes on the conversation |
| `event` | string | Always "conversation_created" |

> **Important**: There is NO `display_id` field. The `id` field in conversation webhook payloads IS the display_id (set in `Conversations::EventDataPresenter`).

---

## Event: `conversation_updated`

Same base as `conversation_created`, plus `changed_attributes`:

```json
{
  "additional_attributes": {},
  "can_reply": true,
  "channel": "Channel::Whatsapp",
  "id": 26,
  "inbox_id": 27,
  "status": "open",
  "meta": { "sender": { /* ... */ }, "assignee": { /* ... */ } },
  "custom_attributes": { "plan": "premium" },
  "changed_attributes": {
    "custom_attributes": {
      "current_value": { "plan": "premium" },
      "previous_value": {}
    }
  },
  "event": "conversation_updated"
}
```

### `changed_attributes` examples

Assignment changed:
```json
"changed_attributes": {
  "assignee_id": { "current_value": 8, "previous_value": null }
}
```

Status changed (also sent as `conversation_status_changed`):
```json
"changed_attributes": {
  "status": { "current_value": "resolved", "previous_value": "open" }
}
```

Team changed:
```json
"changed_attributes": {
  "team_id": { "current_value": 3, "previous_value": null }
}
```

Priority changed:
```json
"changed_attributes": {
  "priority": { "current_value": "high", "previous_value": null }
}
```

---

## Event: `conversation_status_changed`

Same structure as `conversation_updated` — includes full conversation data plus `changed_attributes`:

```json
{
  "additional_attributes": {},
  "can_reply": true,
  "channel": "Channel::Whatsapp",
  "id": 26,
  "inbox_id": 27,
  "status": "resolved",
  "meta": {
    "sender": { /* Contact */ },
    "assignee": { "id": 8, "name": "Agent", "type": "user" }
  },
  "changed_attributes": {
    "status": { "current_value": "resolved", "previous_value": "open" }
  },
  "event": "conversation_status_changed"
}
```

---

## Event: `contact_created`

Payload is `Contact#webhook_data`:

```json
{
  "account": { "id": 8, "name": "Clínica Moreira" },
  "additional_attributes": {},
  "avatar": "",
  "custom_attributes": {},
  "email": "jane@example.com",
  "id": 177,
  "identifier": null,
  "name": "Jane Smith",
  "phone_number": "+553491228732",
  "thumbnail": "",
  "blocked": false,
  "event": "contact_created"
}
```

> **Note**: Contact webhooks are delivered only to **account-level** webhooks, not API inbox webhooks.

---

## Event: `contact_updated`

Same as `contact_created` plus `changed_attributes`:

```json
{
  "account": { "id": 8, "name": "Clínica Moreira" },
  "additional_attributes": {},
  "avatar": "",
  "custom_attributes": { "plan": "premium" },
  "email": "jane@example.com",
  "id": 177,
  "name": "Jane Smith",
  "phone_number": "+553491228732",
  "thumbnail": "",
  "blocked": false,
  "changed_attributes": {
    "custom_attributes": {
      "current_value": { "plan": "premium" },
      "previous_value": {}
    }
  },
  "event": "contact_updated"
}
```

> **Note**: This event is NOT fired if `changed_attributes` is empty.

---

## Event: `webwidget_triggered`

Triggered when end user opens the live-chat widget:

```json
{
  "id": 196,
  "contact": {
    "id": 177,
    "name": "Visitor",
    "type": "contact"
  },
  "inbox": { "id": 27, "name": "Website Chat" },
  "account": { "id": 8, "name": "..." },
  "current_conversation": { /* Conversation Object or null */ },
  "source_id": "abc123",
  "event_info": {
    "initiated_at": { "timestamp": "2026-03-12T02:07:04Z" },
    "referer": "https://example.com/pricing",
    "widget_language": "pt",
    "browser_language": "pt-BR",
    "browser": {
      "browser_name": "Chrome",
      "browser_version": "120.0",
      "device_name": "Desktop",
      "platform_name": "Linux",
      "platform_version": "6.1"
    }
  },
  "event": "webwidget_triggered"
}
```

---

## Event: `conversation_typing_on` / `conversation_typing_off`

Triggered when an agent starts/stops typing:

```json
{
  "event": "conversation_typing_on",
  "user": { "id": 8, "name": "Agent", "type": "user" },
  "conversation": { /* Full Conversation Object */ },
  "is_private": false
}
```

---

## Common Gotchas

### 1. Flat payload — no `data` wrapper

Webhook payloads are **flat**. Fields like `content`, `conversation`, `sender` are at the top level. There is NO `data` envelope:

```
✅ payload["content"]
✅ payload["conversation"]["id"]
❌ payload["data"]["content"]
❌ payload["data"]["conversation"]["id"]
```

### 2. `id` vs `display_id` confusion

- In **conversation** webhook payloads (`conversation_created`, etc.), `id` IS the `display_id` (set by `EventDataPresenter`)
- In **message** webhook payloads, `conversation.id` is also `display_id`
- When calling MCP tools, use this `id` directly as `conversation_id`

### 3. `message_type` is a string at top level, integer inside `messages[]`

```
payload["message_type"]                    → "incoming" (string)
payload["conversation"]["messages"][0]["message_type"] → 0 (integer)
```

Integer mapping: 0=incoming, 1=outgoing, 2=activity, 3=template.

### 4. `sender` type varies by context

- In `message_created` for incoming: sender is a **Contact** object (has `phone_number`, `email`, etc.)
- In `message_created` for outgoing: sender is a **User** object (has `type: "user"`)
- In `conversation.meta.sender`: Always the **Contact** who started the conversation

### 5. Timestamps are mixed formats

- `created_at` at top level: ISO 8601 string (`"2026-03-12T02:07:04.006Z"`)
- `created_at` inside conversation: Unix timestamp integer (`1773280637`)
- `updated_at` inside conversation: Unix timestamp float (`1773281224.012227`)

### 6. Webhook delivery

- Method: **POST**
- Content-Type: `application/json`
- Signature header: `X-Chatwoot-Signature` (HMAC-SHA256 if secret is configured)
- Timestamp header: `X-Chatwoot-Timestamp`
- Delivery ID header: `X-Chatwoot-Delivery`
- Contact events (`contact_created`, `contact_updated`) only go to **account-level** webhooks, not API inbox webhooks
