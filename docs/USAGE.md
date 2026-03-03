# Usage Guide

## How Skills Work

Skills are activated automatically based on context. When you ask Claude about Chatwoot-related tasks, the relevant skill knowledge is loaded to provide expert-level answers.

## Available Skills

| Skill                       | Activates When You Ask About                          |
| --------------------------- | ----------------------------------------------------- |
| **MCP Tools Expert**        | Tool selection, MCP patterns, debugging tool calls    |
| **Conversation Management** | Managing conversations, messages, assignments, labels |
| **Contact Operations**      | Contact CRUD, merging, filtering, labeling            |
| **Admin Configuration**     | Teams, inboxes, agents, automation rules, webhooks    |
| **Reporting & Analytics**   | Reports, metrics, performance analysis                |
| **Help Center**             | Portals, categories, articles, knowledge base         |
| **Automation Patterns**     | Bots, routing, escalation, integrations               |
| **fazer.ai Extensions**     | Kanban boards, scheduled messages (fazer.ai only)     |

## Example Prompts

### Getting Started

```
Get my Chatwoot profile and tell me my account ID
```

### Conversation Management

```
Find all open conversations that haven't been responded to in 24 hours and assign them to team 3
```

### Contact Operations

```
Search for all contacts with @acme.com emails and add the "enterprise" label without removing existing labels
```

### Admin Setup

```
Create a new "VIP Support" team, add agents 5 and 12 to it, and set up an automation rule that routes conversations with the "vip" label to this team
```

### Reporting

```
Generate a weekly performance report comparing all agents' first response times and resolution rates
```

### Help Center

```
Create a help center portal called "Product Docs" with categories for Getting Started, API Reference, and FAQs, then add 3 articles to each category
```

### Automation

```
Set up a chatbot that greets new users, collects their email, and hands off to a human agent
```

### fazer.ai Extensions

```
Create a sales pipeline kanban board with Lead, Qualified, Proposal, Negotiation, and Closed stages
```

## Tips

1. **Start with `profile_get`** — always establish your account_id first
2. **Use search for simple lookups** — `contacts_search` with a text query
3. **Use filters for complex queries** — `contacts_filter` / `conversations_filter` with structured payloads
4. **Labels replace, not append** — always read existing labels before setting new ones
5. **Paginate large results** — increment the `page` parameter until you get fewer results than the page size
6. **Unix timestamps for reports** — all date parameters in reporting tools use Unix epoch seconds
