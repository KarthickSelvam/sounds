#!/bin/bash
# download-sounds.sh - Fetch starter sound library
set -e

SOUNDS_DIR="$HOME/sounds"
cd "$SOUNDS_DIR"

echo "🔊 Downloading starter sound library..."

# We'll use system sounds and generate some synthetic ones
# Plus download from notification-sounds.com (public domain)

download_sound() {
    local url="$1"
    local dest="$2"
    echo "  → $dest"
    curl -sL "$url" -o "$dest"
}

# Success sounds
echo "✅ Success sounds..."
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1150-pristine.mp3" \
    "success/pristine.mp3"
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1149-cheerful.mp3" \
    "success/cheerful.mp3"
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1148-when.mp3" \
    "success/when.mp3"

# Fail sounds
echo "❌ Fail sounds..."
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1115-slow-spring.mp3" \
    "fail/slow-spring.mp3"
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1116-just-saying.mp3" \
    "fail/just-saying.mp3"

# Neutral sounds
echo "⚪️ Neutral sounds..."
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1139-done-for-you.mp3" \
    "neutral/done-for-you.mp3"
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1140-elegant.mp3" \
    "neutral/elegant.mp3"

# Misc/Fun sounds
echo "🎵 Misc sounds..."
download_sound "https://notificationsounds.com/storage/sounds/file-sounds-1141-goes-without.mp3" \
    "misc/goes-without.mp3"

# Copy some Mac system sounds as backups
echo "🍎 Adding Mac system sounds..."
if [ -d "/System/Library/Sounds" ]; then
    cp "/System/Library/Sounds/Glass.aiff" "success/glass.aiff" 2>/dev/null || true
    cp "/System/Library/Sounds/Ping.aiff" "neutral/ping.aiff" 2>/dev/null || true
    cp "/System/Library/Sounds/Sosumi.aiff" "success/sosumi.aiff" 2>/dev/null || true
    cp "/System/Library/Sounds/Basso.aiff" "fail/basso.aiff" 2>/dev/null || true
    cp "/System/Library/Sounds/Funk.aiff" "misc/funk.aiff" 2>/dev/null || true
fi

echo ""
echo "✅ Sound library installed!"
echo ""
echo "Test it:"
echo "  ~/sounds/play.sh success"
echo "  ~/sounds/play.sh fail"
echo "  ~/sounds/play.sh neutral"
echo "  ~/sounds/play.sh misc"
