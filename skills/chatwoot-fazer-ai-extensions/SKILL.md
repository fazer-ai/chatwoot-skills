---
name: chatwoot-fazer-ai-extensions
description: Use fazer.ai-exclusive Chatwoot features — Kanban boards, tasks, steps, and scheduled messages. Use when managing pipelines, task boards, scheduling messages, or working with fazer.ai Chatwoot extensions. Requires a fazer.ai Chatwoot instance.
---

# ⚡ fazer.ai Chatwoot Extensions

Guide for using fazer.ai-exclusive features available through the mcp-chatwoot MCP server.

**⚠️ These features require a fazer.ai Chatwoot instance. They are not available on standard Chatwoot.**

## Overview

| Feature                | Tools    | Purpose                                                |
| ---------------------- | -------- | ------------------------------------------------------ |
| **Kanban Boards**      | 24 tools | Visual pipeline management for conversations and tasks |
| **Scheduled Messages** | 4 tools  | Time-delayed message delivery                          |

## Kanban System Architecture

```
Kanban Board
├── Steps (columns in the board)
│   ├── Step 1: "New" (position: 0)
│   ├── Step 2: "In Progress" (position: 1)
│   ├── Step 3: "Review" (position: 2)
│   └── Step 4: "Done" (position: 3)
├── Tasks (cards that move between steps)
│   ├── Task A → currently in Step 1
│   ├── Task B → currently in Step 2
│   └── Task C → currently in Step 3
├── Members (agents with board access)
├── Automation Settings
└── Audit Events (activity log)
```

## Kanban Boards

### Create a board

```
kanban_boards_create(
  account_id: 1,
  name: "Support Pipeline"
)
→ { id: 1, name: "Support Pipeline" }
```

### List boards

```
kanban_boards_list(account_id: 1)
```

### Manage board members

```
# Get current members
kanban_boards_get_members(account_id: 1, id: 1)

# Set members (replaces all)
kanban_boards_set_members(account_id: 1, id: 1, user_ids: [5, 7, 12])
```

### Board automation settings

```
# Get current automation
kanban_boards_get_automation_settings(account_id: 1, id: 1)

# Update automation
kanban_boards_update_automation_settings(account_id: 1, id: 1,
  ... settings ...)
```

## Kanban Steps

Steps are the columns/stages in a board.

### Create steps

```
kanban_steps_create(account_id: 1, kanban_board_id: 1,
  name: "New", position: 0)
→ { id: 1, name: "New", position: 0 }

kanban_steps_create(account_id: 1, kanban_board_id: 1,
  name: "In Progress", position: 1)
→ { id: 2, name: "In Progress", position: 1 }

kanban_steps_create(account_id: 1, kanban_board_id: 1,
  name: "Review", position: 2)
→ { id: 3, name: "Review", position: 2 }

kanban_steps_create(account_id: 1, kanban_board_id: 1,
  name: "Done", position: 3)
→ { id: 4, name: "Done", position: 3 }
```

### List steps

```
kanban_steps_list(account_id: 1, kanban_board_id: 1)
→ [{ id: 1, name: "New" }, { id: 2, name: "In Progress" }, ...]
```

### Reorder steps

Update `position` to reorder:

```
kanban_steps_update(account_id: 1, kanban_board_id: 1, id: 3,
  position: 1)  # Move "Review" to second position
```

## Kanban Tasks

Tasks are the cards that move through the pipeline.

### Create a task

```
kanban_tasks_create(
  account_id: 1,
  kanban_board_id: 1,
  ... task fields ...
)
```

### Move a task between steps

```
kanban_tasks_move(
  account_id: 1,
  kanban_board_id: 1,
  id: 10,
  kanban_step_id: 3  # Move to "Review" step
)
```

### List tasks

```
kanban_tasks_list(account_id: 1, kanban_board_id: 1)
```

### Update a task

```
kanban_tasks_update(account_id: 1, kanban_board_id: 1, id: 10,
  ... updated fields ...)
```

## Kanban Audit Events

Track all activity on a board:

```
# List all events
kanban_audit_events_list(account_id: 1, kanban_board_id: 1)

# Get specific event
kanban_audit_events_get(account_id: 1, kanban_board_id: 1, id: 50)
```

Audit events capture: task creation, moves, updates, deletions, member changes.

## Kanban Preferences

Get user-specific board preferences:

```
kanban_preferences_get(account_id: 1)
```

## Scheduled Messages

Send messages at a future time — useful for follow-ups, reminders, and proactive outreach.

### Schedule a message

```
scheduled_messages_create(
  account_id: 1,
  conversation_id: 42,
  content: "Hi! Just checking in — were you able to resolve the issue?",
  scheduled_at: "2026-01-20T10:00:00Z"
)
```

- `scheduled_at` — ISO 8601 datetime in UTC
- The message will be sent automatically at the specified time

### List scheduled messages

```
scheduled_messages_list(account_id: 1, conversation_id: 42)
→ [{ id: 5, content: "Just checking in...", scheduled_at: "2026-01-20T10:00:00Z" }]
```

### Update a scheduled message

Change content or timing:

```
scheduled_messages_update(account_id: 1, conversation_id: 42, id: 5,
  content: "Updated follow-up message",
  scheduled_at: "2026-01-21T14:00:00Z")
```

### Cancel a scheduled message

```
scheduled_messages_delete(account_id: 1, conversation_id: 42, id: 5)
```

## Common Patterns

See `KANBAN_GUIDE.md` for step-by-step board setup patterns.

See `SCHEDULED_MESSAGES.md` for message scheduling use cases.

See `EXAMPLES.md` for end-to-end scenarios.
