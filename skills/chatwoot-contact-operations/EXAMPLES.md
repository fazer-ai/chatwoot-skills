# Contact Operations Examples

## Example 1: Deduplicate Contacts

**Scenario**: Find and merge duplicate contacts with the same email.

```
1. profile_get → account_id: 1

2. contacts_search(account_id: 1, q: "jane@company.com")
   → Returns: [
       { id: 42, name: "Jane Smith", email: "jane@company.com", conversations_count: 5 },
       { id: 87, name: "jane", email: "jane@company.com", conversations_count: 1 }
     ]

3. contacts_get(account_id: 1, id: 42) → Has full name, phone, custom attributes
   contacts_get(account_id: 1, id: 87) → Only has email, sparse data

4. contacts_merge(account_id: 1, base_contact_id: 42, mergee_contact_id: 87)
   → Contact 87's 1 conversation now belongs to contact 42
   → Contact 42 now has 6 conversations total
```

## Example 2: Bulk Label Contacts by Domain

**Scenario**: Tag all contacts from `@bigclient.com` as "enterprise".

```
1. profile_get → account_id: 1

2. contacts_filter(account_id: 1, payload: [
     { attribute_key: "email", filter_operator: "contains", values: ["@bigclient.com"], query_operator: null }
   ])
   → Returns contacts on page 1: [{ id: 10 }, { id: 23 }, { id: 45 }, ...]

3. For each contact:
   contact_labels_list(account_id: 1, contact_id: 10) → ["existing-label"]
   contact_labels_set(account_id: 1, contact_id: 10, labels: ["existing-label", "enterprise"])

4. Check pagination: if 25 results returned, fetch page 2
   contacts_filter(account_id: 1, page: 2, payload: [...])
```

## Example 3: Contact Enrichment

**Scenario**: Update contacts with data from an external source.

```
1. profile_get → account_id: 1

2. contacts_search(account_id: 1, q: "CRM-12345")
   → { id: 42, name: "Jane Smith", identifier: "CRM-12345" }

3. contacts_update(account_id: 1, id: 42,
     phone_number: "+15559876543",
     custom_attributes: {
       "company": "Acme Corp",
       "plan": "enterprise",
       "mrr": 5000,
       "renewal_date": "2026-12-01"
     })

4. contact_labels_set(account_id: 1, contact_id: 42,
     labels: ["enterprise", "high-value"])
```

## Example 4: Find Inactive Contacts for Cleanup

**Scenario**: Identify contacts with no activity in 6 months.

```
1. profile_get → account_id: 1

2. contacts_filter(account_id: 1, payload: [
     { attribute_key: "last_activity_at", filter_operator: "days_before", values: [180], query_operator: null }
   ])
   → Returns inactive contacts

3. For each, check if they have open conversations:
   contacts_conversations(account_id: 1, id: <contact_id>)
   → If no open conversations, candidate for cleanup

4. Tag for review:
   contact_labels_set(account_id: 1, contact_id: <id>, labels: ["inactive-review"])
```
