#!/bin/bash
# build-library.sh - Build sound library from Mac system sounds + custom
set -e

SOUNDS_DIR="$HOME/sounds"
SYS_SOUNDS="/System/Library/Sounds"

echo "🔊 Building sound library..."

# Success sounds
echo "✅ Success..."
cp "$SYS_SOUNDS/Glass.aiff" "$SOUNDS_DIR/success/glass.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Hero.aiff" "$SOUNDS_DIR/success/hero.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Bottle.aiff" "$SOUNDS_DIR/success/bottle.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Tink.aiff" "$SOUNDS_DIR/success/tink.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Sosumi.aiff" "$SOUNDS_DIR/success/sosumi.aiff" 2>/dev/null || true

# Fail sounds
echo "❌ Fail..."
cp "$SYS_SOUNDS/Basso.aiff" "$SOUNDS_DIR/fail/basso.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Submarine.aiff" "$SOUNDS_DIR/fail/submarine.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Sosumi.aiff" "$SOUNDS_DIR/fail/sosumi.aiff" 2>/dev/null || true

# Neutral sounds
echo "⚪️ Neutral..."
cp "$SYS_SOUNDS/Ping.aiff" "$SOUNDS_DIR/neutral/ping.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Pop.aiff" "$SOUNDS_DIR/neutral/pop.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Purr.aiff" "$SOUNDS_DIR/neutral/purr.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Blow.aiff" "$SOUNDS_DIR/neutral/blow.aiff" 2>/dev/null || true

# Misc/Fun sounds
echo "🎵 Misc..."
cp "$SYS_SOUNDS/Funk.aiff" "$SOUNDS_DIR/misc/funk.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Frog.aiff" "$SOUNDS_DIR/misc/frog.aiff" 2>/dev/null || true
cp "$SYS_SOUNDS/Morse.aiff" "$SOUNDS_DIR/misc/morse.aiff" 2>/dev/null || true

# Generate some custom sounds using 'say' (text-to-speech)
echo "🗣️ Generating voice clips..."
say -v "Daniel" -o "$SOUNDS_DIR/success/affirmative.aiff" "Affirmative" 2>/dev/null || true
say -v "Daniel" -o "$SOUNDS_DIR/success/roger.aiff" "Roger that" 2>/dev/null || true
say -v "Daniel" -o "$SOUNDS_DIR/fail/negative.aiff" "Negative" 2>/dev/null || true
say -v "Daniel" -o "$SOUNDS_DIR/neutral/complete.aiff" "Complete" 2>/dev/null || true
say -v "Zarvox" -o "$SOUNDS_DIR/misc/bumblebee.aiff" "Transform and roll out" 2>/dev/null || true

echo ""
echo "✅ Library built!"
echo ""
find "$SOUNDS_DIR" -type f -name "*.aiff" | wc -l | xargs echo "Total sounds:"
echo ""
echo "Test them:"
echo "  ~/sounds/play.sh success"
echo "  ~/sounds/play.sh fail"
echo "  ~/sounds/play.sh neutral"
echo "  ~/sounds/play.sh misc"
