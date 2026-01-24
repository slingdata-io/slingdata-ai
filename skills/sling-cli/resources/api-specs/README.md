# API Specifications

API specs are YAML definitions for extracting data from REST APIs. They handle authentication, pagination, response processing, and incremental sync automatically.

## When to Use

- Extract data from REST APIs (GET endpoints only)
- Build incremental sync workflows
- Handle complex pagination patterns
- Process nested JSON responses
- Chain multiple API calls with queues

## Basic Structure

```yaml
name: "My API"
description: "Data extraction from My API"

authentication:
  type: "static"
  headers:
    Authorization: "Bearer {secrets.api_token}"

defaults:
  state:
    base_url: "https://api.example.com/v1"
  request:
    headers:
      Accept: "application/json"

endpoints:
  users:
    description: "Fetch users"
    request:
      url: "{state.base_url}/users"
    response:
      records:
        jmespath: "data[]"
        primary_key: ["id"]
```

## MCP Operations

### Parse a Spec
```json
{
  "action": "parse",
  "input": {"file_path": "/path/to/spec.yaml"}
}
```

### Test Endpoints
```json
{
  "action": "test",
  "input": {
    "connection": "MY_API",
    "endpoints": ["users"],
    "debug": true,
    "limit": 10
  }
}
```

## Topics in This Folder

| File | Topic |
|------|-------|
| [AUTHENTICATION.md](AUTHENTICATION.md) | All 8 authentication types |
| [ENDPOINTS.md](ENDPOINTS.md) | Endpoint config, setup/teardown |
| [REQUEST.md](REQUEST.md) | HTTP request options |
| [PAGINATION.md](PAGINATION.md) | All pagination patterns |
| [RESPONSE.md](RESPONSE.md) | Record extraction, deduplication |
| [PROCESSORS.md](PROCESSORS.md) | Transformations, aggregations |
| [VARIABLES.md](VARIABLES.md) | Scopes, expressions, rendering order |
| [QUEUES.md](QUEUES.md) | Queues and iteration |
| [INCREMENTAL.md](INCREMENTAL.md) | Sync state, context variables |
| [DYNAMIC.md](DYNAMIC.md) | Runtime endpoint generation |
| [FUNCTIONS.md](FUNCTIONS.md) | Expression functions reference |
| [RULES.md](RULES.md) | Response rules, retries |

## Full Documentation

See https://docs.slingdata.io/concepts/api-specs for complete reference.
