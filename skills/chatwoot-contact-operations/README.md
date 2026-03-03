# chatwoot-contact-operations

**Purpose**: Contact CRUD, search vs filter, merging duplicates, managing labels, and contact-inbox relationships.

**Activation triggers**: Contacts, customers, search, merge, duplicates, contact labels, phone, email, contact data.

## Files

| File              | Lines | Description                                                                         |
| ----------------- | ----- | ----------------------------------------------------------------------------------- |
| `SKILL.md`        | ~160  | Core guide — data model, CRUD, search vs filter, merge, labels, inbox relationships |
| `FILTER_GUIDE.md` | ~120  | Complete filter syntax with operators and examples                                  |
| `EXAMPLES.md`     | ~90   | 4 real-world scenarios: dedup, bulk label, enrichment, cleanup                      |

## Dependencies

- `chatwoot-mcp-tools-expert` — for general tool patterns
- Requires `@fazer-ai/mcp-chatwoot` MCP server

## Evaluation Coverage

- 4 evaluation scenarios in `evaluations/contact-operations/`
