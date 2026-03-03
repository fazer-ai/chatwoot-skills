# Chatwoot MCP Tools — Complete Reference

All 129 tools exposed by `@fazer-ai/mcp-chatwoot`, grouped by category.

## Account

| Tool             | Action                  | Key Parameters                       |
| ---------------- | ----------------------- | ------------------------------------ |
| `account_get`    | Get account details     | `account_id`                         |
| `account_update` | Update account settings | `account_id`, `name`, `locale`, etc. |

## Profile

| Tool          | Action                   | Key Parameters                          |
| ------------- | ------------------------ | --------------------------------------- |
| `profile_get` | Get current user profile | _(none — only tool without account_id)_ |

## Agents

| Tool            | Action          | Key Parameters                        |
| --------------- | --------------- | ------------------------------------- |
| `agents_list`   | List all agents | `account_id`                          |
| `agents_create` | Create agent    | `account_id`, `name`, `email`, `role` |
| `agents_update` | Update agent    | `account_id`, `id`, fields...         |
| `agents_delete` | Delete agent    | `account_id`, `id`                    |

## Agent Bots

| Tool                | Action           | Key Parameters                                      |
| ------------------- | ---------------- | --------------------------------------------------- |
| `agent_bots_list`   | List agent bots  | `account_id`                                        |
| `agent_bots_create` | Create agent bot | `account_id`, `name`, `description`, `outgoing_url` |
| `agent_bots_get`    | Get bot by ID    | `account_id`, `id`                                  |
| `agent_bots_update` | Update bot       | `account_id`, `id`, fields...                       |
| `agent_bots_delete` | Delete bot       | `account_id`, `id`                                  |

## Audit Logs

| Tool              | Action                 | Key Parameters       |
| ----------------- | ---------------------- | -------------------- |
| `audit_logs_list` | List audit log entries | `account_id`, `page` |

## Automation Rules

| Tool                      | Action         | Key Parameters                                                             |
| ------------------------- | -------------- | -------------------------------------------------------------------------- |
| `automation_rules_list`   | List all rules | `account_id`, `page`                                                       |
| `automation_rules_create` | Create rule    | `account_id`, `name`, `description`, `event_name`, `conditions`, `actions` |
| `automation_rules_get`    | Get rule by ID | `account_id`, `id`                                                         |
| `automation_rules_update` | Update rule    | `account_id`, `id`, fields...                                              |
| `automation_rules_delete` | Delete rule    | `account_id`, `id`                                                         |

## Canned Responses

| Tool                      | Action          | Key Parameters                              |
| ------------------------- | --------------- | ------------------------------------------- |
| `canned_responses_list`   | List responses  | `account_id`, `search`                      |
| `canned_responses_create` | Create response | `account_id`, `short_code`, `content`       |
| `canned_responses_update` | Update response | `account_id`, `id`, `short_code`, `content` |
| `canned_responses_delete` | Delete response | `account_id`, `id`                          |

## Contacts

| Tool                            | Action                       | Key Parameters                                       |
| ------------------------------- | ---------------------------- | ---------------------------------------------------- |
| `contacts_list`                 | List contacts (paginated)    | `account_id`, `page`, `sort`, `order_by`             |
| `contacts_create`               | Create contact               | `account_id`, `name`, `email`, `phone_number`, etc.  |
| `contacts_get`                  | Get contact by ID            | `account_id`, `id`                                   |
| `contacts_update`               | Update contact               | `account_id`, `id`, fields...                        |
| `contacts_delete`               | Delete contact               | `account_id`, `id`                                   |
| `contacts_conversations`        | Get contact's conversations  | `account_id`, `id`                                   |
| `contacts_search`               | Text search contacts         | `account_id`, `q`, `page`, `sort`, `order_by`        |
| `contacts_filter`               | Filter with structured query | `account_id`, `payload`, `page`                      |
| `contacts_create_contact_inbox` | Link contact to inbox        | `account_id`, `id`, `inbox_id`                       |
| `contacts_contactable_inboxes`  | List inboxes for contact     | `account_id`, `id`                                   |
| `contacts_merge`                | Merge duplicate contacts     | `account_id`, `base_contact_id`, `mergee_contact_id` |

