#!/bin/bash
# Test a Sling connection
# Usage: ./test-connection.sh <connection_name> [--debug]

set -e

show_help() {
    echo "Usage: $0 <connection_name> [--debug]"
    echo ""
    echo "Test a Sling connection"
    echo ""
    echo "Arguments:"
    echo "  connection_name    Name of the connection to test"
    echo ""
    echo "Options:"
    echo "  --debug           Enable debug output"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 MY_POSTGRES"
    echo "  $0 MY_S3 --debug"
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ -z "$1" ]]; then
    echo "Error: Connection name required"
    show_help
    exit 1
fi

CONNECTION="$1"
DEBUG_FLAG=""

if [[ "$2" == "--debug" ]]; then
    DEBUG_FLAG="--debug"
fi

echo "Testing connection: $CONNECTION"
sling conns test "$CONNECTION" $DEBUG_FLAG
