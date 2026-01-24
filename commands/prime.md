---
name: sling:prime
description: Load Sling documentation into context for a specific topic
allowed-tools: Read, Glob, WebFetch
arguments:
  - name: topic
    description: "Topic to load: connections, replications, pipelines, api-specs, transforms, hooks, troubleshooting, all"
    required: true
---

# /sling:prime - Load Knowledge Into Context

Load topic-specific Sling documentation into the conversation context. This helps the assistant provide more accurate and detailed guidance.

## Usage

```
/sling:prime <topic>
```

## Topics

| Topic | Description |
|-------|-------------|
| `connections` | Setting up and managing connections |
| `replications` | Creating replication configs |
| `pipelines` | Creating multi-step pipelines |
| `api-specs` | Building API specifications |
| `transforms` | Data transformation functions |
| `hooks` | Pre/post hooks in replications |
| `troubleshooting` | Debugging common issues |
| `all` | Full knowledge base |

## Instructions

When the user invokes this command:

1. **Determine the topic** from the argument

2. **Find the plugin root** by using Glob to locate the skills directory:
   ```
   Glob pattern: "**/skills/sling-cli/resources/CONNECTIONS.md"
   ```
   Extract the base path from the result (everything before `skills/sling-cli/resources/`)

3. **Read the corresponding files** based on topic:

   **connections**:
   - `<plugin_root>/skills/sling-cli/resources/CONNECTIONS.md`

   **replications**:
   - `<plugin_root>/skills/sling-cli/resources/REPLICATIONS.md`

   **pipelines**:
   - `<plugin_root>/skills/sling-cli/resources/PIPELINES.md`

   **api-specs** (load all 13 files):
   - `<plugin_root>/skills/sling-cli/resources/api-specs/README.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/AUTHENTICATION.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/ENDPOINTS.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/REQUEST.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/PAGINATION.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/RESPONSE.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/PROCESSORS.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/VARIABLES.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/QUEUES.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/INCREMENTAL.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/DYNAMIC.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/FUNCTIONS.md`
   - `<plugin_root>/skills/sling-cli/resources/api-specs/RULES.md`

   **transforms**:
   - `<plugin_root>/skills/sling-cli/resources/TRANSFORMS.md`

   **hooks**:
   - `<plugin_root>/skills/sling-cli/resources/HOOKS.md`

   **troubleshooting**:
   - `<plugin_root>/skills/sling-cli/resources/TROUBLESHOOTING.md`

   **all**:
   - All of the above files

4. **Confirm to the user** what was loaded:
   - List the files read
   - Summarize the topics covered
   - Indicate readiness to help with that topic

## Examples

```
/sling:prime connections
→ Loaded connection management documentation. Ready to help with setting up databases, file systems, and API connections.

/sling:prime api-specs
→ Loaded 13 API specification files covering authentication, pagination, endpoints, and more. Ready to help build API specs.

/sling:prime all
→ Loaded full Sling knowledge base (21 files). Ready to assist with any Sling topic.
```

## Notes

- Use this before asking complex questions about a specific topic
- For quick questions, the base SKILL.md context is usually sufficient
- For API spec development, always prime with `api-specs` first
