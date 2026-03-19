#!/bin/bash
# setup-global-git-hooks.sh - Configure git to use sound hooks globally
set -e

TEMPLATE_DIR="$HOME/.git-templates"
HOOKS_DIR="$TEMPLATE_DIR/hooks"
SOURCE_DIR="$HOME/sounds/git-hooks"

echo "🔊 Setting up global git hook templates..."

# Create template directory
mkdir -p "$HOOKS_DIR"

# Copy hooks
for hook in post-commit pre-push post-merge post-checkout; do
    if [ -f "$SOURCE_DIR/$hook" ]; then
        cp "$SOURCE_DIR/$hook" "$HOOKS_DIR/$hook"
        chmod +x "$HOOKS_DIR/$hook"
        echo "  ✅ $hook"
    fi
done

# Configure git to use this template
git config --global init.templateDir "$TEMPLATE_DIR"

echo ""
echo "✅ Global git hooks configured!"
echo ""
echo "ALL NEW repos will now get sound hooks automatically."
echo ""
echo "To add to existing repos:"
echo "  cd your-repo && ~/sounds/install-git-hooks.sh"
echo ""
echo "To test: create a new repo and make a commit!"
