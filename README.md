# chatwoot-skills

Expert Claude Code skills for the [mcp-chatwoot](https://github.com/fazer-ai/mcp-chatwoot) MCP server. Teaches Claude how to effectively use all 129 Chatwoot MCP tools.

Built by [fazer.ai](https://fazer.ai) — following the [Agent Skills](https://github.com/anthropics/agent-skills) open standard.

## Installation

### Claude Code

**Method 1: Marketplace** (recommended)
```
/plugin marketplace add fazer-ai/chatwoot-skills
/plugin install chatwoot-skills@chatwoot-skills
```

See the [plugin marketplaces docs](https://code.claude.com/docs/en/plugin-marketplaces) for more details.

**Method 2: Manual clone**
```bash
git clone https://github.com/fazer-ai/chatwoot-skills.git
cp -r chatwoot-skills/skills/* ~/.claude/skills/
```

### Claude.ai

Download individual skill zips from the [`dist/`](dist/) folder, then upload via **Settings → Capabilities → Skills**.

## Quick Start

```bash
# In Claude Code, add the marketplace and install
/plugin marketplace add fazer-ai/chatwoot-skills
/plugin install chatwoot-skills@chatwoot-skills

# Configure MCP server (create .mcp.json in your project)
cp .mcp.json.example .mcp.json
# Edit .mcp.json with your Chatwoot URL and API token

# Start using it
> Get my Chatwoot profile and list open conversations
```

## Skills

| Skill                       | Description                                                 | Tools Covered |
| --------------------------- | ----------------------------------------------------------- | ------------- |
| **MCP Tools Expert**        | Master guide to all 129 tools — naming, selection, patterns | All           |
| **Conversation Management** | Lifecycle, messages, assignments, labels, filtering         | 20+           |
| **Contact Operations**      | CRUD, search vs filter, merging, bulk operations            | 11            |
| **Admin Configuration**     | Teams, inboxes, agents, automation rules, webhooks          | 30+           |
| **Reporting & Analytics**   | V1/V2 reports, metrics, performance analysis                | 9             |
| **Help Center**             | Portals, categories, articles, knowledge base setup         | 5             |
| **Automation Patterns**     | Bots, routing, escalation, webhook integrations             | 14            |
| **fazer.ai Extensions**     | Kanban boards, scheduled messages (fazer.ai only)           | 28            |

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- A Chatwoot instance with API access
- The [@fazer-ai/mcp-chatwoot](https://www.npmjs.com/package/@fazer-ai/mcp-chatwoot) MCP server

## Configuration

Create `.mcp.json` in your project root:

```json
{
  "mcpServers": {
    "chatwoot": {
      "command": "bunx",
      "args": ["@fazer-ai/mcp-chatwoot"],
      "env": {
        "CHATWOOT_BASE_URL": "https://your-instance.chatwoot.com",
        "CHATWOOT_API_TOKEN": "your-api-token"
      }
    }
  }
}
```

## Example Prompts

```
Find all open conversations older than 7 days and resolve them with a closing message
```

```
Create a "Billing Support" team, add agents 5 and 12, and route conversations labeled "billing" to it
```

```
Compare first response times across all inboxes for the last 30 days
```

```
Set up a sales pipeline kanban board with 6 stages (fazer.ai only)
```

## Evaluations

Each skill includes evaluation scenarios in the `evaluations/` directory. These test Claude's ability to use skills for real Chatwoot workflows.

```bash
# Validate project structure and evaluation files
./build.sh validate
```

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for evaluation schema and authoring guidelines.

## Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Usage Guide](docs/USAGE.md)
- [Development Guide](docs/DEVELOPMENT.md)

## Project Structure

```
chatwoot-skills/
├── .claude-plugin/       # Plugin manifest
├── skills/               # 8 expert skill directories
├── evaluations/          # 30 evaluation scenarios
├── docs/                 # Installation, usage, development guides
├── .mcp.json.example     # MCP server config template
├── build.sh              # Validation script
├── CLAUDE.md             # Contributor meta-instructions
└── LICENSE               # MIT
```

## License

MIT — see [LICENSE](LICENSE) for details.

---

Built with the [mcp-chatwoot](https://github.com/fazer-ai/mcp-chatwoot) MCP server by [fazer.ai](https://fazer.ai).
