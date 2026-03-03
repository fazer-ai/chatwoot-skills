# Conversation Workflow Patterns

## 1. Triage Workflow

Process new unassigned conversations and route them to the right team.

```
Step 1: Find unassigned open conversations
  conversations_list(account_id, status: "open", assignee_type: "unassigned")

Step 2: For each conversation:
  a. conversations_get(account_id, conversation_id)    → Check inbox, labels, content
  b. messages_list(account_id, conversation_id)        → Read initial message

Step 3: Categorize and route based on content:
  a. conversations_set_labels(account_id, conversation_id, labels: ["billing"])
  b. conversation_assignments_assign(account_id, conversation_id, team_id: <billing_team_id>)
  c. conversations_toggle_priority(account_id, conversation_id, priority: "high")
```

## 2. Escalation Workflow

Escalate conversations that have been open too long or are high priority.

```
Step 1: Find overdue conversations
  conversations_filter(account_id, payload: [
    { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
    { attribute_key: "created_at", filter_operator: "days_before", values: [3], query_operator: null }
  ])

Step 2: For high-priority ones:
  a. conversations_toggle_priority(account_id, conversation_id, priority: "urgent")
  b. conversation_assignments_assign(account_id, conversation_id, team_id: <escalation_team_id>)
  c. messages_create(account_id, conversation_id,
       content: "This conversation has been escalated due to SLA breach.",
       message_type: "outgoing", private: true)
```

## 3. Bulk Resolution

Resolve old conversations that haven't had activity.

```
Step 1: Find stale conversations
  conversations_filter(account_id, payload: [
    { attribute_key: "status", filter_operator: "equal_to", values: ["open"], query_operator: "AND" },
    { attribute_key: "last_activity_at", filter_operator: "days_before", values: [30], query_operator: null }
  ])

Step 2: For each:
  a. messages_create(account_id, conversation_id,
       content: "Closing this conversation due to inactivity. Please open a new one if you need further help.",
       message_type: "outgoing", private: false)
  b. conversations_toggle_status(account_id, conversation_id, status: "resolved")

Step 3: Paginate if results exceed page size
```

## 4. Conversation Handoff

Transfer a conversation from one agent/team to another with context.

```
Step 1: Read current state
  conversations_get(account_id, conversation_id) → Get current assignee, team, labels

Step 2: Add internal note with context
  messages_create(account_id, conversation_id,
    content: "Handing off to the engineering team. Customer reports a bug in the billing module. See JIRA-5678.",
    message_type: "outgoing", private: true)

Step 3: Reassign
  conversation_assignments_assign(account_id, conversation_id,
    assignee_id: <new_agent_id>, team_id: <engineering_team_id>)

Step 4: Update labels for tracking
  conversations_get_labels → merge → conversations_set_labels(labels: [...existing, "handoff", "engineering"])
```

## 5. SLA Monitoring

Check conversations against SLA targets.

```
Step 1: Get open conversations
  conversations_list(account_id, status: "open")

Step 2: For each, check reporting events
  conversations_reporting_events(account_id, conversation_id)
  → Check first_response_time, resolution_time against SLA thresholds

Step 3: Flag at-risk conversations
  conversations_toggle_priority(account_id, conversation_id, priority: "urgent")
  conversations_set_labels(labels: [...existing, "sla-at-risk"])
```

## 6. Label-Based Routing

Automatically route based on labels set by automation rules or bots.

```
Step 1: Find conversations with a specific label
  conversations_filter(account_id, payload: [
    { attribute_key: "labels", filter_operator: "equal_to", values: ["needs-review"], query_operator: null }
  ])

Step 2: Route to review team
  conversation_assignments_assign(account_id, conversation_id, team_id: <review_team_id>)

Step 3: Replace routing label with status label
  conversations_get_labels → remove "needs-review", add "in-review"
  conversations_set_labels(labels: updated_labels)
```
