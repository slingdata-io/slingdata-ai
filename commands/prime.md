---
name: sling:prime
description: Load Sling documentation into context for a specific topic
allowed-tools: Read, Glob
arguments:
  - name: topic
    description: "Topic to load: connections, replications, pipelines, api-specs, transforms, hooks, troubleshooting, all"
    required: true
---

# /sling:prime - Load Knowledge Into Context

Load topic-specific Sling documentation into the conversation context.

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

1. **Find the plugin's skill resources** by searching for the installed plugin:
   - Use Glob to find: `~/.claude/plugins/cache/**/sling-cli/resources/CONNECTIONS.md`
   - The parent directory of the found file is the resources directory

2. **Read the requested topic files** from that resources directory:

   **connections**: Read `CONNECTIONS.md`

   **replications**: Read `REPLICATIONS.md`

   **pipelines**: Read `PIPELINES.md`

   **api-specs**: Read all files in `api-specs/` subdirectory (13 files)

   **transforms**: Read `TRANSFORMS.md`

   **hooks**: Read `HOOKS.md`

   **troubleshooting**: Read `TROUBLESHOOTING.md`

   **all**: Read all of the above

3. **Confirm to the user** what was loaded and indicate readiness to help with that topic.

## Example Glob Path

```
~/.claude/plugins/cache/**/sling-cli/resources/CONNECTIONS.md
```

This will find files like:
```
/Users/fritz/.claude/plugins/cache/slingdata-ai/sling/1.0.0/skills/sling-cli/resources/CONNECTIONS.md
```
