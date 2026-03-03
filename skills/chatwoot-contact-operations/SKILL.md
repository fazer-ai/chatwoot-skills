---
name: chatwoot-contact-operations
description: Manage Chatwoot contacts — search, filter, create, update, merge duplicates, manage labels, and link contacts to inboxes. Use when working with customer data, contact records, or contact management.
---

# Chatwoot Contact Operations

Complete guide for managing contacts (customers) in Chatwoot using mcp-chatwoot MCP tools.

## Contact Data Model

A Chatwoot contact represents a customer or end-user. Key fields:

| Field                   | Type     | Description                                    |
| ----------------------- | -------- | ---------------------------------------------- |
| `id`                    | integer  | Unique contact ID                              |
| `name`                  | string   | Display name                                   |
| `email`                 | string   | Email address                                  |
| `phone_number`          | string   | Phone (with country code, e.g., `+1234567890`) |
| `identifier`            | string   | External system identifier                     |
| `custom_attributes`     | object   | Arbitrary key-value pairs                      |
| `thumbnail`             | string   | Avatar URL                                     |
| `additional_attributes` | object   | System-managed attributes (browser, OS, etc.)  |
| `created_at`            | datetime | Creation timestamp                             |
| `last_activity_at`      | datetime | Last interaction timestamp                     |

## Creating Contacts

```
contacts_create(
  account_id: 1,
  name: "Jane Smith",
  email: "jane@company.com",
  phone_number: "+15551234567",
  identifier: "CRM-12345",
  custom_attributes: {
    "plan": "enterprise",
    "company": "Acme Corp"
  }
)
```

**Tips**:

- `email` and `phone_number` are used for deduplication — Chatwoot may reject if a contact with the same email/phone exists
- `identifier` is useful for linking to external systems (CRM, billing, etc.)
- `custom_attributes` are freeform but should match defined attribute keys for consistency

## Finding Contacts

### Quick text search: `contacts_search`

Searches across name, email, phone, and identifier fields:

```
contacts_search(account_id: 1, q: "jane@company.com")
contacts_search(account_id: 1, q: "Acme")
contacts_search(account_id: 1, q: "+1555")
```

Best for: Quick lookups when you have a partial name, email, or phone.

### Structured filtering: `contacts_filter`

Complex queries with boolean logic and operators:

```
contacts_filter(
  account_id: 1,
  payload: [
    {
      "attribute_key": "email",
      "filter_operator": "contains",
      "values": ["@acme.com"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "last_activity_at",
      "filter_operator": "days_before",
      "values": [90],
      "query_operator": null
    }
  ]
)
```

Best for: Finding contacts matching specific criteria (inactive contacts, contacts without email, contacts from a specific domain, etc.)

### When to use which

| Scenario                     | Tool                                           |
| ---------------------------- | ---------------------------------------------- |
| "Find John's contact"        | `contacts_search(q: "John")`                   |
| "Find all Gmail contacts"    | `contacts_filter(email contains "@gmail.com")` |
| "Contacts without phone"     | `contacts_filter(phone_number is_not_present)` |
| "Contacts created this week" | `contacts_filter(created_at days_before 7)`    |
| "Contact with ID CRM-123"    | `contacts_search(q: "CRM-123")`                |

See the mcp-tools-expert skill's `SEARCH_GUIDE.md` for complete filter syntax.

## Updating Contacts

```
contacts_update(
  account_id: 1,
  id: 42,
  name: "Jane Smith-Jones",
  custom_attributes: {
    "plan": "enterprise-plus",
    "renewal_date": "2026-06-15"
  }
)
```

Only pass the fields you want to change — other fields are preserved.

## Contact Labels

Labels are string tags for categorizing contacts.

### List labels

```
contact_labels_list(account_id: 1, contact_id: 42)
→ ["vip", "enterprise"]
```

### Set labels (replaces all)

```
contact_labels_set(account_id: 1, contact_id: 42, labels: ["vip", "enterprise", "churning"])
```

**⚠️ Replaces all labels** — read first, merge, then set.

## Merging Duplicate Contacts

When two contact records represent the same person:

```
contacts_merge(
  account_id: 1,
  base_contact_id: 42,
  mergee_contact_id: 87
)
```

- `base_contact_id` — The contact that **survives** (keeps its ID)
- `mergee_contact_id` — The contact that gets **merged into** the base (deleted)
- Conversations, messages, and attributes from the mergee are transferred to the base

### Deduplication workflow

```
1. contacts_search(q: "jane@company.com")
   → Returns contacts [42, 87] with same email

2. contacts_get(id: 42) → Check which has more data
   contacts_get(id: 87) → Compare

3. contacts_merge(base_contact_id: 42, mergee_contact_id: 87)
   → Contact 87's conversations now belong to contact 42
```

## Contact-Inbox Relationships

### List contactable inboxes

Find which inboxes a contact can be reached through:

```
contacts_contactable_inboxes(account_id: 1, id: 42)
→ [{ inbox: { id: 3, name: "Email" }, source_id: "jane@company.com" }, ...]
```

### Link contact to inbox

Create a contact-inbox association:

```
contacts_create_contact_inbox(
  account_id: 1,
  id: 42,
  inbox_id: 5
)
```

This is needed to create conversations for a contact on a specific inbox channel.

## Contact's Conversations

Get all conversations for a specific contact:

```
contacts_conversations(account_id: 1, id: 42)
→ List of conversations with this contact
```

Useful for getting a customer's full history before responding.

## Deleting Contacts

```
contacts_delete(account_id: 1, id: 42)
```

**⚠️ Destructive**: Permanently removes the contact and their data. Consider merging instead if it's a duplicate.

## Common Patterns

See `FILTER_GUIDE.md` for advanced contact filtering examples.

See `EXAMPLES.md` for real-world scenario walkthroughs.
