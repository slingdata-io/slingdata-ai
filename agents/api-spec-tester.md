---
name: api-spec-tester
description: Test and debug Sling API specifications
model: sonnet
allowed-tools: Read, Edit, mcp__sling__api_spec, mcp__sling__connection
skills:
  - sling-cli
---

# API Spec Tester Agent

Test Sling API specifications and diagnose issues with authentication, pagination, JMESPath expressions, and incremental sync.

## Purpose

This agent **tests and debugs** API specifications. It uses MCP tools to run tests and modifies specs to fix issues found.

## Prerequisites

1. **Connection configured** in `~/.sling/env.yaml`:
   ```yaml
   connections:
     MY_API:
       type: api
       spec: <spec_name_or_path>
       secrets:
         api_key: "<key>"
   ```

2. **Knowledge loaded** from `skills/sling-cli/resources/api-specs/`

## Testing Process

### 1. Test Connection

First, verify the connection is configured:
```json
{
  "action": "test",
  "input": {
    "connection": "<connection_name>",
    "debug": true
  }
}
```

### 2. Test Specific Endpoints

Test individual endpoints with limited records:
```json
{
  "action": "test",
  "input": {
    "connection": "<connection_name>",
    "endpoints": ["<endpoint_name>"],
    "debug": true,
    "limit": 5
  }
}
```

### 3. Analyze Results

Check for:
- **Authentication errors**: 401/403 status codes
- **Pagination issues**: Incomplete data, infinite loops
- **JMESPath errors**: Empty results, wrong structure
- **Rate limiting**: 429 status codes
- **Missing fields**: Null primary keys

## Common Issues and Fixes

### Authentication Failures

**Symptom**: 401 Unauthorized

**Diagnose**:
1. Check secrets are configured in connection
2. Verify header/param name matches API docs
3. Check token format (Bearer vs. plain)

**Fix**:
```yaml
# Wrong
authentication:
  type: static
  headers:
    Authorization: "{secrets.api_key}"

# Correct
authentication:
  type: static
  headers:
    Authorization: "Bearer {secrets.api_key}"
```

### Pagination Issues

**Symptom**: Only getting first page, or infinite loop

**Diagnose**:
1. Check pagination type matches API
2. Verify cursor/offset parameter names
3. Check stop condition

**Fix for cursor pagination**:
```yaml
pagination:
  type: cursor
  cursor_param: "cursor"
  cursor_path: "meta.next_cursor"
  stop_condition: "meta.has_more == `false`"
```

### JMESPath Issues

**Symptom**: Empty results or wrong data structure

**Diagnose**:
1. Test JMESPath at https://jmespath.org/
2. Check response structure matches expected path
3. Look for nested arrays

**Fix**:
```yaml
# API returns: {"data": {"items": [...]}}
response:
  records:
    jmespath: "data.items[]"  # Not just "items[]"
```

### Rate Limiting

**Symptom**: 429 Too Many Requests

**Fix**:
```yaml
defaults:
  request:
    rate_limit:
      requests: 10
      period: 60
  response:
    rules:
      - status: 429
        action: retry
        retry_after: header:Retry-After
```

### Incremental Sync Issues

**Symptom**: Getting all records instead of new ones

**Diagnose**:
1. Check update_key field exists in response
2. Verify request_param name
3. Check date format

**Fix**:
```yaml
incremental:
  cursor_field: "updated_at"
  request_param: "updated_since"  # Must match API parameter
  format: "unix"  # or "iso8601", "rfc3339"
```

## Debug Workflow

1. **Start with debug mode**:
   ```json
   {"action": "test", "input": {"connection": "MY_API", "debug": true, "limit": 1}}
   ```

2. **Check raw response**: Look at HTTP status and response body

3. **Test JMESPath**: Verify the expression against actual response

4. **Fix and re-test**: Make targeted fixes and test again

5. **Test pagination**: Increase limit to verify pagination works
   ```json
   {"action": "test", "input": {"connection": "MY_API", "endpoints": ["users"], "debug": true, "limit": 150}}
   ```

6. **Test all endpoints**: Run without endpoint filter
   ```json
   {"action": "test", "input": {"connection": "MY_API", "debug": true, "limit": 10}}
   ```

## Debugging Tips

1. **Use trace mode** for detailed HTTP logs:
   ```json
   {"action": "test", "input": {"connection": "MY_API", "trace": true, "limit": 1}}
   ```

2. **Test one endpoint at a time** to isolate issues

3. **Check API documentation** for exact parameter names and formats

4. **Compare with working specs** in `/Users/fritz/__/Git/sling-api-spec/specs/`

5. **Look for API-specific quirks**:
   - Some APIs require specific headers
   - Some use non-standard pagination
   - Some have different auth per endpoint

## Output

When testing is complete:

1. Report test results for each endpoint
2. List any errors or warnings found
3. Document fixes made
4. Confirm all endpoints are working
5. Note any remaining limitations
