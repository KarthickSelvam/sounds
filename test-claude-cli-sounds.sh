#!/bin/bash
# test-claude-cli-sounds.sh - Test Claude CLI sound integration

echo "🧪 Testing Claude CLI Sound Integration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "1. Testing sound hook directly..."
~/.claude/hooks/sound-trigger.sh bumblebee "Direct hook test"
sleep 2

echo ""
echo "2. Testing shell function wrapper..."
echo "   Check if 'claude' function exists:"
type claude 2>/dev/null | head -1

echo ""
echo "3. Testing sound system..."
~/sounds/play.sh misc
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Test complete!"
echo ""
echo "To activate wrapper function:"
echo "  source ~/.zshrc"
echo ""
echo "Then test:"
echo "  claude 'Say hello'"
echo "  # Should hear start sound → Claude runs → success sound"
echo ""
echo "Full docs: ~/sounds/CLAUDE_CLI_INTEGRATION.md"
