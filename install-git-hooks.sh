#!/bin/bash
# install-git-hooks.sh - Install sound hooks into a git repo
# Usage: cd your-repo && ~/sounds/install-git-hooks.sh

set -e

if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository"
    exit 1
fi

HOOKS_DIR=".git/hooks"
SOURCE_DIR="$HOME/sounds/git-hooks"

echo "🔊 Installing git sound hooks..."

for hook in post-commit pre-push post-merge post-checkout; do
    if [ -f "$SOURCE_DIR/$hook" ]; then
        cp "$SOURCE_DIR/$hook" "$HOOKS_DIR/$hook"
        chmod +x "$HOOKS_DIR/$hook"
        echo "  ✅ $hook"
    fi
done

echo ""
echo "✅ Sound hooks installed!"
echo ""
echo "Hooks:"
echo "  - post-commit: Sound after each commit"
echo "  - pre-push: Sound before pushing"
echo "  - post-merge: Sound after merge"
echo "  - post-checkout: Sound when switching branches"
echo ""
echo "Test: Make a commit and hear the sound!"
