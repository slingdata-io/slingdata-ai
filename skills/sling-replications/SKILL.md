---
name: sling-replications
description: >
  Configure data replications between sources and targets in Sling.
  Use when creating replication YAML files, setting up data sync, copying tables, or moving data between databases and files.
---

# Replications

Replications are YAML configurations that define data movement from source to target systems.

## Basic Structure

```yaml
source: SOURCE_CONNECTION
target: TARGET_CONNECTION

defaults:
  mode: full-refresh
  object: '{target_schema}.{stream_table}'

streams:
  schema.table1:
  schema.table2:
    mode: incremental
    primary_key: [id]

env:
  SLING_THREADS: 5
```

## MCP Operations

### Parse (validate)
```json
{"action": "parse", "input": {"file_path": "/path/to/replication.yaml"}}
```

### Run
```json
{
  "action": "run",
  "input": {
    "file_path": "/path/to/replication.yaml",
    "select_streams": ["table1"],
    "mode": "incremental"
  }
}
```

## Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `full-refresh` | Drop and recreate table | Complete replacement |
| `incremental` | Upsert by primary key | Ongoing updates |
| `truncate` | Clear then load | Preserve DDL |
| `snapshot` | Append with timestamp | Historical tracking |
| `backfill` | Load date/ID ranges | Historical recovery |

### Incremental Strategies

| Primary Key | Update Key | Strategy |
|-------------|------------|----------|
| Yes | Yes | Load only new records, upsert |
| Yes | No | Load all, upsert by PK |
| No | Yes | Append only new records |

```yaml
streams:
  orders:
    mode: incremental
    primary_key: [order_id]
    update_key: updated_at
```

### Backfill Mode

```yaml
streams:
  large_table:
    mode: backfill
    update_key: created_date
    source_options:
      range: '2023-01-01,2023-12-31'
      chunk_size: 7d
```

## Stream Configuration

```yaml
streams:
  my_table:
    object: schema.target_table     # Target table
    mode: incremental               # Loading mode
    primary_key: [id]               # PK columns
    update_key: updated_at          # Incremental key
    columns: {id: bigint, amount: decimal(10,2)}
    select: [id, name, email]       # or [-password] to exclude
    sql: |                          # Custom SQL
      SELECT * FROM my_table
      WHERE status = 'active'
    disabled: false
```

## Wildcards and Patterns

```yaml
streams:
  public.*:                    # All tables in schema
  sales.customer_*:            # Tables with prefix
  public.sensitive_data:
    disabled: true             # Exclude specific
  'data/*.csv':                # All CSV files
  'logs/**/*.json':            # Recursive matching
```

## Variables

| Variable | Description |
|----------|-------------|
| `{stream_name}` | Full stream name |
| `{stream_schema}` | Source schema |
| `{stream_table}` | Source table |
| `{target_schema}` | Target default schema |
| `{stream_file_name}` | File name without extension |
| `{YYYY}`, `{MM}`, `{DD}` | Date parts |

```yaml
defaults:
  object: '{target_schema}.{stream_schema}_{stream_table}'
```

## Source Options

### Database Sources

| Option | Description |
|--------|-------------|
| `limit` | Max rows to read |
| `empty_as_null` | Treat empty strings as NULL |
| `chunk_size` | Time interval per chunk (e.g., `6h`) |

### File Sources

| Option | Description |
|--------|-------------|
| `format` | csv, json, parquet, xlsx |
| `header` | First row is header |
| `delimiter` | Column delimiter |
| `encoding` | Character encoding |
| `jmespath` | Extract JSON data |

```yaml
defaults:
  source_options:
    format: csv
    header: true
    encoding: utf8
```

## Target Options

### Database Targets

| Option | Description |
|--------|-------------|
| `column_casing` | snake, upper, lower, source |
| `add_new_columns` | Auto-add new columns |
| `use_bulk` | Use bulk loading |

### File Targets

| Option | Description |
|--------|-------------|
| `format` | csv, parquet, jsonlines |
| `compression` | gzip, snappy, zstd |
| `file_max_rows` | Split files by row count |

## Environment Variables

```yaml
env:
  SLING_THREADS: 10           # Parallel streams
  SLING_RETRIES: 3            # Retry failed streams
  SLING_LOADED_AT_COLUMN: true
```

## Examples

### Database to Database

```yaml
source: POSTGRES
target: SNOWFLAKE

defaults:
  mode: incremental
  object: 'warehouse.{stream_schema}_{stream_table}'
  primary_key: [id]
  update_key: updated_at

streams:
  public.customers:
  public.orders:
  public.products:
```

### Files to Database

```yaml
source: S3
target: POSTGRES

defaults:
  mode: full-refresh
  object: 'staging.{stream_file_name}'
  source_options:
    format: csv
    header: true

streams:
  'data/customers/*.csv':
  'data/orders/*.csv':
```

### Database to Files

```yaml
source: POSTGRES
target: S3

defaults:
  mode: full-refresh
  object: 'exports/{stream_table}/{YYYY}/{MM}/'
  target_options:
    format: parquet
    compression: snappy

streams:
  public.transactions:
  public.events:
```

## Full Documentation

See https://docs.slingdata.io/concepts/replication.md for complete reference.
