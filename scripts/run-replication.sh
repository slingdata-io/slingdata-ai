#!/bin/bash
# Run a Sling replication file
# Usage: ./run-replication.sh <replication.yaml> [options]

set -e

show_help() {
    echo "Usage: $0 <replication.yaml> [options]"
    echo ""
    echo "Run a Sling replication file"
    echo ""
    echo "Arguments:"
    echo "  replication.yaml   Path to the replication YAML file"
    echo ""
    echo "Options:"
    echo "  --debug           Enable debug output"
    echo "  --trace           Enable trace output (very verbose)"
    echo "  --parse           Parse only, don't execute"
    echo "  --select STREAM   Run only specific stream(s)"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 replication.yaml"
    echo "  $0 replication.yaml --debug"
    echo "  $0 replication.yaml --select users"
    echo "  $0 replication.yaml --parse"
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ -z "$1" ]]; then
    echo "Error: Replication file required"
    show_help
    exit 1
fi

REPLICATION_FILE="$1"
shift

if [[ ! -f "$REPLICATION_FILE" ]]; then
    echo "Error: File not found: $REPLICATION_FILE"
    exit 1
fi

echo "Running replication: $REPLICATION_FILE"
sling run -r "$REPLICATION_FILE" "$@"