## Contact Labels

| Tool                  | Action                 | Key Parameters                       |
| --------------------- | ---------------------- | ------------------------------------ |
| `contact_labels_list` | List labels on contact | `account_id`, `contact_id`           |
| `contact_labels_set`  | Set labels on contact  | `account_id`, `contact_id`, `labels` |

## Conversations

| Tool                                  | Action                            | Key Parameters                                                       |
| ------------------------------------- | --------------------------------- | -------------------------------------------------------------------- |
| `conversations_meta`                  | Get conversation counts by status | `account_id`                                                         |
| `conversations_list`                  | List conversations                | `account_id`, `status`, `assignee_type`, `page`, etc.                |
| `conversations_create`                | Create conversation               | `account_id`, `source_id`, `inbox_id`, `contact_id`, `message`, etc. |
| `conversations_filter`                | Filter with structured query      | `account_id`, `payload`, `page`                                      |
| `conversations_get`                   | Get conversation by display_id    | `account_id`, `conversation_id`                                      |
| `conversations_update`                | Update conversation               | `account_id`, `conversation_id`, fields...                           |
| `conversations_toggle_status`         | Change status                     | `account_id`, `conversation_id`, `status`                            |
| `conversations_toggle_priority`       | Change priority                   | `account_id`, `conversation_id`, `priority`                          |
| `conversations_set_custom_attributes` | Set custom attributes             | `account_id`, `conversation_id`, `custom_attributes`                 |
| `conversations_get_labels`            | Get labels                        | `account_id`, `conversation_id`                                      |
| `conversations_set_labels`            | Set labels                        | `account_id`, `conversation_id`, `labels`                            |
| `conversations_reporting_events`      | Get reporting events              | `account_id`, `conversation_id`                                      |

## Conversation Assignments

| Tool                              | Action              | Key Parameters                                            |
| --------------------------------- | ------------------- | --------------------------------------------------------- |
| `conversation_assignments_assign` | Assign conversation | `account_id`, `conversation_id`, `assignee_id`, `team_id` |

## Messages

| Tool              | Action                        | Key Parameters                                                        |
| ----------------- | ----------------------------- | --------------------------------------------------------------------- |
| `messages_list`   | List messages in conversation | `account_id`, `conversation_id`                                       |
| `messages_create` | Send message                  | `account_id`, `conversation_id`, `content`, `message_type`, `private` |
| `messages_delete` | Delete message                | `account_id`, `conversation_id`, `message_id`                         |

## Custom Attributes

| Tool                       | Action                     | Key Parameters                                                                            |
| -------------------------- | -------------------------- | ----------------------------------------------------------------------------------------- |
| `custom_attributes_list`   | List attribute definitions | `account_id`, `attribute_model`                                                           |
| `custom_attributes_create` | Create definition          | `account_id`, `attribute_display_name`, `attribute_display_type`, `attribute_model`, etc. |
| `custom_attributes_get`    | Get definition             | `account_id`, `id`                                                                        |
| `custom_attributes_update` | Update definition          | `account_id`, `id`, fields...                                                             |
| `custom_attributes_delete` | Delete definition          | `account_id`, `id`                                                                        |

## Custom Filters

| Tool                    | Action             | Key Parameters                               |
| ----------------------- | ------------------ | -------------------------------------------- |
| `custom_filters_list`   | List saved filters | `account_id`, `filter_type`                  |
| `custom_filters_create` | Create filter      | `account_id`, `name`, `filter_type`, `query` |
| `custom_filters_get`    | Get filter         | `account_id`, `custom_filter_id`             |
| `custom_filters_update` | Update filter      | `account_id`, `custom_filter_id`, fields...  |
| `custom_filters_delete` | Delete filter      | `account_id`, `custom_filter_id`             |

## Help Center

| Tool                            | Action          | Key Parameters                                                     |
| ------------------------------- | --------------- | ------------------------------------------------------------------ |
| `help_center_portals_list`      | List portals    | `account_id`                                                       |
| `help_center_portals_create`    | Create portal   | `account_id`, `name`, `slug`, etc.                                 |
| `help_center_portals_update`    | Update portal   | `account_id`, `portal_id`, fields...                               |
| `help_center_categories_create` | Create category | `account_id`, `portal_id`, `name`, `locale`, etc.                  |
| `help_center_articles_create`   | Create article  | `account_id`, `portal_id`, `title`, `content`, `category_id`, etc. |

