#!/bin/bash
# Discover streams (tables/files) in a connection
# Usage: ./discover-streams.sh <connection_name> [pattern] [options]

set -e

show_help() {
    echo "Usage: $0 <connection_name> [pattern] [options]"
    echo ""
    echo "Discover streams (tables/files) in a Sling connection"
    echo ""
    echo "Arguments:"
    echo "  connection_name    Name of the connection"
    echo "  pattern           Optional glob pattern (e.g., 'public.*', '*.csv')"
    echo ""
    echo "Options:"
    echo "  --columns         Include column metadata"
    echo "  --recursive       List files recursively"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 MY_POSTGRES"
    echo "  $0 MY_POSTGRES 'public.*'"
    echo "  $0 MY_POSTGRES 'public.users' --columns"
    echo "  $0 MY_S3 'data/*.csv' --recursive"
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
PATTERN=""
OPTIONS=""

shift
while [[ $# -gt 0 ]]; do
    case $1 in
        --columns)
            OPTIONS="$OPTIONS --columns"
            shift
            ;;
        --recursive)
            OPTIONS="$OPTIONS --recursive"
            shift
            ;;
        *)
            if [[ -z "$PATTERN" ]]; then
                PATTERN="$1"
            fi
            shift
            ;;
    esac
done

echo "Discovering streams in: $CONNECTION"
if [[ -n "$PATTERN" ]]; then
    echo "Pattern: $PATTERN"
    sling conns discover "$CONNECTION" --pattern "$PATTERN" $OPTIONS
else
    sling conns discover "$CONNECTION" $OPTIONS
fi
