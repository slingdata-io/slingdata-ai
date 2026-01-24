# Sling AI - Development Guide

This file provides guidance for AI coding assistants working with this repository.

> **Cross-Compatible**: This file (`AGENTS.md`) is the single source of truth, with symlinks for Claude (`CLAUDE.md`), Gemini (`GEMINI.md`), and GitHub Copilot (`.github/copilot-instructions.md`).

## Repository Overview

AI plugin for [Sling](https://slingdata.io) - the data integration CLI for moving data between 40+ databases, file systems, and APIs.

## Directory Structure

```
slingdata-ai/
├── AGENTS.md                # Primary instructions (this file)
├── CLAUDE.md -> AGENTS.md   # Symlink for Claude Code
├── GEMINI.md -> AGENTS.md   # Symlink for Gemini CLI
├── .github/
│   └── copilot-instructions.md -> ../AGENTS.md  # GitHub Copilot
├── .claude-plugin/
│   └── plugin.json          # Claude plugin manifest
├── .mcp.json                # Sling MCP server configuration
├── commands/                # Slash commands (Claude)
│   ├── run.md              # /sling:run - Execute replications/pipelines
│   └── conns.md            # /sling:conns - Connection management
├── agents/                  # Specialized subagents (Claude)
│   ├── api-researcher.md
│   ├── api-cross-referencer.md
│   ├── api-spec-builder.md
│   ├── api-spec-tester.md
│   ├── replication-builder.md
│   └── pipeline-builder.md
├── skills/                  # Topic-specific skills (auto-invoked by Claude)
│   ├── sling/              # Overview and MCP tools reference
│   ├── sling-connections/  # Connection management
│   ├── sling-replications/ # Data replication configs
│   ├── sling-pipelines/    # Multi-step workflows
│   ├── sling-transforms/   # Data transformation functions
│   ├── sling-hooks/        # Pre/post actions
│   ├── sling-troubleshooting/ # Debug issues
│   └── sling-api-specs/    # API specification building (12 supporting files)
├── hooks/
│   └── hooks.json          # Session hooks (Claude)
├── scripts/                # Helper bash scripts
├── docs/                   # Additional documentation
└── README.md               # User-facing documentation
```

## Plugin Components

### Commands (`commands/`)

Slash commands are user-invoked actions. Each `.md` file defines:
- Frontmatter with name, description, allowed-tools, arguments
- Instructions for Claude on how to execute the command

| Command | File | Purpose |
|---------|------|---------|
| `/sling:run` | `run.md` | Execute replication or pipeline files |
| `/sling:conns` | `conns.md` | List, test, discover connections |

### Agents (`agents/`)

Agents are specialized subagents for complex tasks. Each `.md` file defines:
- Frontmatter with name, description, model, allowed-tools, skills
- Instructions and workflows for the agent

See [docs/AGENTS.md](docs/AGENTS.md) for detailed agent documentation.

### Skills (`skills/`)

Skills provide loadable knowledge/context. Each skill is a separate folder with a `SKILL.md` file that Claude can auto-invoke based on the task:

| Skill | Triggers |
|-------|----------|
| `sling` | General Sling questions, MCP tools reference |
| `sling-connections` | "connection", "connect to", "test connection" |
| `sling-replications` | "replication", "sync", "copy table", "data movement" |
| `sling-pipelines` | "pipeline", "workflow", "multi-step" |
| `sling-transforms` | "transform", "convert", "format", "date function" |
| `sling-hooks` | "hook", "before", "after", "webhook", "notification" |
| `sling-troubleshooting` | "error", "not working", "debug", "fix" |
| `sling-api-specs` | "api spec", "rest api", "endpoint", "pagination" |

The `sling-api-specs` skill includes 12 supporting files for detailed API specification topics (authentication, pagination, processors, etc.).

### Hooks (`hooks/`)

Session hooks run on specific events. Currently configured:
- `SessionStart` - Verify sling CLI is installed

### MCP Configuration (`.mcp.json`)

Configures the Sling MCP server which provides tools:
- `connection` - Manage connections
- `database` - Query databases
- `file_system` - File operations
- `replication` - Run replications
- `pipeline` - Run pipelines
- `api_spec` - Build API specs

## Development Tasks

### Adding a New Command

1. Create `commands/<name>.md`
2. Add frontmatter:
   ```yaml
   ---
   name: <name>
   description: <description>
   allowed-tools: <tools>
   arguments:
     - name: <arg>
       description: <description>
       required: true/false
   ---
   ```
3. Write instructions for Claude

### Adding a New Agent

1. Create `agents/<name>.md`
2. Add frontmatter:
   ```yaml
   ---
   name: <name>
   description: <description>
   model: haiku|sonnet|opus
   allowed-tools: <tools>
   disallowed-tools: <tools>  # optional
   skills:
     - sling-cli  # optional
   ---
   ```
3. Write agent instructions and workflows

### Updating Skills

1. Edit the `SKILL.md` file in the relevant skill directory (e.g., `skills/sling-connections/SKILL.md`)
2. Keep descriptions trigger-rich for Claude auto-invocation
3. Keep content focused on "when" and "why", not exhaustive "how"
4. Link to https://docs.slingdata.io for detailed specs
5. For `sling-api-specs`, supporting files can be added alongside `SKILL.md`

### Testing the Plugin

```bash
# Load plugin locally
claude --plugin-dir /Users/fritz/__/Git/slingdata-ai

# Test commands
/sling:conns list
/sling:run <file>
/sling:prime connections

# Test agents (via Task tool or direct invocation)
```

## Related Repositories

| Repository | Purpose |
|------------|---------|
| [sling-cli](https://github.com/slingdata-io/sling-cli) | Core CLI (Go) |
| [sling-api-spec](https://github.com/slingdata-io/sling-api-spec) | API specifications |
| [sling-docs](https://docs.slingdata.io) | Official documentation |

## MCP Tool Usage

When using Sling MCP tools, follow this pattern:

```json
{
  "action": "<action_name>",
  "input": {
    "parameter": "value"
  }
}
```

### Common Operations

**List connections**:
```json
{"action": "list", "input": {}}
```

**Test connection**:
```json
{"action": "test", "input": {"connection": "MY_CONN", "debug": true}}
```

**Discover streams**:
```json
{"action": "discover", "input": {"connection": "MY_CONN", "pattern": "public.*"}}
```

**Run replication**:
```json
{"action": "run", "input": {"file_path": "/path/to/replication.yaml"}}
```

**Test API spec**:
```json
{"action": "test", "input": {"connection": "MY_API", "endpoints": ["users"], "debug": true, "limit": 10}}
```

## Best Practices

1. **Prefer MCP tools over CLI** - Better integration, structured responses
2. **Use agents for complex tasks** - Keeps main context clean
3. **Load skills before building** - Ensures correct syntax
4. **Test incrementally** - Validate each step before proceeding
5. **Use debug mode** - `"debug": true` for troubleshooting

## Official Documentation

- **Sling Docs**: https://docs.slingdata.io
- **LLM Reference**: https://docs.slingdata.io/llms.txt
- **GitHub**: https://github.com/slingdata-io/sling-cli
