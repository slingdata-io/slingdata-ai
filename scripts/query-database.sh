#!/bin/bash
# Execute a SQL query against a database connection
# Usage: ./query-database.sh <connection_name> <query>

set -e

show_help() {
    echo "Usage: $0 <connection_name> <query>"
    echo ""
    echo "Execute a SQL query against a Sling database connection"
    echo ""
    echo "Arguments:"
    echo "  connection_name    Name of the database connection"
    echo "  query             SQL query to execute"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 MY_POSTGRES 'SELECT 1'"
    echo "  $0 MY_POSTGRES 'SELECT * FROM users LIMIT 10'"
    echo "  $0 MY_SNOWFLAKE 'SHOW TABLES IN SCHEMA public'"
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Error: Connection name and query required"
    show_help
    exit 1
fi

CONNECTION="$1"
QUERY="$2"

echo "Executing query on: $CONNECTION"
echo "Query: $QUERY"
echo ""
sling conns exec "$CONNECTION" -q "$QUERY"
