---
name: chatwoot-help-center
description: Manage Chatwoot Help Center — create and organize portals, categories, and articles for a knowledge base. Use when building, maintaining, or restructuring a knowledge base or help documentation.
---

# Chatwoot Help Center

Guide for managing Chatwoot's built-in knowledge base using mcp-chatwoot MCP tools.

## Architecture

```
Help Center
├── Portal (the knowledge base site)
│   ├── Category (topic group)
│   │   ├── Article
│   │   ├── Article
│   │   └── ...
│   ├── Category
│   │   └── Articles...
│   └── ...
└── Portal (another knowledge base)
    └── Categories and articles...
```

- **Portal**: A standalone help center site with its own domain/slug, name, and configuration
- **Category**: A topic group within a portal (e.g., "Getting Started", "Billing", "API Reference")
- **Article**: An individual help document with title, content, and metadata

## Portals

### List portals

```
help_center_portals_list(account_id: 1)
→ [{ id: 1, name: "Customer Help", slug: "help", ... }]
```

### Create a portal

```
help_center_portals_create(
  account_id: 1,
  name: "Customer Help Center",
  slug: "help",
  color: "#1F93FF",
  header_text: "How can we help you?",
  page_title: "Help Center",
  homepage_link: "https://company.com"
)
```

- `slug` becomes the URL path (e.g., `/hc/help`)
- Must be unique within the account

### Update a portal

```
help_center_portals_update(
  account_id: 1,
  portal_id: 1,
  name: "Updated Help Center",
  header_text: "Find answers fast"
)
```

## Categories

### Create a category

```
help_center_categories_create(
  account_id: 1,
  portal_id: 1,
  name: "Getting Started",
  locale: "en",
  description: "Everything you need to get up and running",
  position: 1
)
→ { id: 10, name: "Getting Started", ... }
```

- `locale` — Language code (e.g., `"en"`, `"es"`, `"fr"`)
- `position` — Display order (lower numbers appear first)

### Organize categories

Create categories in logical order by setting `position`:

```
help_center_categories_create(name: "Getting Started", position: 1)
help_center_categories_create(name: "Account Management", position: 2)
help_center_categories_create(name: "Billing & Payments", position: 3)
help_center_categories_create(name: "Integrations", position: 4)
help_center_categories_create(name: "Troubleshooting", position: 5)
help_center_categories_create(name: "API Reference", position: 6)
```

## Articles

### Create an article

```
help_center_articles_create(
  account_id: 1,
  portal_id: 1,
  title: "How to Reset Your Password",
  content: "## Steps to Reset Your Password\n\n1. Click **Forgot Password** on the login page...",
  category_id: 10,
  status: "published",
  author_id: 5
)
```

- `content` — Supports Markdown formatting
- `status` — `"draft"` or `"published"`
- `author_id` — Agent ID of the article author

### Article content best practices

1. **Start with a clear title** — Action-oriented ("How to...", "Understanding...")
2. **Use Markdown formatting** — Headers, lists, code blocks, bold for emphasis
3. **Keep articles focused** — One topic per article
4. **Include step-by-step instructions** — Numbered lists for procedures
5. **Add search-friendly keywords** — Customers will search for these

## Common Patterns

### Set up a new knowledge base

```
Step 1: Create the portal
  help_center_portals_create(account_id: 1,
    name: "Support Center", slug: "support",
    header_text: "Search for answers or browse topics")

Step 2: Create categories
  help_center_categories_create(portal_id: 1, name: "Getting Started", position: 1, locale: "en")
  → category_id: 10
  help_center_categories_create(portal_id: 1, name: "FAQ", position: 2, locale: "en")
  → category_id: 11

Step 3: Create articles
  help_center_articles_create(portal_id: 1, category_id: 10,
    title: "Welcome to Our Platform",
    content: "## Getting Started\n\nWelcome! Here's how to...",
    status: "published")
```

### Bulk article creation

When migrating content or creating many articles:

```
For each article in source:
  help_center_articles_create(
    account_id: 1, portal_id: 1, category_id: <appropriate_category>,
    title: article.title, content: article.content, status: "draft")

# Review all drafts, then publish
```

Create articles as `"draft"` first for review, then update to `"published"`.

### Multi-language portal

Create parallel categories for each locale:

```
help_center_categories_create(portal_id: 1, name: "Getting Started", locale: "en", position: 1)
help_center_categories_create(portal_id: 1, name: "Primeros Pasos", locale: "es", position: 1)
help_center_categories_create(portal_id: 1, name: "Pour Commencer", locale: "fr", position: 1)
```

Then create translated articles in each locale's category.

See `EXAMPLES.md` for complete setup walkthroughs.
