# Pipelines

Pipelines are multi-step workflows that execute a sequence of tasks. Unlike replications (single source to target), pipelines orchestrate multiple operations with control flow.

## When to Use Pipelines

- Run tasks before/after replications
- Chain multiple replications
- Implement data validation
- Send notifications
- Manage file operations
- Create complex workflows

## Basic Structure

```yaml
env:
  MY_VAR: "value"

steps:
  - type: log
    message: "Starting pipeline"

  - type: replication
    path: /path/to/replication.yaml
    id: main_repl

  - type: query
    connection: MY_DB
    query: "SELECT COUNT(*) FROM table"
    if: state.main_repl.status == "success"
```

## MCP Operations

### Parse
```json
{
  "action": "parse",
  "input": {"file_path": "/path/to/pipeline.yaml"}
}
```

### Run
```json
{
  "action": "run",
  "input": {
    "file_path": "/path/to/pipeline.yaml",
    "env": {"MY_VAR": "override"}
  }
}
```

## Step Types

| Type | Description |
|------|-------------|
| `log` | Output messages |
| `run` | Simple data transfer |
| `replication` | Run replication file |
| `query` | Execute SQL |
| `http` | HTTP requests |
| `command` | Shell commands |
| `check` | Validate conditions |
| `copy` | Copy files |
| `delete` | Delete files |
| `write` | Write to files |
| `read` | Read file contents |
| `list` | List files |
| `inspect` | Get file/table metadata |
| `store` | Store values |
| `group` | Group steps, enable looping |

## Common Steps

### log
```yaml
- type: log
  level: info  # debug, info, warn, error
  message: "Processing {env.MY_VAR}"
```

### run (simple transfer)
```yaml
- type: run
  source: "MY_POSTGRES.public.users"
  target: "file://users.csv"
  mode: "full-refresh"
```

### replication
```yaml
- type: replication
  path: /path/to/replication.yaml
  select_streams: ["users", "orders"]
  mode: "incremental"
  env:
    SLING_THREADS: 8
  id: my_repl
```

### query
```yaml
- type: query
  connection: MY_POSTGRES
  query: |
    SELECT COUNT(*) as cnt FROM users
    WHERE created_at > NOW() - INTERVAL '1 day'
  into: result
  id: count_query
```

### http
```yaml
- type: http
  url: "https://api.example.com/webhook"
  method: POST
  headers:
    Authorization: "Bearer {env.API_TOKEN}"
  payload: |
    {"status": "{state.my_repl.status}"}
  into: response
```

### command
```yaml
- type: command
  command: "python validate.py {store.file_path}"
  working_dir: "/scripts"
  into: output
```

### check
```yaml
- type: check
  check: "state.count_query.result[0].cnt > 0"
  failure_message: "No records found"
  on_failure: abort  # abort, warn, quiet, skip
```

### copy
```yaml
- type: copy
  from: "file://data/today/"
  to: "s3://bucket/archive/{YYYY}/{MM}/{DD}/"
  recursive: true
```

### delete
```yaml
- type: delete
  location: "file:///tmp/temp_files/"
  recursive: true
```

### store
```yaml
- type: store
  key: my_value
  value: "something"

# Later: {store.my_value}
```

### group (with loop)
```yaml
- type: group
  loop: ["users", "products", "orders"]
  steps:
    - type: log
      message: "Processing: {loop.value}"
    - type: run
      source: "POSTGRES.public.{loop.value}"
      target: "SNOWFLAKE.staging.{loop.value}"
```

## Control Flow

### Conditional Execution
```yaml
- type: replication
  path: main.yaml
  id: main_job

- type: http
  url: "https://slack.com/webhook"
  method: POST
  payload: '{"text": "Success!"}'
  if: state.main_job.status == "success"

- type: http
  url: "https://slack.com/webhook"
  method: POST
  payload: '{"text": "Failed!"}'
  if: state.main_job.status == "error"
```

### Looping
```yaml
- type: list
  location: "s3://bucket/data/"
  id: files

- type: group
  loop: state.files.result
  steps:
    - type: log
      message: "Processing: {loop.value.name}"
    - type: run
      source: "s3://bucket/{loop.value.path}"
      target: "POSTGRES.staging.imported"
```

## Error Handling

### on_failure Options

| Option | Behavior |
|--------|----------|
| `abort` | Stop pipeline (default) |
| `warn` | Log warning, continue |
| `quiet` | Silent, continue |
| `skip` | Skip step, continue |
| `break` | Exit current group only |

```yaml
- type: delete
  location: "file:///tmp/old/"
  on_failure: warn  # Don't fail if files don't exist
```

## Variables

### Accessing Step Results

```yaml
- type: query
  connection: MY_DB
  query: "SELECT COUNT(*) as cnt FROM users"
  id: user_count

- type: log
  message: "Users: {state.user_count.result[0].cnt}"
```

### Built-in Variables

| Variable | Description |
|----------|-------------|
| `{env.VAR}` | Environment variables |
| `{store.key}` | Stored values |
| `{state.id.*}` | Step results by ID |
| `{timestamp.date}` | Current date |
| `{timestamp.YYYY}` | Year |
| `{loop.value}` | Current loop item |
| `{loop.index}` | Loop iteration index |

## Complete Example

```yaml
env:
  SLACK_WEBHOOK: "${SLACK_WEBHOOK_URL}"

steps:
  - type: log
    message: "Starting data pipeline"

  - type: replication
    path: replications/main.yaml
    id: main_sync

  - type: check
    check: state.main_sync.status == "success"
    on_failure: break

  - type: query
    connection: TARGET_DB
    query: "CALL refresh_materialized_views()"

  - type: http
    url: "{env.SLACK_WEBHOOK}"
    method: POST
    payload: |
      {
        "text": "Pipeline completed: {state.main_sync.total_rows} rows"
      }

  - type: log
    message: "Pipeline finished"
```

## Full Documentation

See https://docs.slingdata.io/concepts/pipeline for complete reference.
