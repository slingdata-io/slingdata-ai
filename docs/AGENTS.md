# Sling AI Agents

This document describes the specialized agents available in the Sling AI plugin.

## Overview

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `api-researcher` | haiku | Research API documentation | Read, WebFetch, browser, gh |
| `api-cross-referencer` | haiku | Compare with competitors | Read, WebFetch, browser |
| `api-spec-builder` | sonnet | Create API specs | Read, Write, Edit, api_spec |
| `api-spec-tester` | sonnet | Test and debug specs | Read, Edit, api_spec, connection |
| `replication-builder` | sonnet | Design replications | Read, Write, Edit, connection, replication, database |
| `pipeline-builder` | sonnet | Design pipelines | Read, Write, Edit, connection, pipeline, database |

---

## API Spec Development Agents

These agents work together to build Sling API specifications for REST API data extraction.

### api-researcher

**Purpose**: Research REST API documentation to gather authentication, endpoints, pagination, and rate limit details.

**Model**: haiku (fast, cost-effective for research)

**Tools**: Read, WebFetch, mcp__browser__*, Bash(gh:*)

**Restrictions**: Cannot write or edit files (read-only research)

**Use when**:
- Starting work on a new API spec
- Need to understand API authentication methods
- Documenting endpoint parameters and response structures
- Identifying pagination patterns

**Output**: Structured research report with authentication, endpoints, pagination, and incremental sync details.

---

### api-cross-referencer

**Purpose**: Compare API coverage with Fivetran and Airbyte connectors to identify supported endpoints and best practices.

**Model**: haiku (fast, cost-effective for research)

**Tools**: Read, WebFetch, mcp__browser__*

**Restrictions**: Cannot write or edit files (read-only research)

**Use when**:
- Determining which endpoints to prioritize
- Checking what competitors support
- Finding incremental sync strategies used by others
- Identifying gaps in existing Sling specs

**Output**: Comparison table showing endpoint coverage across platforms with recommendations.

---

### api-spec-builder

**Purpose**: Create and implement Sling API specification YAML files based on research findings.

**Model**: sonnet (capable reasoning for complex YAML generation)

**Tools**: Read, Write, Edit, mcp__sling__api_spec

**Skills**: sling-cli (preloaded for documentation context)

**Use when**:
- Creating a new API specification from scratch
- Adding endpoints to existing specs
- Implementing authentication, pagination, and response processing

**Output**: Complete API specification YAML file ready for testing.

---

### api-spec-tester

**Purpose**: Test and debug Sling API specifications, diagnosing issues with authentication, pagination, JMESPath expressions, and incremental sync.

**Model**: sonnet (capable reasoning for debugging)

**Tools**: Read, Edit, mcp__sling__api_spec, mcp__sling__connection

**Skills**: sling-cli (preloaded for documentation context)

**Use when**:
- Testing a newly created spec
- Debugging authentication failures (401/403)
- Fixing pagination issues (incomplete data, loops)
- Correcting JMESPath expressions (empty results)
- Resolving rate limiting issues (429)

**Output**: Test results with fixes applied and verification of working endpoints.

---

## Data Integration Agents

These agents help design replication and pipeline configurations.

### replication-builder

**Purpose**: Design and create Sling replication YAML configurations for moving data between databases, file systems, and APIs.

**Model**: sonnet (capable reasoning for configuration design)

**Tools**: Read, Write, Edit, mcp__sling__connection, mcp__sling__replication, mcp__sling__database

**Skills**: sling-cli (preloaded for documentation context)

**Use when**:
- Setting up database-to-database replication
- Loading files into databases
- Exporting data to files (CSV, Parquet, JSON)
- Syncing API data to databases
- Designing incremental sync strategies

**Output**: Complete replication YAML file with appropriate modes, streams, and options.

---

### pipeline-builder

**Purpose**: Design and create Sling pipeline YAML configurations for multi-step data workflows.

**Model**: sonnet (capable reasoning for workflow design)

**Tools**: Read, Write, Edit, mcp__sling__connection, mcp__sling__pipeline, mcp__sling__database

**Skills**: sling-cli (preloaded for documentation context)

**Use when**:
- Orchestrating multiple replications
- Adding pre/post processing steps
- Implementing data validation checks
- Sending notifications on success/failure
- Processing files dynamically (list, copy, delete)
- Creating conditional data flows

**Output**: Complete pipeline YAML file with steps, conditions, and error handling.

---

## Agent Workflow Examples

### Building a New API Spec

1. **api-researcher** → Research the API documentation
2. **api-cross-referencer** → Check what Fivetran/Airbyte support
3. **api-spec-builder** → Create the specification
4. **api-spec-tester** → Test and debug until working

### Setting Up Data Sync

1. **replication-builder** → Design the replication config
2. Use `/sling:run` to test execution
3. **pipeline-builder** → Wrap in pipeline if notifications/validation needed

---

## Design Decisions

### Why haiku for research agents?

Research agents (api-researcher, api-cross-referencer) use haiku because:
- They perform read-only operations
- Speed matters for iterative research
- Lower cost for potentially many web fetches
- No complex reasoning needed for data gathering

### Why sonnet for builder/tester agents?

Builder and tester agents use sonnet because:
- Complex YAML generation requires stronger reasoning
- Debugging requires understanding error context
- Configuration design involves trade-off decisions
- These agents modify files and need accuracy

### Why preload skills in builder agents?

Builder agents have `skills: [sling-cli]` because:
- They need immediate access to syntax documentation
- Reduces need for additional file reads
- Ensures consistent, correct YAML structure
- Speeds up spec/config generation
