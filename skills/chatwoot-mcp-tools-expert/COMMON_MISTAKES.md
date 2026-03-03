# Common Mistakes with mcp-chatwoot Tools

## 1. Missing `account_id`

**Symptom**: Tool call fails with missing parameter error.

**Fix**: Always call `profile_get` first to discover the `account_id`, then pass it to every subsequent tool call.

```
Step 1: profile_get → extract account_id from response
Step 2: conversations_list(account_id: 1, ...) → works
```

## 2. Wrong Conversation ID Type

**Symptom**: 404 or wrong conversation returned.

**Explanation**: Chatwoot has two ID types for conversations:

- **`display_id`** — The integer shown in the UI (e.g., `#42`). This is what `conversation_id` expects in most tools.
- **`uuid`** — Internal UUID. Not used by mcp-chatwoot tools.

**Fix**: Always use the numeric `display_id` for `conversation_id` parameters.

## 3. Confusing `contacts_search` vs `contacts_filter`

**Symptom**: Can't find contacts with complex conditions, or getting too many irrelevant results.

| Use case                                     | Tool              | Example                                                     |
| -------------------------------------------- | ----------------- | ----------------------------------------------------------- |
| Quick lookup by name/email                   | `contacts_search` | `q: "john@example.com"`                                     |
| Find contacts with specific attribute values | `contacts_filter` | Structured payload with operators                           |
| Find contacts without email                  | `contacts_filter` | `attribute_key: "email", filter_operator: "is_not_present"` |

**Rule**: If you need operators (equals, contains, greater than, is present/absent), use `contacts_filter`. For simple text matching, use `contacts_search`.

## 4. Wrong Message Type

**Symptom**: Message appears as customer message or doesn't send correctly.

**`message_type` values**:

- `"outgoing"` — From agent to customer (most common)
- `"incoming"` — Simulates a customer message
- `"activity"` — System activity note (internal)

**Fix**: Almost always use `"outgoing"` unless you're simulating customer behavior.

## 5. Private vs Public Messages

**Symptom**: Customer sees internal notes, or agents can't see notes.

**Parameter**: `private` (boolean)

- `true` — Internal note, only visible to agents
- `false` (default) — Public message, visible to customer

**Fix**: Set `private: true` for internal coordination messages.

## 6. Filter Payload Structure Errors

**Symptom**: Filter returns all results or errors out.

**Correct structure**:

```json
{
  "payload": [
    {
      "attribute_key": "status",
      "filter_operator": "equal_to",
      "values": ["open"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "assignee_type",
      "filter_operator": "equal_to",
      "values": ["assigned"],
      "query_operator": null
    }
  ]
}
```

**Common errors**:

- Using `"="` instead of `"equal_to"` for `filter_operator`
- Passing a string instead of array for `values`
- Missing `query_operator` on non-last items (use `"AND"` or `"OR"`)
- Setting `query_operator` on the **last** item (should be `null`)

## 7. Pagination Missed

**Symptom**: Only getting 15-25 results when there are more.

**Fix**: Check if the number of returned items equals the page size. If so, increment `page` and call again:

```
page 1: conversations_list(account_id: 1, page: 1) → 25 results
page 2: conversations_list(account_id: 1, page: 2) → 25 results
page 3: conversations_list(account_id: 1, page: 3) → 12 results (done)
```

## 8. Updating Labels Replaces All

**Symptom**: Setting labels removes existing ones.

**Explanation**: `conversations_set_labels` and `contact_labels_set` **replace** all labels, not append.

**Fix**: Always read current labels first, merge, then set:

```
1. conversations_get_labels → ["bug", "urgent"]
2. Merge with new: ["bug", "urgent", "reviewed"]
3. conversations_set_labels → ["bug", "urgent", "reviewed"]
```

## 9. Trying to Message a Resolved Conversation

**Symptom**: Message sends but conversation doesn't reopen automatically in some configurations.

**Fix**: Toggle status first if needed:

```
1. conversations_get → check status
2. If resolved: conversations_toggle_status(status: "open")
3. messages_create → send message
```

## 10. Agent Bot Not Working on Inbox

**Symptom**: Bot created but doesn't process messages.

**Fix**: Creating an agent bot doesn't automatically connect it to an inbox. You must:

```
1. agent_bots_create → get bot_id
2. inboxes_set_agent_bot(id: inbox_id, agent_bot_id: bot_id)
```
