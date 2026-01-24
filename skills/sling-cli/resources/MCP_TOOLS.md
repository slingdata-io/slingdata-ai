# MCP Tool Reference

Sling provides MCP (Model Context Protocol) tools for AI agent integration. Each tool accepts an `action` and `input` parameter.

## Tool Overview

| Tool | Purpose |
|------|---------|
| `connection` | Manage connections |
| `database` | Query and inspect databases |
| `file_system` | Browse and copy files |
| `replication` | Execute data replications |
| `pipeline` | Run multi-step workflows |
| `api_spec` | Build and test API specs |

## connection

Manage Sling connections for databases, file systems, and APIs.

### Actions

| Action | Description |
|--------|-------------|
| `docs` | Get documentation |
| `list` | List all connections |
| `test` | Test connection |
| `discover` | Discover tables/files |
| `set` | Create/update connection |

### Examples

**List connections:**
```json
{"action": "list", "input": {}}
```

**Test connection:**
```json
{
  "action": "test",
  "input": {
    "connection": "MY_POSTGRES",
    "debug": true
  }
}
```

**Discover tables:**
```json
{
  "action": "discover",
  "input": {
    "connection": "MY_POSTGRES",
    "pattern": "public.*",
    "columns": true
  }
}
```

**Create connection:**
```json
{
  "action": "set",
  "input": {
    "name": "MY_POSTGRES",
    "properties": {
      "type": "postgres",
      "host": "localhost",
      "user": "postgres",
      "database": "mydb"
    }
  }
}
```

## database

Query databases and retrieve metadata.

### Actions

| Action | Description |
|--------|-------------|
| `docs` | Get documentation |
| `query` | Execute SQL (read-only) |
| `get_schemata` | Get schema/table/column info |
| `get_schemas` | List schema names |
| `get_columns` | Get column metadata |

### Examples

**Query database:**
```json
{
  "action": "query",
  "input": {
    "connection": "MY_POSTGRES",
    "query": "SELECT * FROM users LIMIT 10",
    "limit": 10
  }
}
```

**Get table columns:**
```json
{
  "action": "get_columns",
  "input": {
    "connection": "MY_POSTGRES",
    "table_name": "public.users"
  }
}
```

**Get schema structure:**
```json
{
  "action": "get_schemata",
  "input": {
    "connection": "MY_POSTGRES",
    "level": "table",
    "schema_name": "public"
  }
}
```

## file_system

Browse and manage files across storage systems.

### Actions

| Action | Description |
|--------|-------------|
| `docs` | Get documentation |
| `list` | List files/directories |
| `copy` | Copy files between locations |
| `inspect` | Get file metadata |

### Examples

**List files:**
```json
{
  "action": "list",
  "input": {
    "connection": "MY_S3",
    "path": "data/",
    "recursive": false,
    "only": "files"
  }
}
```

**Copy files:**
```json
{
  "action": "copy",
  "input": {
    "source_location": "local/data/file.csv",
    "target_location": "s3/bucket/file.csv"
  }
}
```

**Inspect file:**
```json
{
  "action": "inspect",
  "input": {
    "connection": "MY_S3",
    "path": "data/file.parquet"
  }
}
```

## replication

Execute data replications.

### Actions

| Action | Description |
|--------|-------------|
| `docs` | Get documentation |
| `parse` | Validate configuration |
| `compile` | Compile with validation |
| `run` | Execute replication |

### Examples

**Parse configuration:**
```json
{
  "action": "parse",
  "input": {
    "file_path": "/path/to/replication.yaml"
  }
}
```

**Run replication:**
```json
{
  "action": "run",
  "input": {
    "file_path": "/path/to/replication.yaml",
    "select_streams": ["users", "orders"],
    "mode": "incremental",
    "env": {
      "SLING_THREADS": "5"
    }
  }
}
```

**Run with range (backfill):**
```json
{
  "action": "run",
  "input": {
    "file_path": "/path/to/replication.yaml",
    "range": "2024-01-01,2024-01-31"
  }
}
```

## pipeline

Execute multi-step workflows.

### Actions

| Action | Description |
|--------|-------------|
| `docs` | Get documentation |
| `parse` | Validate configuration |
| `run` | Execute pipeline |

### Examples

**Parse pipeline:**
```json
{
  "action": "parse",
  "input": {
    "file_path": "/path/to/pipeline.yaml"
  }
}
```

**Run pipeline:**
```json
{
  "action": "run",
  "input": {
    "file_path": "/path/to/pipeline.yaml",
    "env": {
      "TARGET_SCHEMA": "production"
    }
  }
}
```

## api_spec

Build and test API specifications.

### Actions

| Action | Description |
|--------|-------------|
| `docs` | Get documentation |
| `parse` | Parse spec file |
| `test` | Test endpoints |

### Examples

**Parse API spec:**
```json
{
  "action": "parse",
  "input": {
    "file_path": "/path/to/api_spec.yaml"
  }
}
```

**Test API endpoints:**
```json
{
  "action": "test",
  "input": {
    "connection": "MY_API",
    "endpoints": ["users", "orders"],
    "debug": true,
    "limit": 10
  }
}
```

## Common Workflows

### Discover and Replicate
```json
// 1. List connections
{"action": "list", "input": {}}

// 2. Test source connection
{"action": "test", "input": {"connection": "SOURCE_DB"}}

// 3. Discover tables
{"action": "discover", "input": {"connection": "SOURCE_DB", "pattern": "public.*"}}

// 4. Run replication
{"action": "run", "input": {"file_path": "replication.yaml"}}
```

### Debug Failed Replication
```json
// 1. Parse config first
{"action": "parse", "input": {"file_path": "replication.yaml"}}

// 2. Test connections
{"action": "test", "input": {"connection": "SOURCE_DB", "debug": true}}
{"action": "test", "input": {"connection": "TARGET_DB", "debug": true}}

// 3. Run with debug
{"action": "run", "input": {"file_path": "replication.yaml", "env": {"DEBUG": "true"}}}
```

### Build API Integration
```json
// 1. Get API spec docs
{"action": "docs", "input": {}}

// 2. Parse spec
{"action": "parse", "input": {"file_path": "api_spec.yaml"}}

// 3. Test with limit
{"action": "test", "input": {"connection": "MY_API", "debug": true, "limit": 5}}
```

## Tips

1. **Always get docs first**: Each tool has a `docs` action
2. **Test before run**: Validate connections and configs
3. **Use debug**: Add `"debug": true` for troubleshooting
4. **Limit results**: Use `limit` parameter for testing
5. **Check errors**: Parse responses for error messages
