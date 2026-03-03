# fazer.ai Extensions Examples

## Example 1: Set Up a Support Pipeline Board

**Scenario**: Create a Kanban board for tracking support conversations through resolution stages.

```
1. profile_get → account_id: 1

2. Create the board
   kanban_boards_create(account_id: 1, name: "Customer Support Pipeline")
   → { id: 1 }

3. Create steps (pipeline stages)
   kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "New", position: 0)
   kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Investigating", position: 1)
   kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Waiting on Customer", position: 2)
   kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Escalated", position: 3)
   kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Resolved", position: 4)

4. Add team members
   agents_list(account_id: 1) → [{ id: 5 }, { id: 7 }, { id: 12 }]
   kanban_boards_set_members(account_id: 1, id: 1, user_ids: [5, 7, 12])

5. Create initial tasks for open conversations
   conversations_list(account_id: 1, status: "open")
   For each open conversation:
     kanban_tasks_create(account_id: 1, kanban_board_id: 1, ...)

6. Verify setup
   kanban_boards_get(account_id: 1, id: 1)
   kanban_steps_list(account_id: 1, kanban_board_id: 1)
   kanban_tasks_list(account_id: 1, kanban_board_id: 1)
```

## Example 2: Schedule Follow-Up Messages

**Scenario**: After resolving a conversation, schedule automated follow-ups.

```
1. profile_get → account_id: 1

2. Resolve the conversation
   conversations_toggle_status(account_id: 1, conversation_id: 42, status: "resolved")

3. Schedule follow-up sequence
   # Day 1: Quick check
   scheduled_messages_create(account_id: 1, conversation_id: 42,
     content: "Hi! Just wanted to make sure the solution is working for you. Let us know if you need anything!",
     scheduled_at: "2026-01-21T10:00:00Z")

   # Day 3: Satisfaction check
   scheduled_messages_create(account_id: 1, conversation_id: 42,
     content: "Hope everything is going smoothly! If you have a moment, we'd love your feedback on the support you received.",
     scheduled_at: "2026-01-23T10:00:00Z")

4. Verify scheduled messages
   scheduled_messages_list(account_id: 1, conversation_id: 42)
   → Confirm 2 messages scheduled

5. If customer responds before scheduled time, cancel remaining:
   scheduled_messages_list(account_id: 1, conversation_id: 42)
   For each pending message:
     scheduled_messages_delete(account_id: 1, conversation_id: 42, id: <id>)
```

## Example 3: Audit Task History

**Scenario**: Review the activity history of a Kanban board for a weekly standup.

```
1. profile_get → account_id: 1

2. List all boards
   kanban_boards_list(account_id: 1)
   → [{ id: 1, name: "Customer Support Pipeline" }]

3. Get board overview
   kanban_steps_list(account_id: 1, kanban_board_id: 1)
   → 5 steps
   kanban_tasks_list(account_id: 1, kanban_board_id: 1)
   → All current tasks with their step positions

4. Review recent activity
   kanban_audit_events_list(account_id: 1, kanban_board_id: 1)
   → [
       { event: "task_moved", task: "Fix login bug", from: "Investigating", to: "Resolved", by: "Alice", at: "..." },
       { event: "task_created", task: "API timeout issue", by: "Bob", at: "..." },
       { event: "task_moved", task: "Billing error", from: "New", to: "Investigating", by: "Charlie", at: "..." },
       ...
     ]

5. Summarize for standup:
   "This week: 5 tasks resolved, 3 new tasks created, 2 currently in progress.
    Average time in pipeline: ~2 days. Bottleneck: 'Waiting on Customer' (4 tasks stuck)."
```
