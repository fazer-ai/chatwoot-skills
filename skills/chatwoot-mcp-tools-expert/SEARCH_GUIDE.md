# Search & Filter Guide for mcp-chatwoot

## Contact Search

### `contacts_search` — Quick text search

Simple free-text search across contact fields (name, email, phone, identifier).

**Parameters**:

- `account_id` (required)
- `q` — Search query string
- `page` — Page number (default: 1)
- `sort` — Sort field
- `order_by` — `"asc"` or `"desc"`

**Example**: Find contacts matching "acme"

```json
{
  "account_id": 1,
  "q": "acme",
  "page": 1
}
```

### `contacts_filter` — Structured filtering

Complex queries with operators and boolean logic.

**Parameters**:

- `account_id` (required)
- `payload` — Array of filter conditions
- `page` — Page number (default: 1)

**Filter condition schema**:

```json
{
  "attribute_key": "<field_name>",
  "filter_operator": "<operator>",
  "values": ["<value1>", "<value2>"],
  "query_operator": "AND" | "OR" | null
}
```

**Available operators**:
| Operator | Meaning | Value type |
|---|---|---|
| `equal_to` | Exact match | `["value"]` |
| `not_equal_to` | Not equal | `["value"]` |
| `contains` | Substring match | `["substring"]` |
| `does_not_contain` | No substring | `["substring"]` |
| `is_present` | Field has a value | `[]` |
| `is_not_present` | Field is empty/null | `[]` |
| `is_greater_than` | Numeric/date comparison | `["number"]` |
| `is_less_than` | Numeric/date comparison | `["number"]` |
| `days_before` | Date relative | `["number_of_days"]` |

**Filterable contact attributes**:

- Standard: `name`, `email`, `phone_number`, `identifier`, `created_at`, `last_activity_at`, `country_code`, `city`
- Custom attributes: Use the attribute key defined via `custom_attributes_create`
- Labels: `labels` attribute_key with label values

#### Example: Contacts with email containing "gmail" AND created in last 30 days

```json
{
  "account_id": 1,
  "payload": [
    {
      "attribute_key": "email",
      "filter_operator": "contains",
      "values": ["gmail"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "created_at",
      "filter_operator": "days_before",
      "values": [30],
      "query_operator": null
    }
  ]
}
```

#### Example: Contacts without phone number

```json
{
  "account_id": 1,
  "payload": [
    {
      "attribute_key": "phone_number",
      "filter_operator": "is_not_present",
      "values": [],
      "query_operator": null
    }
  ]
}
```

---

## Conversation Filtering

### `conversations_list` — Basic listing with status filter

Quick way to list conversations by status:

**Parameters**:

- `account_id` (required)
- `status` — `"open"`, `"resolved"`, `"pending"`, `"snoozed"`, `"all"`
- `assignee_type` — `"me"`, `"unassigned"`, `"all"`, `"assigned"`
- `page` — Page number
- `inbox_id` — Filter by inbox
- `team_id` — Filter by team
- `labels` — Filter by labels (array)

### `conversations_filter` — Advanced structured filtering

Same payload structure as contacts_filter, but with conversation-specific attributes.

**Filterable conversation attributes**:

- `status` — open, resolved, pending, snoozed
- `assignee_id` — Agent assigned
- `team_id` — Team assigned
- `inbox_id` — Source inbox
- `priority` — none, low, medium, high, urgent
- `display_id` — Conversation number
- `campaign_id` — Associated campaign
- `labels` — Applied labels
- `browser_language` — Contact's browser language
- `country_code` — Contact's country
- `created_at` — Creation date
- `last_activity_at` — Last activity
- Custom attributes (conversation-scoped)

#### Example: Open high-priority conversations assigned to a specific team

```json
{
  "account_id": 1,
  "payload": [
    {
      "attribute_key": "status",
      "filter_operator": "equal_to",
      "values": ["open"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "priority",
      "filter_operator": "equal_to",
      "values": ["high"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "team_id",
      "filter_operator": "equal_to",
      "values": [5],
      "query_operator": null
    }
  ]
}
```

#### Example: Unassigned conversations from the last 7 days

```json
{
  "account_id": 1,
  "payload": [
    {
      "attribute_key": "assignee_id",
      "filter_operator": "is_not_present",
      "values": [],
      "query_operator": "AND"
    },
    {
      "attribute_key": "created_at",
      "filter_operator": "days_before",
      "values": [7],
      "query_operator": null
    }
  ]
}
```

---

## Conversation Metadata

### `conversations_meta` — Status counts

Returns conversation counts grouped by status. Useful for dashboards:

```json
{
  "account_id": 1
}
```

Response includes counts for: `all`, `open`, `resolved`, `pending`, `snoozed`, `mine`, `unassigned`, `assigned`.

---

## Custom Filters — Saved Queries

Save frequently used filter configurations for reuse.

### List saved filters

```json
{
  "account_id": 1,
  "filter_type": "conversation" // or "contact"
}
```

### Create saved filter

```json
{
  "account_id": 1,
  "name": "High Priority Unassigned",
  "filter_type": "conversation",
  "query": {
    "payload": [
      {
        "attribute_key": "priority",
        "filter_operator": "equal_to",
        "values": ["high"],
        "query_operator": "AND"
      },
      {
        "attribute_key": "assignee_id",
        "filter_operator": "is_not_present",
        "values": [],
        "query_operator": null
      }
    ]
  }
}
```

Saved filters can be retrieved and their `query` reused in `conversations_filter` or `contacts_filter` calls.
