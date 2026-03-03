# Help Center Examples

## Example 1: Create a Complete Knowledge Base

**Scenario**: Set up a help center for a SaaS product from scratch.

```
1. profile_get → account_id: 1

2. Create the portal
   help_center_portals_create(account_id: 1,
     name: "ProductName Help Center",
     slug: "help",
     color: "#4F46E5",
     header_text: "How can we help you today?",
     page_title: "Help - ProductName")
   → portal_id: 1

3. Create main categories
   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Getting Started", locale: "en", position: 1,
     description: "Set up your account and learn the basics")
   → category_id: 10

   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Account & Billing", locale: "en", position: 2,
     description: "Manage your subscription and payments")
   → category_id: 11

   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Features Guide", locale: "en", position: 3,
     description: "Learn about each feature in depth")
   → category_id: 12

   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Troubleshooting", locale: "en", position: 4,
     description: "Common issues and how to fix them")
   → category_id: 13

4. Create articles in "Getting Started"
   help_center_articles_create(account_id: 1, portal_id: 1,
     title: "Creating Your Account",
     content: "## How to Create an Account\n\n1. Visit [productname.com/signup](...)\n2. Enter your email and password\n3. Verify your email\n4. Complete your profile\n\n## Next Steps\n\nAfter creating your account, check out [Setting Up Your Workspace](#).",
     category_id: 10, status: "published", author_id: 5)

   help_center_articles_create(account_id: 1, portal_id: 1,
     title: "Quick Start Guide",
     content: "## 5-Minute Quick Start\n\nGet up and running in just a few steps...",
     category_id: 10, status: "published", author_id: 5)

5. Create articles in "Account & Billing"
   help_center_articles_create(account_id: 1, portal_id: 1,
     title: "How to Upgrade Your Plan",
     content: "## Upgrading\n\n1. Go to **Settings** > **Billing**\n2. Click **Change Plan**\n3. Select your new plan\n4. Confirm payment\n\n## Plan Comparison\n\n| Feature | Free | Pro | Enterprise |\n|---|---|---|---|\n| Users | 3 | 10 | Unlimited |",
     category_id: 11, status: "published", author_id: 5)
```

## Example 2: Migrate Content from Markdown Files

**Scenario**: Import existing documentation from a folder of markdown files.

```
1. profile_get → account_id: 1

2. List existing portal
   help_center_portals_list(account_id: 1)
   → [{ id: 1, name: "Docs", slug: "docs" }]

3. Create a category for the import
   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Imported Documentation", locale: "en", position: 10)
   → category_id: 20

4. For each markdown file:
   help_center_articles_create(account_id: 1, portal_id: 1,
     title: "<filename without .md>",
     content: "<markdown content>",
     category_id: 20,
     status: "draft")

5. Review drafts and update status:
   # After reviewing each article, update to published
   # (would need articles_update if available, or recreate)
```

## Example 3: Restructure Knowledge Base

**Scenario**: Reorganize an existing knowledge base by splitting a large category into smaller ones.

```
1. profile_get → account_id: 1

2. Check existing structure
   help_center_portals_list(account_id: 1)
   → portal_id: 1

3. Create new specialized categories
   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Email Integration", locale: "en", position: 5)
   → category_id: 25

   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "Chat Widget", locale: "en", position: 6)
   → category_id: 26

   help_center_categories_create(account_id: 1, portal_id: 1,
     name: "API Integration", locale: "en", position: 7)
   → category_id: 27

4. Create new articles in the appropriate categories
   help_center_articles_create(account_id: 1, portal_id: 1,
     title: "Setting Up Email Forwarding",
     content: "...", category_id: 25, status: "published")

   help_center_articles_create(account_id: 1, portal_id: 1,
     title: "Customizing the Chat Widget",
     content: "...", category_id: 26, status: "published")
```
