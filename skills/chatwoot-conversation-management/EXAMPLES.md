# Conversation Management Examples

## Example 1: Resolve All Stale Conversations

**Scenario**: Close all open conversations that haven't had activity in 30 days.

```
1. profile_get → account_id: 1

2. conversations_filter(account_id: 1, payload: [
     { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
     { attribute_key: "last_activity_at", filter_operator: "days_before", values: [30], query_operator: null }
   ])
   → Returns: [{ display_id: 15 }, { display_id: 23 }, { display_id: 41 }]

3. For conversation 15:
   messages_create(account_id: 1, conversation_id: 15,
     content: "We're closing this conversation due to inactivity. Feel free to start a new one anytime!",
     message_type: "outgoing", private: false)
   conversations_toggle_status(account_id: 1, conversation_id: 15, status: "resolved")

4. Repeat for 23, 41...

5. Check if page has more results → conversations_filter(page: 2) → repeat if needed
```

## Example 2: Reassign Unresponded Conversations

**Scenario**: Find conversations where no agent has replied within 24 hours and assign to senior team.

```
1. profile_get → account_id: 1

2. conversations_filter(account_id: 1, payload: [
     { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
     { attribute_key: "assignee_id", filter_operator: "is_not_present", values: [], query_operator: "AND" },
     { attribute_key: "created_at", filter_operator: "days_before", values: [1], query_operator: null }
   ])

3. teams_list(account_id: 1) → Find "Senior Support" team_id: 5

4. For each conversation:
   conversation_assignments_assign(account_id: 1, conversation_id: <id>, team_id: 5)
   conversations_toggle_priority(account_id: 1, conversation_id: <id>, priority: "high")
   messages_create(account_id: 1, conversation_id: <id>,
     content: "Auto-escalated: no response within 24 hours.",
     message_type: "outgoing", private: true)
```

## Example 3: Tag Conversations by Content Keywords

**Scenario**: Read recent conversations and add labels based on message content.

```
1. profile_get → account_id: 1

2. conversations_list(account_id: 1, status: "open", page: 1)

3. For each conversation:
   messages_list(account_id: 1, conversation_id: <id>)
   → Analyze message content for keywords

4. If messages mention "billing" or "invoice" or "payment":
   conversations_get_labels(account_id: 1, conversation_id: <id>) → existing_labels
   conversations_set_labels(account_id: 1, conversation_id: <id>,
     labels: [...existing_labels, "billing"])

5. If messages mention "bug" or "error" or "broken":
   conversations_set_labels(labels: [...existing_labels, "bug-report"])
```

## Example 4: Create a Conversation with Initial Context

**Scenario**: Proactively create a conversation for an existing contact.

```
1. profile_get → account_id: 1

2. contacts_search(account_id: 1, q: "jane@company.com")
   → contact_id: 42

3. inboxes_list(account_id: 1) → Find "Email" inbox_id: 3

4. conversations_create(account_id: 1,
     contact_id: 42,
     inbox_id: 3,
     message: {
       content: "Hi Jane, following up on your recent purchase. Is everything working well?"
     },
     status: "open")
   → conversation_id: 156

5. conversations_set_labels(account_id: 1, conversation_id: 156,
     labels: ["proactive-outreach", "follow-up"])

6. conversation_assignments_assign(account_id: 1, conversation_id: 156,
     assignee_id: 7)
```
