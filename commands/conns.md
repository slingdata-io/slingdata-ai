---
name: conns
description: Manage Sling connections - list, test, or discover streams
allowed-tools: mcp__sling__connection, mcp__sling__database
arguments:
  - name: action
    description: "Action to perform: list, test, or discover"
    required: true
  - name: name
    description: Connection name (required for test and discover)
    required: false
---

# /sling:conns - Connection Management

Manage Sling connections including listing, testing, and discovering streams.

## Usage

```
/sling:conns list
/sling:conns test <connection_name>
/sling:conns discover <connection_name> [pattern]
```

## Actions

### list

List all configured connections with their types and status.

```
/sling:conns list
```

**MCP Tool**:
```json
{"action": "list", "input": {}}
```

Display the connections in a table format:
| Name | Type | Status |
|------|------|--------|

### test

Test connectivity to a specific connection.

```
/sling:conns test MY_POSTGRES
```

**MCP Tool**:
```json
{
  "action": "test",
  "input": {
    "connection": "<name>",
    "debug": true
  }
}
```

Report:
- Connection success/failure
- Connection details (host, database, etc.)
- Any error messages with troubleshooting suggestions

### discover

Discover available streams (tables, files, endpoints) in a connection.

```
/sling:conns discover MY_POSTGRES
/sling:conns discover MY_POSTGRES public.*
/sling:conns discover MY_S3 data/*.csv
```

**MCP Tool**:
```json
{
  "action": "discover",
  "input": {
    "connection": "<name>",
    "pattern": "<pattern>",
    "columns": false
  }
}
```

Display discovered streams in a list or table format.

For database connections with a pattern, also offer to show column details:
```json
{
  "action": "discover",
  "input": {
    "connection": "<name>",
    "pattern": "<pattern>",
    "columns": true
  }
}
```

## Connection Types

| Type | Discovery Pattern Examples |
|------|---------------------------|
| Database | `public.*`, `sales.customer_*` |
| File System | `data/*.csv`, `logs/**/*.json` |
| API | Endpoints from spec |

## Troubleshooting

If a connection test fails:

1. **Connection refused**: Check host/port accessibility, firewall rules
2. **Authentication failed**: Verify username/password in `~/.sling/env.yaml`
3. **SSL errors**: Check certificate configuration
4. **Missing connection**: Connection not defined in `~/.sling/env.yaml`

Suggest the user check their `~/.sling/env.yaml` file or set environment variables.