## Inboxes

| Tool                    | Action                | Key Parameters                                         |
| ----------------------- | --------------------- | ------------------------------------------------------ |
| `inboxes_list`          | List inboxes          | `account_id`                                           |
| `inboxes_get`           | Get inbox             | `account_id`, `id`                                     |
| `inboxes_create`        | Create inbox          | `account_id`, `name`, `channel` (type-specific params) |
| `inboxes_update`        | Update inbox          | `account_id`, `id`, fields...                          |
| `inboxes_get_agent_bot` | Get inbox's agent bot | `account_id`, `id`                                     |
| `inboxes_set_agent_bot` | Set inbox's agent bot | `account_id`, `id`, `agent_bot_id`                     |

## Inbox Members

| Tool                   | Action                   | Key Parameters                       |
| ---------------------- | ------------------------ | ------------------------------------ |
| `inbox_members_list`   | List inbox agents        | `account_id`, `inbox_id`             |
| `inbox_members_create` | Add agents to inbox      | `account_id`, `inbox_id`, `user_ids` |
| `inbox_members_update` | Update inbox agents      | `account_id`, `inbox_id`, `user_ids` |
| `inbox_members_delete` | Remove agents from inbox | `account_id`, `inbox_id`, `user_ids` |

## Integrations

| Tool                       | Action                  | Key Parameters                                 |
| -------------------------- | ----------------------- | ---------------------------------------------- |
| `integrations_list_apps`   | List integration apps   | `account_id`                                   |
| `integrations_create_hook` | Create integration hook | `account_id`, `app_id`, `inbox_id`, `settings` |
| `integrations_update_hook` | Update hook             | `account_id`, `hook_id`, fields...             |
| `integrations_delete_hook` | Delete hook             | `account_id`, `hook_id`                        |

## Reports

| Tool                           | Action                 | Key Parameters                             |
| ------------------------------ | ---------------------- | ------------------------------------------ |
| `reports_account_overview`     | Real-time overview     | `account_id`                               |
| `reports_account_summary`      | Summary for date range | `account_id`, `since`, `until`, `type`     |
| `reports_agent_summary`        | Agent performance      | `account_id`, `since`, `until`             |
| `reports_conversation_metrics` | Conversation metrics   | `account_id`, `type`                       |
| `reports_v2_overview`          | V2 overview report     | `account_id`, `since`, `until`, `timezone` |
| `reports_v2_agents`            | V2 per-agent report    | `account_id`, `since`, `until`, `timezone` |
| `reports_v2_inboxes`           | V2 per-inbox report    | `account_id`, `since`, `until`, `timezone` |
| `reports_v2_teams`             | V2 per-team report     | `account_id`, `since`, `until`, `timezone` |
| `reports_v2_labels`            | V2 per-label report    | `account_id`, `since`, `until`, `timezone` |

## Teams

| Tool           | Action      | Key Parameters                      |
| -------------- | ----------- | ----------------------------------- |
| `teams_list`   | List teams  | `account_id`                        |
| `teams_create` | Create team | `account_id`, `name`, `description` |
| `teams_get`    | Get team    | `account_id`, `team_id`             |
| `teams_update` | Update team | `account_id`, `team_id`, fields...  |
| `teams_delete` | Delete team | `account_id`, `team_id`             |

## Team Members

| Tool                  | Action            | Key Parameters                      |
| --------------------- | ----------------- | ----------------------------------- |
| `team_members_list`   | List team members | `account_id`, `team_id`             |
| `team_members_add`    | Add members       | `account_id`, `team_id`, `user_ids` |
| `team_members_update` | Update members    | `account_id`, `team_id`, `user_ids` |
| `team_members_delete` | Remove members    | `account_id`, `team_id`, `user_ids` |

## Webhooks

