#!/bin/bash
# Check for plugin updates from GitHub main branch

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"
REPO_RAW="https://raw.githubusercontent.com/slingdata-io/sling-ai/main"

# Read local version
VERSION_FILE="$PLUGIN_ROOT/VERSION"
if [ ! -f "$VERSION_FILE" ]; then
  exit 0  # No VERSION file, skip
fi
LOCAL=$(cat "$VERSION_FILE" | tr -d '[:space:]')

if [ -z "$LOCAL" ]; then
  exit 0  # Empty version, skip
fi

# Fetch remote version (with timeout, silent on failure)
REMOTE=$(curl -sf --connect-timeout 3 --max-time 5 "$REPO_RAW/VERSION" 2>/dev/null | tr -d '[:space:]')

if [ -z "$REMOTE" ]; then
  exit 0  # Can't fetch, skip silently (offline, etc.)
fi

# Compare versions (YY.MM.DD format - string comparison works)
if [ "$LOCAL" != "$REMOTE" ]; then
  # Check if remote is newer (lexicographic comparison works for YY.MM.DD)
  if [[ "$REMOTE" > "$LOCAL" ]]; then
    echo ""
    echo "┌─────────────────────────────────────────────────────────────┐"
    echo "│  Sling AI plugin update available: $LOCAL → $REMOTE         │"
    echo "│                                                             │"
    echo "│  To update, run:                                            │"
    echo "│    /plugin marketplace update slingdata-io-sling-ai         │"
    echo "│    /plugin update sling-ai@slingdata-io-sling-ai            │"
    echo "│                                                             │"
    echo "│  Or use the interactive UI: /plugin → Marketplaces tab      │"
    echo "└─────────────────────────────────────────────────────────────┘"
    echo ""
  fi
fi

exit 0
