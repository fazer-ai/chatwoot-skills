# Development Guide

## Repository Structure

```
chatwoot-skills/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace listing
├── skills/
│   ├── chatwoot-mcp-tools-expert/
│   ├── chatwoot-conversation-management/
│   ├── chatwoot-contact-operations/
│   ├── chatwoot-admin-configuration/
│   ├── chatwoot-reporting-analytics/
│   ├── chatwoot-help-center/
│   ├── chatwoot-automation-patterns/
│   └── chatwoot-fazer-ai-extensions/
├── evaluations/
│   ├── mcp-tools/
│   ├── conversation-management/
│   ├── contact-operations/
│   ├── admin-configuration/
│   ├── reporting-analytics/
│   ├── help-center/
│   ├── automation-patterns/
│   └── fazer-ai-extensions/
├── docs/
│   ├── INSTALLATION.md
│   ├── USAGE.md
│   └── DEVELOPMENT.md
├── .mcp.json.example
├── build.sh
├── CLAUDE.md
├── LICENSE
└── README.md
```

## Skill Authoring

### SKILL.md Format

Every skill directory must contain a `SKILL.md` with YAML frontmatter:

```markdown
---
name: skill-name
description: >-
  One sentence that tells Claude WHEN to activate this skill.
  Keep it clear and keyword-rich.
---

# Skill Title

Content goes here...
```

### Guidelines

- **SKILL.md must be under 500 lines** — use reference files for deep dives
- **Description drives activation** — phrase it for Claude's context matching
- **Reference files** should be focused on one topic each
- **Use concrete examples** with realistic Chatwoot data
- **Include common mistakes** to prevent known error patterns
- **Every directory needs a README.md** with metadata

### Naming Convention

Always use lowercase with hyphens. Prefix skill directories with `chatwoot-`.

## Evaluations

### Schema

Each evaluation file is a JSON array of scenarios:

```json
[
  {
    "id": "prefix-001",
    "skills": ["skill-name"],
    "query": "User's natural language question",
    "expected_behavior": ["Specific behavior 1", "Specific behavior 2"],
    "baseline_without_skill": {
      "likely_response": "What Claude would do without the skill",
      "expected_quality": "Low|Medium|High"
    },
    "with_skill_expected": {
      "response_quality": "Description of expected quality",
      "uses_skill_content": true,
      "provides_correct_syntax": true
    }
  }
]
```

### Writing Good Evaluations

1. **Test real workflows** — not theoretical questions
2. **Include edge cases** — common mistakes, ambiguous requests
3. **Verify tool correctness** — ensure expected_behavior lists correct tool names and parameters
4. **Baseline matters** — document what happens without the skill to show value
5. **3-5 scenarios per skill** — cover breadth without redundancy

### Running Evaluations

```bash
# Validate all evaluation JSON files
./build.sh validate

# Manual testing: ask Claude each query and compare against expected_behavior
```

## Contributing

### Adding a New Skill

1. Create `skills/chatwoot-<name>/SKILL.md` with frontmatter
2. Add reference files as needed
3. Add `skills/chatwoot-<name>/README.md`
4. Create `evaluations/<name>/eval-<name>.json` with 3-5 scenarios
5. Update plugin.json version
6. Run `./build.sh validate`

### Modifying Existing Skills

1. Write evaluation scenarios for the change FIRST
2. Make the skill content changes
3. Verify evaluations still pass
4. Update version in plugin.json

### Style Rules

- **Never reference "fazer" alone** — always use "fazer-ai" or "fazer.ai"
- Use `account_id` consistently (not `accountId` or `account-id`)
- Tool names use `snake_case` matching the MCP server
- Example IDs should be realistic (not 1, 2, 3)
- Include error cases, not just happy paths
