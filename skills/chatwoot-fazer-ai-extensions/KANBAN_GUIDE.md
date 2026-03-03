# Kanban Board Setup Guide

## Setting Up a Support Pipeline

Step-by-step guide to create a complete Kanban pipeline for tracking support issues.

### Step 1: Create the board

```
kanban_boards_create(account_id: 1, name: "Support Pipeline")
→ { id: 1 }
```

### Step 2: Define pipeline stages

```
kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Incoming", position: 0)
kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Triaged", position: 1)
kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "In Progress", position: 2)
kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Waiting on Customer", position: 3)
kanban_steps_create(account_id: 1, kanban_board_id: 1, name: "Resolved", position: 4)
```

### Step 3: Add team members

```
agents_list(account_id: 1) → find relevant agent IDs
kanban_boards_set_members(account_id: 1, id: 1, user_ids: [5, 7, 12, 15])
```

### Step 4: Configure automation

```
kanban_boards_get_automation_settings(account_id: 1, id: 1)
→ Review current settings

kanban_boards_update_automation_settings(account_id: 1, id: 1,
  ... automation configuration ...)
```

## Setting Up a Sales Pipeline

```
kanban_boards_create(account_id: 1, name: "Sales Pipeline")
→ { id: 2 }

kanban_steps_create(account_id: 1, kanban_board_id: 2, name: "Lead", position: 0)
kanban_steps_create(account_id: 1, kanban_board_id: 2, name: "Qualified", position: 1)
kanban_steps_create(account_id: 1, kanban_board_id: 2, name: "Proposal Sent", position: 2)
kanban_steps_create(account_id: 1, kanban_board_id: 2, name: "Negotiation", position: 3)
kanban_steps_create(account_id: 1, kanban_board_id: 2, name: "Won", position: 4)
kanban_steps_create(account_id: 1, kanban_board_id: 2, name: "Lost", position: 5)
```

## Task Management Patterns

### Moving tasks through the pipeline

```
# Task arrives → Incoming
kanban_tasks_create(account_id: 1, kanban_board_id: 1, ...)
→ task_id: 10

# After triage → Triaged
kanban_tasks_move(account_id: 1, kanban_board_id: 1, id: 10, kanban_step_id: 2)

# Agent picks up → In Progress
kanban_tasks_move(account_id: 1, kanban_board_id: 1, id: 10, kanban_step_id: 3)

# Waiting on reply → Waiting on Customer
kanban_tasks_move(account_id: 1, kanban_board_id: 1, id: 10, kanban_step_id: 4)

# Issue fixed → Resolved
kanban_tasks_move(account_id: 1, kanban_board_id: 1, id: 10, kanban_step_id: 5)
```

### Bulk task review

```
# List all tasks on the board
kanban_tasks_list(account_id: 1, kanban_board_id: 1)

# Review tasks in a specific step
# (filter from the full list by step)

# Move stale tasks
For each task in "Waiting on Customer" for > 7 days:
  kanban_tasks_move(account_id: 1, kanban_board_id: 1, id: <task_id>, kanban_step_id: <resolved_step_id>)
```

### Audit trail review

```
# Check recent board activity
kanban_audit_events_list(account_id: 1, kanban_board_id: 1)
→ [
    { id: 100, event_type: "task_moved", task_id: 10, from_step: "Triaged", to_step: "In Progress" },
    { id: 99, event_type: "task_created", task_id: 10 },
    ...
  ]

# Get details on specific event
kanban_audit_events_get(account_id: 1, kanban_board_id: 1, id: 100)
```
