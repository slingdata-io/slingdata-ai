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
│   ├── conns.md            # /sling:conns - Connection management
│   └── prime.md            # /sling:prime - Load documentation
├── agents/                  # Specialized subagents (Claude)
│   ├── api-researcher.md
│   ├── api-cross-referencer.md
│   ├── api-spec-builder.md
│   ├── api-spec-tester.md
│   ├── replication-builder.md
│   └── pipeline-builder.md
├── skills/
│   └── sling-cli/
│       ├── SKILL.md        # Main skill entry point
│       └── resources/      # Documentation files (21 total)
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
| `/sling:prime` | `prime.md` | Load topic documentation into context |

### Agents (`agents/`)

Agents are specialized subagents for complex tasks. Each `.md` file defines:
- Frontmatter with name, description, model, allowed-tools, skills
- Instructions and workflows for the agent

See [docs/AGENTS.md](docs/AGENTS.md) for detailed agent documentation.

### Skills (`skills/`)

Skills provide loadable knowledge/context. The `sling-cli` skill includes:
- `SKILL.md` - Entry point with quick reference
- `resources/` - Detailed documentation by topic:
  - `CONNECTIONS.md` - Connection management
  - `REPLICATIONS.md` - Replication configurations
  - `PIPELINES.md` - Multi-step workflows
  - `TRANSFORMS.md` - Data transformation functions
  - `HOOKS.md` - Pre/post actions
  - `TROUBLESHOOTING.md` - Common issues
  - `MCP_TOOLS.md` - MCP tool reference
  - `api-specs/` - 13 files for API specification development

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

1. Edit files in `skills/sling-cli/resources/`
2. Keep content focused on "when" and "why", not exhaustive "how"
3. Link to https://docs.slingdata.io for detailed specs
4. Update `SKILL.md` if adding new resources

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
