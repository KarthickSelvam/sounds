#!/bin/bash
# play.sh - Play random sound from a category
# Usage: ./play.sh success|fail|neutral|misc
# Prefers radio-processed versions when available

SOUNDS_DIR="$HOME/sounds"
CATEGORY="${1:-neutral}"
SOUND_DIR="$SOUNDS_DIR/$CATEGORY"

if [ ! -d "$SOUND_DIR" ]; then
    echo "Category not found: $CATEGORY"
    exit 1
fi

# Prefer radio-processed versions (80% of the time for variety)
if [ $((RANDOM % 10)) -lt 8 ]; then
    # Try to find radio-processed version first
    SOUND=$(find "$SOUND_DIR" -type f -name "*-radio.*" | shuf -n 1)
fi

# Fallback to any sound if no radio version found
if [ -z "$SOUND" ]; then
    SOUND=$(find "$SOUND_DIR" -type f \( -name "*.mp3" -o -name "*.wav" -o -name "*.m4a" -o -name "*.aiff" \) | shuf -n 1)
fi

if [ -z "$SOUND" ]; then
    echo "No sounds found in $SOUND_DIR"
    exit 1
fi

# Play it (Mac's afplay)
afplay "$SOUND" &