| Tool              | Action         | Key Parameters                        |
| ----------------- | -------------- | ------------------------------------- |
| `webhooks_list`   | List webhooks  | `account_id`                          |
| `webhooks_create` | Create webhook | `account_id`, `url`, `subscriptions`  |
| `webhooks_update` | Update webhook | `account_id`, `webhook_id`, fields... |
| `webhooks_delete` | Delete webhook | `account_id`, `webhook_id`            |

## ⚡ Kanban Boards (fazer.ai exclusive)

| Tool                                       | Action                  | Key Parameters                  |
| ------------------------------------------ | ----------------------- | ------------------------------- |
| `kanban_boards_list`                       | List boards             | `account_id`                    |
| `kanban_boards_create`                     | Create board            | `account_id`, `name`, fields... |
| `kanban_boards_get`                        | Get board               | `account_id`, `id`              |
| `kanban_boards_update`                     | Update board            | `account_id`, `id`, fields...   |
| `kanban_boards_delete`                     | Delete board            | `account_id`, `id`              |
| `kanban_boards_get_automation_settings`    | Get board automation    | `account_id`, `id`              |
| `kanban_boards_update_automation_settings` | Update board automation | `account_id`, `id`, settings... |
| `kanban_boards_get_members`                | Get board members       | `account_id`, `id`              |
| `kanban_boards_set_members`                | Set board members       | `account_id`, `id`, `user_ids`  |

## ⚡ Kanban Steps (fazer.ai exclusive)

| Tool                  | Action              | Key Parameters                                      |
| --------------------- | ------------------- | --------------------------------------------------- |
| `kanban_steps_list`   | List steps in board | `account_id`, `kanban_board_id`                     |
| `kanban_steps_create` | Create step         | `account_id`, `kanban_board_id`, `name`, `position` |
| `kanban_steps_get`    | Get step            | `account_id`, `kanban_board_id`, `id`               |
| `kanban_steps_update` | Update step         | `account_id`, `kanban_board_id`, `id`, fields...    |
| `kanban_steps_delete` | Delete step         | `account_id`, `kanban_board_id`, `id`               |

## ⚡ Kanban Tasks (fazer.ai exclusive)

| Tool                  | Action            | Key Parameters                                          |
| --------------------- | ----------------- | ------------------------------------------------------- |
| `kanban_tasks_list`   | List tasks        | `account_id`, `kanban_board_id`                         |
| `kanban_tasks_create` | Create task       | `account_id`, `kanban_board_id`, fields...              |
| `kanban_tasks_get`    | Get task          | `account_id`, `kanban_board_id`, `id`                   |
| `kanban_tasks_update` | Update task       | `account_id`, `kanban_board_id`, `id`, fields...        |
| `kanban_tasks_delete` | Delete task       | `account_id`, `kanban_board_id`, `id`                   |
| `kanban_tasks_move`   | Move task to step | `account_id`, `kanban_board_id`, `id`, `kanban_step_id` |

## ⚡ Kanban Audit Events (fazer.ai exclusive)

| Tool                       | Action            | Key Parameters                        |
| -------------------------- | ----------------- | ------------------------------------- |
| `kanban_audit_events_list` | List audit events | `account_id`, `kanban_board_id`       |
| `kanban_audit_events_get`  | Get audit event   | `account_id`, `kanban_board_id`, `id` |

## ⚡ Kanban Preferences (fazer.ai exclusive)

| Tool                     | Action               | Key Parameters |
| ------------------------ | -------------------- | -------------- |
| `kanban_preferences_get` | Get user preferences | `account_id`   |

## ⚡ Scheduled Messages (fazer.ai exclusive)

| Tool                        | Action                   | Key Parameters                                             |
| --------------------------- | ------------------------ | ---------------------------------------------------------- |
| `scheduled_messages_list`   | List scheduled messages  | `account_id`, `conversation_id`                            |
| `scheduled_messages_create` | Schedule a message       | `account_id`, `conversation_id`, `content`, `scheduled_at` |
| `scheduled_messages_update` | Update scheduled message | `account_id`, `conversation_id`, `id`, fields...           |
| `scheduled_messages_delete` | Cancel scheduled message | `account_id`, `conversation_id`, `id`                      |
