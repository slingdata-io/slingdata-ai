# Sling AI

AI coding assistant configuration for [Sling](https://slingdata.io) - the data integration CLI for moving data between 40+ databases, file systems, and APIs.

## Cross-Compatible

This repository works with multiple AI coding assistants:

| Tool | Configuration File |
|------|-------------------|
| Claude Code | `CLAUDE.md` → `AGENTS.md` |
| Gemini CLI | `GEMINI.md` → `AGENTS.md` |
| OpenAI Codex | `AGENTS.md` (native) |
| GitHub Copilot | `.github/copilot-instructions.md` → `AGENTS.md` |
| Cline | `AGENTS.md` (native fallback) |

`AGENTS.md` is the single source of truth. Other files are symlinks.

## Claude Code Plugin

### Installation

**From Marketplace (recommended):**

```bash
# 1. Add the marketplace
/plugin marketplace add slingdata-io/slingdata-ai

# 2. Install the plugin
/plugin install sling@slingdata-ai
```

Or use the interactive UI:
```bash
/plugin
# Navigate to "Marketplaces" tab → Add → slingdata-io/slingdata-ai
# Then "Discover" tab → Install sling
```

**For local development:**

```bash
claude --plugin-dir /path/to/slingdata-ai
```

### Updating

```bash
# Refresh marketplace and update plugin
/plugin marketplace update slingdata-ai
/plugin update sling@slingdata-ai
```

## Features

### Slash Commands

| Command | Description |
|---------|-------------|
| `/sling:run <file>` | Execute a replication or pipeline YAML file |
| `/sling:conns <action>` | Manage connections (list, test, discover) |
| `/sling:prime <topic>` | Load documentation into context |

### Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `api-researcher` | haiku | Research API documentation |
| `api-cross-referencer` | haiku | Compare with Fivetran/Airbyte connectors |
| `api-spec-builder` | sonnet | Create API specification YAML files |
| `api-spec-tester` | sonnet | Test and debug API specifications |
| `replication-builder` | sonnet | Design data replication configurations |
| `pipeline-builder` | sonnet | Design multi-step pipeline workflows |

### Skills

The `sling-cli` skill provides comprehensive documentation for:
- Connections (databases, file systems, APIs)
- Replications (data movement configurations)
- Pipelines (multi-step workflows)
- API Specifications (REST API data extraction)
- Transforms (data transformation functions)
- Hooks (pre/post actions)

### MCP Server

The plugin configures the Sling MCP server which provides tools for:
- **connection** - Manage and test connections
- **database** - Query and inspect databases
- **file_system** - Browse and copy files
- **replication** - Run data replications
- **pipeline** - Execute multi-step workflows
- **api_spec** - Build and test API integrations

## Requirements

- [Sling CLI](https://docs.slingdata.io/sling-cli/installation) v1.5.0+
- Claude Code

## Quick Start

1. Install the Sling CLI:
   ```bash
   # macOS
   brew install slingdata-io/sling/sling

   # or download from https://github.com/slingdata-io/sling-cli/releases
   ```

2. Configure a connection:
   ```bash
   sling conns set MY_POSTGRES type=postgres host=localhost user=postgres database=mydb
   ```

3. Use the plugin:
   ```
   /sling:conns list
   /sling:conns test MY_POSTGRES
   /sling:prime replications
   ```

## Documentation

- [Sling Documentation](https://docs.slingdata.io)
- [Sling CLI GitHub](https://github.com/slingdata-io/sling-cli)
- [API Specifications](https://github.com/slingdata-io/sling-api-spec)
- [Agent Documentation](docs/AGENTS.md) - Detailed agent descriptions

## Project Structure

```
slingdata-ai/
├── AGENTS.md                # Primary AI instructions (source of truth)
├── CLAUDE.md                # Symlink → AGENTS.md
├── GEMINI.md                # Symlink → AGENTS.md
├── .github/copilot-instructions.md  # Symlink → AGENTS.md
├── .claude-plugin/plugin.json       # Claude plugin manifest
├── .mcp.json                # Sling MCP server config
├── commands/                # Claude slash commands
├── agents/                  # Claude specialized agents
├── skills/                  # Loadable documentation
├── hooks/                   # Session hooks
├── scripts/                 # Helper scripts
└── docs/                    # Additional documentation
```

## License

AGPL-3.0
