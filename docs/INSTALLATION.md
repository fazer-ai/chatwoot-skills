# Installation

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed and authenticated
- A Chatwoot instance (self-hosted or [fazer.ai](https://fazer.ai) hosted)
- A Chatwoot API access token (user or bot token)

## Install the Plugin

```bash
claude plugin install fazer-ai/chatwoot-skills
```

This installs all 8 skills and makes them available in your Claude Code sessions.

## Configure the MCP Server

The skills require the [mcp-chatwoot](https://github.com/fazer-ai/mcp-chatwoot) MCP server to interact with your Chatwoot instance.

### Option 1: Project-level configuration (recommended)

Create a `.mcp.json` file in your project root:

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

### Option 2: Global configuration

Add to your Claude Code global MCP settings:

```bash
claude mcp add chatwoot -- bunx @fazer-ai/mcp-chatwoot
```

Then set environment variables:

```bash
export CHATWOOT_BASE_URL="https://your-instance.chatwoot.com"
export CHATWOOT_API_TOKEN="your-api-token"
```

## Getting Your API Token

1. Log in to your Chatwoot instance
2. Go to **Settings → Account Settings → Access Token**
3. Copy the access token

For bot-level access, create an Agent Bot via the API and use its access token.

## Verify Installation

Start a Claude Code session and check that:

1. The plugin is loaded: `claude plugin list`
2. MCP tools are available — ask Claude: _"List my available Chatwoot MCP tools"_
3. Connection works — ask Claude: _"Get my Chatwoot profile using profile_get"_

## fazer.ai Extensions

If you're using a [fazer.ai](https://fazer.ai) hosted Chatwoot instance, you'll also have access to:

- **Kanban boards** — project management tools (24 tools)
- **Scheduled messages** — delayed message delivery (4 tools)

These tools are included in the `chatwoot-fazer-ai-extensions` skill and work automatically when connected to a fazer.ai instance.

## Troubleshooting

| Problem                | Solution                                                         |
| ---------------------- | ---------------------------------------------------------------- |
| "MCP server not found" | Run `bunx @fazer-ai/mcp-chatwoot` manually to verify it installs |
| "Unauthorized" errors  | Check your API token and base URL                                |
| Tools not appearing    | Restart Claude Code after adding `.mcp.json`                     |
| "account_id required"  | Call `profile_get` first to discover your account ID             |
