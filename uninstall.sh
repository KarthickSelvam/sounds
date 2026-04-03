#!/bin/bash
# uninstall.sh - Remove Bumblebee Sound System
set -e

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"
HOOK_SCRIPT="$CLAUDE_DIR/hooks/bumblebee-sounds.sh"

echo ""
echo "Uninstalling Bumblebee Sound System..."
echo ""

# Remove hook script
if [ -f "$HOOK_SCRIPT" ]; then
    rm "$HOOK_SCRIPT"
    echo "  Removed hook script"
fi

# Remove bumblebee hooks from settings.json
if [ -f "$SETTINGS" ]; then
    python3 << 'PYEOF'
import json, os

settings_path = os.path.expanduser("~/.claude/settings.json")
hook_script = os.path.expanduser("~/.claude/hooks/bumblebee-sounds.sh")

with open(settings_path) as f:
    settings = json.load(f)

if "hooks" in settings:
    for event_name in list(settings["hooks"].keys()):
        settings["hooks"][event_name] = [
            entry for entry in settings["hooks"][event_name]
            if not any(
                "bumblebee-sounds.sh" in h.get("command", "")
                for h in entry.get("hooks", [])
            )
        ]
        if not settings["hooks"][event_name]:
            del settings["hooks"][event_name]

    if not settings["hooks"]:
        del settings["hooks"]

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print("  Removed hooks from settings.json")
PYEOF
fi

echo ""
echo "  Done. Your other Claude settings are untouched."
echo "  Sound files are still at ~/sounds/ — delete manually if you want."
echo ""
