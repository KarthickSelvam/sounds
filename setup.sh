#!/bin/bash
# setup.sh - One-command Bumblebee Sound System installer
# Usage: curl -s https://raw.githubusercontent.com/KarthickSelvam/sounds/main/setup.sh | bash
set -e

SOUNDS_DIR="$HOME/sounds"
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SETTINGS="$CLAUDE_DIR/settings.json"
HOOK_SCRIPT="$HOOKS_DIR/bumblebee-sounds.sh"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Bumblebee Sound System Installer   ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# ─── Step 1: Get the code ────────────────────────────────────────────
echo "Step 1/3: Downloading Bumblebee..."

if [ -d "$SOUNDS_DIR/.git" ]; then
    echo "  Already installed at $SOUNDS_DIR, updating..."
    git -C "$SOUNDS_DIR" pull --quiet
else
    if [ -d "$SOUNDS_DIR" ]; then
        # Directory exists but isn't a git repo (sound files from a previous setup)
        BACKUP="$SOUNDS_DIR.backup-$(date +%Y%m%d%H%M%S)"
        echo "  Backing up existing $SOUNDS_DIR to $BACKUP"
        mv "$SOUNDS_DIR" "$BACKUP"
    fi
    git clone --quiet https://github.com/KarthickSelvam/sounds.git "$SOUNDS_DIR"
fi
echo "  Done."
echo ""

# ─── Step 2: Generate sounds ─────────────────────────────────────────
echo "Step 2/3: Generating sounds..."

# Build from macOS system sounds
"$SOUNDS_DIR/build-library.sh" > /dev/null 2>&1 || true

# Generate voice clips + download robot sounds
"$SOUNDS_DIR/download-bumblebee-sounds.sh" > /dev/null 2>&1 || true

TOTAL=$(find "$SOUNDS_DIR"/{success,fail,neutral,misc} -type f \( -name "*.aiff" -o -name "*.mp3" \) 2>/dev/null | wc -l | tr -d ' ')
echo "  Generated $TOTAL sounds."
echo ""

# ─── Step 3: Configure Claude Code hooks ─────────────────────────────
echo "Step 3/3: Configuring Claude Code hooks..."

# Create hooks directory
mkdir -p "$HOOKS_DIR"

# Write the hook script
cat > "$HOOK_SCRIPT" << 'HOOKEOF'
#!/bin/bash
# bumblebee-sounds.sh - Make Claude Code sound like Bumblebee
SOUNDS_DIR="$HOME/sounds"
EVENT="${1:-}"

play_sound() { "$SOUNDS_DIR/play.sh" "$1" 2>/dev/null & }

case "$EVENT" in
    session-start)  play_sound "misc" ;;
    bash-result)
        INPUT=$(cat 2>/dev/null)
        EXIT_CODE=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_response', {}).get('exit_code', 0))
except:
    print(0)
" 2>/dev/null)
        [ "$EXIT_CODE" != "0" ] && [ -n "$EXIT_CODE" ] && play_sound "fail"
        ;;
    file-op)        play_sound "neutral" ;;
    stop)           play_sound "success" ;;
    notification)   play_sound "misc" ;;
    subagent-start) play_sound "misc" ;;
    subagent-stop)  play_sound "neutral" ;;
esac
exit 0
HOOKEOF
chmod +x "$HOOK_SCRIPT"

# Merge hooks into existing settings.json (never overwrite)
BUMBLEBEE_HOOKS=$(cat << 'JSON'
{
  "SessionStart": [{"hooks": [{"type": "command", "command": "HOOK_PATH session-start", "async": true}]}],
  "PostToolUse": [
    {"matcher": "Bash", "hooks": [{"type": "command", "command": "HOOK_PATH bash-result", "async": true}]},
    {"matcher": "Edit|Write|MultiEdit", "hooks": [{"type": "command", "command": "HOOK_PATH file-op", "async": true}]}
  ],
  "Stop": [{"hooks": [{"type": "command", "command": "HOOK_PATH stop", "async": true}]}],
  "Notification": [{"hooks": [{"type": "command", "command": "HOOK_PATH notification", "async": true}]}],
  "SubagentStart": [{"hooks": [{"type": "command", "command": "HOOK_PATH subagent-start", "async": true}]}],
  "SubagentStop": [{"hooks": [{"type": "command", "command": "HOOK_PATH subagent-stop", "async": true}]}]
}
JSON
)

# Replace placeholder with actual path
BUMBLEBEE_HOOKS=$(echo "$BUMBLEBEE_HOOKS" | sed "s|HOOK_PATH|$HOOK_SCRIPT|g")

python3 << PYEOF
import json, os, shutil
from datetime import datetime

settings_path = "$SETTINGS"
hook_script = "$HOOK_SCRIPT"

# Load new hooks
new_hooks = json.loads('''$BUMBLEBEE_HOOKS''')

# Load existing settings or start fresh
settings = {}
if os.path.exists(settings_path):
    # Backup first
    backup = settings_path + ".backup-" + datetime.now().strftime("%Y%m%d%H%M%S")
    shutil.copy2(settings_path, backup)
    print(f"  Backed up settings to {backup}")
    with open(settings_path) as f:
        settings = json.load(f)

# Remove any existing bumblebee hooks (to avoid duplicates on re-install)
if "hooks" in settings:
    for event_name, entries in settings["hooks"].items():
        settings["hooks"][event_name] = [
            entry for entry in entries
            if not any(
                hook_script in h.get("command", "")
                for h in entry.get("hooks", [])
            )
        ]
        # Clean up empty arrays
        if not settings["hooks"][event_name]:
            del settings["hooks"][event_name]

# Merge new hooks into existing
if "hooks" not in settings:
    settings["hooks"] = {}

for event_name, new_entries in new_hooks.items():
    if event_name not in settings["hooks"]:
        settings["hooks"][event_name] = []
    settings["hooks"][event_name].extend(new_entries)

# Write back
with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print("  Hooks merged into settings.json")
PYEOF

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║        Installation complete!        ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  Sounds will play automatically in Claude Code:"
echo "    - Session start    -> Bumblebee online"
echo "    - Command fails    -> Error sound"
echo "    - File edited      -> Neutral blip"
echo "    - Task complete    -> Victory sound"
echo ""
echo "  Test it:  ~/sounds/play.sh success"
echo "  Uninstall: ~/sounds/uninstall.sh"
echo ""
