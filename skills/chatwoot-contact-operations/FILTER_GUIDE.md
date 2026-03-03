# Contact Filter Guide

## Filter Payload Structure

Every filter condition follows this schema:

```json
{
  "attribute_key": "<field_name>",
  "filter_operator": "<operator>",
  "values": [<value>],
  "query_operator": "AND" | "OR" | null
}
```

**Rules**:

- `query_operator` must be `"AND"` or `"OR"` for all conditions except the **last one**
- The last condition must have `query_operator: null`
- `values` is always an array, even for single values
- For `is_present` / `is_not_present`, use empty array `[]`

## Standard Contact Attributes

| attribute_key      | Type | Available operators                                                                        |
| ------------------ | ---- | ------------------------------------------------------------------------------------------ |
| `name`             | text | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present` |
| `email`            | text | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present` |
| `phone_number`     | text | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present` |
| `identifier`       | text | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present` |
| `country_code`     | text | `equal_to`, `not_equal_to`                                                                 |
| `city`             | text | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`                                 |
| `created_at`       | date | `days_before`, `is_greater_than`, `is_less_than`                                           |
| `last_activity_at` | date | `days_before`, `is_greater_than`, `is_less_than`                                           |
| `labels`           | list | `equal_to`, `not_equal_to`, `is_present`, `is_not_present`                                 |

## Custom Attributes

Any custom attribute defined via `custom_attributes_create` can be used as `attribute_key`. The available operators depend on the attribute's `attribute_display_type`:

| Display type | Operators                                                                                     |
| ------------ | --------------------------------------------------------------------------------------------- |
| `text`       | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present`    |
| `number`     | `equal_to`, `not_equal_to`, `is_greater_than`, `is_less_than`, `is_present`, `is_not_present` |
| `link`       | `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present`    |
| `date`       | `is_greater_than`, `is_less_than`, `days_before`, `is_present`, `is_not_present`              |
| `list`       | `equal_to`, `not_equal_to`, `is_present`, `is_not_present`                                    |
| `checkbox`   | `equal_to`, `not_equal_to`                                                                    |

## Example Filters

### Contacts from a specific domain

```json
{
  "payload": [
    {
      "attribute_key": "email",
      "filter_operator": "contains",
      "values": ["@acme.com"],
      "query_operator": null
    }
  ]
}
```

### VIP contacts without recent activity

```json
{
  "payload": [
    {
      "attribute_key": "labels",
      "filter_operator": "equal_to",
      "values": ["vip"],
      "query_operator": "AND"
    },
    {
      "attribute_key": "last_activity_at",
      "filter_operator": "days_before",
      "values": [60],
      "query_operator": null
    }
  ]
}
```

### Contacts with phone but no email

```json
{
  "payload": [
    {
      "attribute_key": "phone_number",
      "filter_operator": "is_present",
      "values": [],
      "query_operator": "AND"
    },
    {
      "attribute_key": "email",
      "filter_operator": "is_not_present",
      "values": [],
      "query_operator": null
    }
  ]
}
```

### Enterprise plan contacts (custom attribute)

```json
{
  "payload": [
    {
      "attribute_key": "plan",
      "filter_operator": "equal_to",
      "values": ["enterprise"],
      "query_operator": null
    }
  ]
}
```

### Contacts from US or UK

```json
{
  "payload": [
    {
      "attribute_key": "country_code",
      "filter_operator": "equal_to",
      "values": ["US"],
      "query_operator": "OR"
    },
    {
      "attribute_key": "country_code",
      "filter_operator": "equal_to",
      "values": ["GB"],
      "query_operator": null
    }
  ]
}
```
