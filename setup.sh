#!/bin/bash
# setup.sh - One-command Bumblebee Sound System installer
# Usage: curl -sL https://raw.githubusercontent.com/KarthickSelvam/sounds/main/setup.sh | bash
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
    echo "  Already installed, updating..."
    git -C "$SOUNDS_DIR" pull --quiet
else
    if [ -d "$SOUNDS_DIR" ]; then
        BACKUP="$SOUNDS_DIR.backup-$(date +%Y%m%d%H%M%S)"
        echo "  Backing up existing $SOUNDS_DIR to $BACKUP"
        mv "$SOUNDS_DIR" "$BACKUP"
    fi
    git clone --quiet https://github.com/KarthickSelvam/sounds.git "$SOUNDS_DIR"
fi
echo "  Done."
echo ""

# ─── Step 2: Add macOS system sounds ─────────────────────────────────
echo "Step 2/3: Adding macOS system sounds..."

SYS="/System/Library/Sounds"
if [ -d "$SYS" ]; then
    cp "$SYS/Glass.aiff"     "$SOUNDS_DIR/success/glass.aiff"     2>/dev/null || true
    cp "$SYS/Hero.aiff"      "$SOUNDS_DIR/success/hero.aiff"      2>/dev/null || true
    cp "$SYS/Bottle.aiff"    "$SOUNDS_DIR/success/bottle.aiff"    2>/dev/null || true
    cp "$SYS/Tink.aiff"      "$SOUNDS_DIR/success/tink.aiff"      2>/dev/null || true
    cp "$SYS/Sosumi.aiff"    "$SOUNDS_DIR/success/sosumi.aiff"    2>/dev/null || true
    cp "$SYS/Basso.aiff"     "$SOUNDS_DIR/fail/basso.aiff"        2>/dev/null || true
    cp "$SYS/Submarine.aiff" "$SOUNDS_DIR/fail/submarine.aiff"    2>/dev/null || true
    cp "$SYS/Sosumi.aiff"    "$SOUNDS_DIR/fail/sosumi.aiff"       2>/dev/null || true
    cp "$SYS/Ping.aiff"      "$SOUNDS_DIR/neutral/ping.aiff"      2>/dev/null || true
    cp "$SYS/Pop.aiff"       "$SOUNDS_DIR/neutral/pop.aiff"       2>/dev/null || true
    cp "$SYS/Purr.aiff"      "$SOUNDS_DIR/neutral/purr.aiff"      2>/dev/null || true
    cp "$SYS/Blow.aiff"      "$SOUNDS_DIR/neutral/blow.aiff"      2>/dev/null || true
    cp "$SYS/Funk.aiff"      "$SOUNDS_DIR/misc/funk.aiff"         2>/dev/null || true
    cp "$SYS/Frog.aiff"      "$SOUNDS_DIR/misc/frog.aiff"         2>/dev/null || true
    cp "$SYS/Morse.aiff"     "$SOUNDS_DIR/misc/morse.aiff"        2>/dev/null || true
    echo "  Added 15 system sounds."
else
    echo "  macOS system sounds not found (non-Mac?). Skipping."
    echo "  The included sounds will still work fine."
fi
echo ""

# ─── Step 3: Configure Claude Code hooks ─────────────────────────────
echo "Step 3/3: Configuring Claude Code hooks..."

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
python3 << PYEOF
import json, os, shutil
from datetime import datetime

settings_path = "$SETTINGS"
hook_script = "$HOOK_SCRIPT"

new_hooks = {
    "SessionStart": [{"hooks": [{"type": "command", "command": f"{hook_script} session-start", "async": True}]}],
    "PostToolUse": [
        {"matcher": "Bash", "hooks": [{"type": "command", "command": f"{hook_script} bash-result", "async": True}]},
        {"matcher": "Edit|Write|MultiEdit", "hooks": [{"type": "command", "command": f"{hook_script} file-op", "async": True}]}
    ],
    "Stop": [{"hooks": [{"type": "command", "command": f"{hook_script} stop", "async": True}]}],
    "Notification": [{"hooks": [{"type": "command", "command": f"{hook_script} notification", "async": True}]}],
    "SubagentStart": [{"hooks": [{"type": "command", "command": f"{hook_script} subagent-start", "async": True}]}],
    "SubagentStop": [{"hooks": [{"type": "command", "command": f"{hook_script} subagent-stop", "async": True}]}]
}

settings = {}
if os.path.exists(settings_path):
    backup = settings_path + ".backup-" + datetime.now().strftime("%Y%m%d%H%M%S")
    shutil.copy2(settings_path, backup)
    print(f"  Backed up settings to {os.path.basename(backup)}")
    with open(settings_path) as f:
        settings = json.load(f)

# Remove existing bumblebee hooks (avoid duplicates on re-install)
if "hooks" in settings:
    for event_name in list(settings["hooks"].keys()):
        settings["hooks"][event_name] = [
            entry for entry in settings["hooks"][event_name]
            if not any("bumblebee-sounds.sh" in h.get("command", "") for h in entry.get("hooks", []))
        ]
        if not settings["hooks"][event_name]:
            del settings["hooks"][event_name]

# Merge
if "hooks" not in settings:
    settings["hooks"] = {}
for event_name, entries in new_hooks.items():
    if event_name not in settings["hooks"]:
        settings["hooks"][event_name] = []
    settings["hooks"][event_name].extend(entries)

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
print("  Hooks merged into settings.json")
PYEOF

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║        Installation complete!        ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  Open Claude Code -- sounds play automatically."
echo ""
echo "  Test it:     ~/sounds/play.sh success"
echo "  Uninstall:   ~/sounds/uninstall.sh"
echo ""
