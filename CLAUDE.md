# CLAUDE.md

Project-level instructions for Claude Code when working on this repository.

## Project Overview

**chatwoot-skills** is a Claude Code plugin containing 8 expert skills that teach Claude how to use the [mcp-chatwoot](https://github.com/fazer-ai/mcp-chatwoot) MCP server (129 tools) to manage Chatwoot instances effectively.

This is a **knowledge-only** project — no executable code. All content is Markdown + JSON.

## Architecture

```
.claude-plugin/     → Plugin manifest (plugin.json, marketplace.json)
skills/             → 8 skill directories, each with SKILL.md + reference files
evaluations/        → 3-5 evaluation JSON files per skill (~30 total)
docs/               → INSTALLATION.md, USAGE.md, DEVELOPMENT.md
.mcp.json.example   → Example MCP server configuration
build.sh            → Builds distribution .zip packages into dist/
```

## Development Principles

1. **Evaluation-first**: Write evaluation scenarios BEFORE implementing or editing a skill
2. **MCP-informed**: All tool references must match actual mcp-chatwoot tool names exactly
3. **Concise skills**: Each SKILL.md must stay **under 500 lines**; offload detail to reference files
4. **Real examples**: All examples should reflect realistic Chatwoot workflows
5. **Composable**: Skills should reference each other where appropriate (e.g., conversation skill references mcp-tools-expert for tool usage details)

## Skill Authoring Conventions

### SKILL.md structure

Every skill MUST have YAML frontmatter:

```yaml
---
name: chatwoot-<skill-name>
description: <What this skill does. Claude uses this to decide when to activate it.>
---
```

### File naming

- Primary file: `SKILL.md` (required)
- Reference files: `UPPER_SNAKE_CASE.md` (e.g., `TOOL_REFERENCE.md`, `EXAMPLES.md`)
- Each skill folder also has a `README.md` with metadata (purpose, file list, line counts)

### Content guidelines

- Use headers (`##`, `###`) to organize sections
- Include "Common Mistakes" or "Gotchas" sections where applicable
- Provide concrete examples with actual tool names and parameter shapes
- Mark fazer.ai-exclusive features clearly with `⚡ fazer.ai` prefix

## MCP Tool Reference

The mcp-chatwoot server exposes 129 tools. Key naming patterns:

- `<resource>_list` — List resources (paginated)
- `<resource>_get` — Get single resource by ID
- `<resource>_create` — Create new resource
- `<resource>_update` — Update existing resource
- `<resource>_delete` — Delete resource
- All tools require `account_id` as a parameter

## Evaluation Schema

Each evaluation file (`evaluations/<skill>/eval-NNN-description.json`) follows:

```json
{
  "id": "<prefix>-NNN",
  "skills": ["chatwoot-<skill-name>"],
  "query": "Realistic user prompt",
  "expected_behavior": ["Assertion 1", "Assertion 2"],
  "baseline_without_skill": {
    "likely_response": "What Claude does without the skill",
    "expected_quality": "Low|Medium"
  },
  "with_skill_expected": {
    "response_quality": "High - reason",
    "uses_skill_content": true,
    "provides_correct_syntax": true
  }
}
```

## Testing

### Local plugin testing

```bash
claude --plugin-dir .
```

### Validate plugin structure

```bash
claude plugin validate .
```

## Important Rules

- NEVER reference "fazer" alone — always use "fazer-ai" (hyphenated, for code/URLs) or "fazer.ai" (dotted, for branding/display)
- Keep all tool names exactly matching the mcp-chatwoot server (e.g., `conversations_list`, not `list_conversations`)
- Every skill must have corresponding evaluations before being considered complete
