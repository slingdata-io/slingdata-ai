---
name: run
description: Execute a Sling replication or pipeline file
allowed-tools: Read, mcp__sling__replication, mcp__sling__pipeline
arguments:
  - name: file
    description: Path to the YAML file to execute
    required: true
---

# /sling:run - Execute Replication or Pipeline

Execute a Sling replication or pipeline YAML file.

## Usage

```
/sling:run <file.yaml>
```

## Instructions

When the user invokes this command with a file path:

1. **Read the file** to determine its type:
   - If the file contains `streams:` → it's a **replication**
   - If the file contains `steps:` → it's a **pipeline**

2. **Validate the file** using the appropriate MCP parse action:
   - For replications: `{"action": "parse", "input": {"file_path": "<path>"}}`
   - For pipelines: `{"action": "parse", "input": {"file_path": "<path>"}}`

3. **If validation fails**, report the errors and suggest fixes

4. **If validation succeeds**, ask the user to confirm execution:
   - Show the source and target connections
   - Show the streams/steps that will be executed
   - Wait for confirmation before running

5. **Execute the file** using the appropriate MCP run action:
   - For replications: `{"action": "run", "input": {"file_path": "<path>"}}`
   - For pipelines: `{"action": "run", "input": {"file_path": "<path>"}}`

6. **Report results**:
   - Show success/failure status
   - Show row counts for replications
   - Show step outcomes for pipelines

## Examples

```
/sling:run replications/postgres-to-snowflake.yaml
/sling:run pipelines/daily-sync.yaml
```

## Error Handling

- If the file doesn't exist, suggest checking the path
- If the file has syntax errors, show the line numbers and issues
- If connections fail, suggest running `/sling:conns test <name>`
