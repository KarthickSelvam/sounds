#!/bin/bash
# event-listener.sh - Global sound event system
# Usage: ~/sounds/event-listener.sh success "Tests passed!"
#        ~/sounds/event-listener.sh fail "Build failed"
#        ~/sounds/event-listener.sh neutral "Commit created"
#        ~/sounds/event-listener.sh misc

SOUNDS_DIR="$HOME/sounds"
CATEGORY="${1:-neutral}"
MESSAGE="${2:-}"
LOG_FILE="$SOUNDS_DIR/events.log"

# Log the event
echo "$(date '+%Y-%m-%d %H:%M:%S') [$CATEGORY] $MESSAGE" >> "$LOG_FILE"

# Play the sound
"$SOUNDS_DIR/play.sh" "$CATEGORY"

# Optional: show notification (requires terminal-notifier or osascript)
if [ -n "$MESSAGE" ]; then
    osascript -e "display notification \"$MESSAGE\" with title \"🔊 $CATEGORY\"" 2>/dev/null || true
fi
