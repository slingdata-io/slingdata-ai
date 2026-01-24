#!/bin/bash
# Build the Sling binary from source
# Usage: ./build-sling.sh [sling-cli-path]

set -e

show_help() {
    echo "Usage: $0 [sling-cli-path]"
    echo ""
    echo "Build the Sling binary from source"
    echo ""
    echo "Arguments:"
    echo "  sling-cli-path    Path to sling-cli repository (default: ../sling-cli)"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 /path/to/sling-cli"
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

SLING_CLI_PATH="${1:-../sling-cli}"

if [[ ! -d "$SLING_CLI_PATH" ]]; then
    echo "Error: sling-cli directory not found: $SLING_CLI_PATH"
    exit 1
fi

CMD_SLING_PATH="$SLING_CLI_PATH/cmd/sling"

if [[ ! -d "$CMD_SLING_PATH" ]]; then
    echo "Error: cmd/sling directory not found: $CMD_SLING_PATH"
    exit 1
fi

echo "Building sling from: $CMD_SLING_PATH"
cd "$CMD_SLING_PATH"

echo "Running go mod tidy..."
go mod tidy

echo "Building sling binary..."
go build -o sling .

echo ""
echo "Build complete!"
echo "Binary location: $CMD_SLING_PATH/sling"
echo ""
./sling --version
