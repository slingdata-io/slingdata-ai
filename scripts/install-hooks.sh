#!/bin/bash
# Install git hooks for sling-ai development

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "Installing git hooks..."

# Create pre-commit hook
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash
# Auto-update VERSION file with current date on each commit

REPO_ROOT=$(git rev-parse --show-toplevel)
VERSION_FILE="$REPO_ROOT/VERSION"

# Generate version: YY.MM.DD
NEW_VERSION=$(date +"%y.%m.%d")

# Write to VERSION file
echo "$NEW_VERSION" > "$VERSION_FILE"

# Stage the updated VERSION file
git add "$VERSION_FILE"

echo "Updated VERSION to $NEW_VERSION"
EOF

chmod +x "$HOOKS_DIR/pre-commit"

echo "Done! Pre-commit hook installed."
echo "VERSION will auto-update to YY.MM.DD on each commit."
