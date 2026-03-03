---
name: chatwoot-mcp-tools-expert
description: Expert guide for using mcp-chatwoot MCP tools. Use when interacting with the Chatwoot API, managing conversations, contacts, teams, inboxes, or any Chatwoot resource via MCP tools.
---

# Chatwoot MCP Tools Expert

You have access to the **mcp-chatwoot** MCP server which exposes **129 tools** covering the full Chatwoot API. This skill teaches you how to use them effectively.

## Critical: Every Tool Requires `account_id`

All mcp-chatwoot tools take `account_id` as their **first required parameter**. If you don't know it:

1. Call `profile_get` (the only tool that doesn't need `account_id`) to get the current user's profile
2. The response includes `account_id` in the user's available accounts
3. Use that `account_id` for all subsequent calls

## Tool Categories at a Glance

| Category                  | Tools    | Primary Use                                                                        |
| ------------------------- | -------- | ---------------------------------------------------------------------------------- |
| **Conversations**         | 12 tools | Core messaging — list, create, filter, status, priority, labels, custom attributes |
| **Messages**              | 3 tools  | Send/list/delete messages within conversations                                     |
| **Contacts**              | 11 tools | Customer data — CRUD, search, filter, merge, labels                                |
| **Agents**                | 4 tools  | Manage support agents                                                              |
| **Teams**                 | 9 tools  | Teams + team member management                                                     |
| **Inboxes**               | 11 tools | Channel configuration + inbox members                                              |
| **Automation Rules**      | 5 tools  | Event-driven automation                                                            |
| **Canned Responses**      | 4 tools  | Reusable message templates                                                         |
| **Custom Attributes**     | 5 tools  | Define custom data fields                                                          |
| **Custom Filters**        | 5 tools  | Saved filter presets                                                               |
| **Reports**               | 9 tools  | Analytics — overview, agent, inbox, team, label metrics                            |
| **Help Center**           | 5 tools  | Knowledge base — portals, categories, articles                                     |
| **Agent Bots**            | 5 tools  | Bot configuration                                                                  |
| **Webhooks**              | 4 tools  | External integrations                                                              |
| **Integrations**          | 4 tools  | App hooks                                                                          |
| **Account**               | 2 tools  | Account info                                                                       |
| **Audit Logs**            | 1 tool   | Activity audit trail                                                               |
| **Profile**               | 1 tool   | Current user profile                                                               |
| **⚡ Kanban**             | 24 tools | Boards, steps, tasks, audit events, preferences (fazer.ai exclusive)               |
| **⚡ Scheduled Messages** | 4 tools  | Time-delayed messages (fazer.ai exclusive)                                         |

## Tool Naming Convention

Tools follow a consistent `<resource>_<action>` pattern:

```
conversations_list          → List conversations (paginated)
conversations_get           → Get single conversation by ID
conversations_create        → Create new conversation
conversations_update        → Update conversation
conversations_filter        → Advanced filtering with query syntax
conversations_toggle_status → Change status (open/resolved/pending/snoozed)
```

## How to Choose the Right Tool

### Finding resources

| Need             | Tool                  | When to use                                  |
| ---------------- | --------------------- | -------------------------------------------- |
| Browse all       | `*_list`              | Paginated listing, broad overview            |
| Find by ID       | `*_get`               | You already have the resource ID             |
| Text search      | `contacts_search`     | Free-text search across contact fields       |
| Structured query | `*_filter`            | Complex conditions (AND/OR, operators)       |
| Saved queries    | `custom_filters_list` | Reuse previously saved filter configurations |

### Search vs Filter

This is the most common source of confusion:

- **`contacts_search`** — Simple text search. Pass a `q` string parameter. Searches across name, email, phone, identifier.
- **`contacts_filter`** — Structured query with operators. Supports `equal_to`, `not_equal_to`, `contains`, `does_not_contain`, `is_present`, `is_not_present`. Combine with AND/OR logic.
- **`conversations_filter`** — Same structured query system for conversations. Filter by status, assignee, team, label, inbox, custom attributes, etc.

**Rule of thumb**: Use `_search` for quick lookups by text. Use `_filter` for precise, multi-condition queries.

### Modifying resources

| Action          | Pattern       | Example                                                                                           |
| --------------- | ------------- | ------------------------------------------------------------------------------------------------- |
| Create          | `*_create`    | `contacts_create`, `teams_create`                                                                 |
| Update          | `*_update`    | `contacts_update`, `conversations_update`                                                         |
| Delete          | `*_delete`    | `messages_delete`, `webhooks_delete`                                                              |
| Special actions | Named actions | `conversations_toggle_status`, `conversations_toggle_priority`, `conversation_assignments_assign` |

## Response Format

All tools return JSON text in this structure:

```json
{
  "content": [
    {
      "type": "text",
      "text": "{ ... JSON response ... }"
    }
  ]
}
```

The inner `text` field contains the actual Chatwoot API response as a JSON string. Parse it to extract data.

## Pagination

List endpoints are paginated. Common parameters:

- `page` — Page number (1-indexed)
- Most endpoints return 15-25 items per page by default

To get all results, loop through pages until you receive fewer items than the page size.

## MCP Tool Annotations

Tools include safety annotations:

- **`readOnlyHint: true`** — Safe to call, doesn't modify data (list, get, search, filter)
- **`destructiveHint: true`** — Deletes data permanently (all `*_delete` tools)
- **`idempotentHint: true`** — Safe to retry (updates with same data produce same result)

**Always prefer read-only tools first** to gather context before making changes.

## Common Workflow Patterns

### 1. Discover → Act pattern

```
1. profile_get                           → Get account_id
2. conversations_list / _filter          → Find relevant conversations
3. conversations_get                     → Get full details
4. messages_list                         → Read message history
5. messages_create / conversations_update → Take action
```

### 2. Bulk operations pattern

```
1. conversations_filter  → Get matching conversations
2. Loop through results:
   - conversations_toggle_status / _set_labels / conversation_assignments_assign
3. Paginate if needed (check result count vs page size)
```

### 3. Setup pattern

```
1. teams_create              → Create team
2. agents_list               → Find agent IDs
3. team_members_add          → Add agents to team
4. inboxes_create            → Create inbox
5. inbox_members_create      → Assign agents to inbox
6. automation_rules_create   → Set up routing rules
```

## Common Mistakes

### ❌ Forgetting `account_id`

Every tool except `profile_get` requires it. Always resolve it first.

### ❌ Using wrong ID types

- `conversation_id` is the **display_id** (integer shown in UI), NOT the internal UUID
- `contact_id`, `inbox_id`, `team_id`, `agent_id` are all integers

### ❌ Confusing filter query syntax

Filter tools accept a `payload` object with `attribute_key`, `filter_operator`, `values`, and `query_operator`. See the conversation-management and contact-operations skills for detailed syntax.

### ❌ Sending messages with wrong type

`messages_create` requires `message_type`: `"outgoing"` (from agent), `"incoming"` (from contact), or `"activity"` (system note). Most of the time you want `"outgoing"`.

### ❌ Not checking conversation status before acting

A resolved conversation may need to be reopened (`conversations_toggle_status` with `status: "open"`) before sending new messages.

## Tool Quick Reference

See `TOOL_REFERENCE.md` for the complete list of all 129 tools grouped by category with parameters.

See `COMMON_MISTAKES.md` for detailed error scenarios and fixes.

See `SEARCH_GUIDE.md` for in-depth coverage of search and filter query syntax.
