#!/bin/bash
# Run a Sling pipeline file
# Usage: ./run-pipeline.sh <pipeline.yaml> [options]

set -e

show_help() {
    echo "Usage: $0 <pipeline.yaml> [options]"
    echo ""
    echo "Run a Sling pipeline file"
    echo ""
    echo "Arguments:"
    echo "  pipeline.yaml      Path to the pipeline YAML file"
    echo ""
    echo "Options:"
    echo "  --debug           Enable debug output"
    echo "  --trace           Enable trace output (very verbose)"
    echo "  --parse           Parse only, don't execute"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 pipeline.yaml"
    echo "  $0 pipeline.yaml --debug"
    echo "  $0 pipeline.yaml --parse"
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ -z "$1" ]]; then
    echo "Error: Pipeline file required"
    show_help
    exit 1
fi

PIPELINE_FILE="$1"
shift

if [[ ! -f "$PIPELINE_FILE" ]]; then
    echo "Error: File not found: $PIPELINE_FILE"
    exit 1
fi

echo "Running pipeline: $PIPELINE_FILE"
sling run -p "$PIPELINE_FILE" "$@"
