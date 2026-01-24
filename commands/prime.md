---
name: prime
description: Load Sling documentation into context for a specific topic
allowed-tools: Read
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

| Topic | Files Loaded | Use For |
|-------|--------------|---------|
| `connections` | CONNECTIONS.md | Setting up and managing connections |
| `replications` | REPLICATIONS.md | Creating replication configs |
| `pipelines` | PIPELINES.md | Creating multi-step pipelines |
| `api-specs` | api-specs/*.md (12 files) | Building API specifications |
| `transforms` | TRANSFORMS.md | Data transformation functions |
| `hooks` | HOOKS.md | Pre/post hooks in replications |
| `troubleshooting` | TROUBLESHOOTING.md | Debugging common issues |
| `all` | All resources | Full knowledge base |

## Instructions

When the user invokes this command:

1. **Determine the topic** from the argument

2. **Read the corresponding files** from the skills/sling-cli/resources/ directory:

   **connections**:
   - `skills/sling-cli/resources/CONNECTIONS.md`

   **replications**:
   - `skills/sling-cli/resources/REPLICATIONS.md`

   **pipelines**:
   - `skills/sling-cli/resources/PIPELINES.md`

   **api-specs** (load all):
   - `skills/sling-cli/resources/api-specs/README.md`
   - `skills/sling-cli/resources/api-specs/AUTHENTICATION.md`
   - `skills/sling-cli/resources/api-specs/ENDPOINTS.md`
   - `skills/sling-cli/resources/api-specs/REQUEST.md`
   - `skills/sling-cli/resources/api-specs/PAGINATION.md`
   - `skills/sling-cli/resources/api-specs/RESPONSE.md`
   - `skills/sling-cli/resources/api-specs/PROCESSORS.md`
   - `skills/sling-cli/resources/api-specs/VARIABLES.md`
   - `skills/sling-cli/resources/api-specs/QUEUES.md`
   - `skills/sling-cli/resources/api-specs/INCREMENTAL.md`
   - `skills/sling-cli/resources/api-specs/DYNAMIC.md`
   - `skills/sling-cli/resources/api-specs/FUNCTIONS.md`
   - `skills/sling-cli/resources/api-specs/RULES.md`

   **transforms**:
   - `skills/sling-cli/resources/TRANSFORMS.md`

   **hooks**:
   - `skills/sling-cli/resources/HOOKS.md`

   **troubleshooting**:
   - `skills/sling-cli/resources/TROUBLESHOOTING.md`

   **all**:
   - All of the above files

3. **Confirm to the user** what was loaded:
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
