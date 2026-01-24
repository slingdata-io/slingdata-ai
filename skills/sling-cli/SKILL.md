---
name: sling-cli
description: >
  Data integration CLI for moving data between databases, file systems, and APIs.
  Use for replication, ETL pipelines, and API data extraction.
allowed-tools: "Read,Bash(sling:*),mcp__sling__*"
version: "1.0.0"
author: "Sling <https://github.com/slingdata-io>"
license: "AGPL3"
---

# Sling - Data Integration Platform

Move data between 40+ databases, file systems, and APIs with a single CLI. Sling handles connection management, type mapping, and bulk loading automatically.

## When to Use Sling

| Use Case | Solution |
|----------|----------|
| Move data between databases | Replication (DB-to-DB) |
| Load files into databases | Replication (file-to-DB) |
| Export data to files (CSV, Parquet, JSON) | Replication (DB-to-file) |
| Extract API data to database | Replication (API-to-DB) |
| Extract API data to files | Replication (API-to-file) |
| Extract data from REST APIs | API Specs |
| Multi-step data workflows | Pipelines |
| Scheduled data sync | Replications with cron |

## Prerequisites

```bash
sling --version  # Requires v1.2.0+
```

## MCP Tools (Preferred)

Use MCP tools for interactive operations:

| Tool | Actions | Use Case |
|------|---------|----------|
| `connection` | list, test, discover, set | Manage connections |
| `database` | query, get_schemata | Inspect/query databases |
| `file_system` | list, copy, inspect | Browse/copy files |
| `replication` | parse, compile, run | Execute data replications |
| `pipeline` | parse, run | Execute multi-step workflows |
| `api_spec` | parse, test | Build API integrations |

**Example**: List connections
```json
{"action": "list", "input": {}}
```

## CLI Quick Reference

```bash
# Connections
sling conns list                    # List all connections
sling conns test MY_CONN            # Test connection
sling conns discover MY_PG          # Discover tables/files

# Run operations
sling run -r replication.yaml       # Run replication file
sling run -p pipeline.yaml          # Run pipeline file
sling run --src-conn PG --src-stream users --tgt-conn SF  # Ad-hoc transfer
```

## Core Concepts

| Concept | Description | Resource |
|---------|-------------|----------|
| Connections | Named endpoints (DB, file, API) | [CONNECTIONS.md](resources/CONNECTIONS.md) |
| Replications | YAML configs for data movement | [REPLICATIONS.md](resources/REPLICATIONS.md) |
| Pipelines | Multi-step workflows | [PIPELINES.md](resources/PIPELINES.md) |
| API Specs | REST API data extraction | [api-specs/](resources/api-specs/) |
| Transforms | Data transformation functions | [TRANSFORMS.md](resources/TRANSFORMS.md) |
| Hooks | Pre/post actions in replications | [HOOKS.md](resources/HOOKS.md) |

## Common Patterns

### Database to Database
```yaml
source: POSTGRES
target: SNOWFLAKE

defaults:
  mode: incremental
  primary_key: [id]
  update_key: updated_at

streams:
  public.*:
```

### File to Database
```yaml
source: S3
target: POSTGRES

defaults:
  mode: full-refresh
  object: staging.{stream_file_name}

streams:
  'data/*.csv':
```

### API to Database
```yaml
source: STRIPE_API
target: POSTGRES

streams:
  customers:
  invoices:
    mode: incremental
```

## Resources

| Resource | Content |
|----------|---------|
| [CONNECTIONS.md](resources/CONNECTIONS.md) | Connection management and discovery |
| [REPLICATIONS.md](resources/REPLICATIONS.md) | Replication modes, streams, options |
| [PIPELINES.md](resources/PIPELINES.md) | Multi-step workflow orchestration |
| [api-specs/](resources/api-specs/) | Building API specifications (12 files) |
| [TRANSFORMS.md](resources/TRANSFORMS.md) | Data transformation functions |
| [HOOKS.md](resources/HOOKS.md) | Hooks and steps reference |
| [TROUBLESHOOTING.md](resources/TROUBLESHOOTING.md) | Common issues and solutions |
| [MCP_TOOLS.md](resources/MCP_TOOLS.md) | MCP tool reference |

## Full Documentation

- **Official Docs**: https://docs.slingdata.io
- **GitHub**: https://github.com/slingdata-io/sling-cli
