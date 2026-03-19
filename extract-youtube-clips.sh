#!/bin/bash
# extract-youtube-clips.sh - Extract Bumblebee audio clips from YouTube
# ⚠️  FOR PERSONAL USE ONLY - Movie clips are copyrighted
set -e

SOUNDS_DIR="$HOME/sounds"

echo "🤖 Bumblebee YouTube Clip Extractor"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  WARNING: Movie audio clips are copyrighted."
echo "   Use ONLY for personal projects, not commercial."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for required tools
if ! command -v yt-dlp &> /dev/null && ! command -v youtube-dl &> /dev/null; then
    echo "❌ yt-dlp or youtube-dl required"
    echo ""
    echo "Install with:"
    echo "  brew install yt-dlp"
    echo "  -- or --"
    echo "  brew install youtube-dl"
    echo ""
    exit 1
fi

if ! command -v ffmpeg &> /dev/null; then
    echo "❌ ffmpeg required for audio extraction"
    echo ""
    echo "Install with:"
    echo "  brew install ffmpeg"
    echo ""
    exit 1
fi

# Use yt-dlp if available, otherwise youtube-dl
YTDL="yt-dlp"
command -v yt-dlp &> /dev/null || YTDL="youtube-dl"

echo "Using: $YTDL"
echo ""

# Function to download and convert
download_audio() {
    local url="$1"
    local output="$2"
    local category="$3"
    
    local temp_file="$SOUNDS_DIR/temp_download"
    local dest="$SOUNDS_DIR/$category/$output"
    
    if [ -f "$dest" ]; then
        echo "  ⏭️  $output (already exists)"
        return
    fi
    
    echo "  ⬇️  Downloading: $output"
    
    # Download audio
    $YTDL -x --audio-format mp3 \
        --audio-quality 0 \
        -o "$temp_file.%(ext)s" \
        "$url" 2>/dev/null || {
        echo "     ❌ Download failed"
        return 1
    }
    
    # Convert to aiff if needed
    if [ -f "$temp_file.mp3" ]; then
        if [[ "$output" == *.aiff ]]; then
            ffmpeg -i "$temp_file.mp3" -acodec pcm_s16be "$dest" -y 2>/dev/null
            rm "$temp_file.mp3"
        else
            mv "$temp_file.mp3" "$dest"
        fi
        echo "     ✅ Saved to $category/"
    else
        echo "     ❌ Conversion failed"
    fi
}

# Curated YouTube sources (compilations, soundboards, fan-made)
echo "📺 Suggested YouTube sources:"
echo ""
echo "Search YouTube for:"
echo "  - 'Bumblebee voice clips'"
echo "  - 'Bumblebee radio sounds'"
echo "  - 'Transformers Bumblebee talking'"
echo "  - 'Bumblebee transformation sound'"
echo ""
echo "Example URLs:"
echo "  https://www.youtube.com/watch?v=[VIDEO_ID]"
echo ""

# Interactive mode
read -p "Enter YouTube URL (or 'skip' to skip): " url

if [ "$url" == "skip" ] || [ -z "$url" ]; then
    echo "Skipped."
    exit 0
fi

read -p "Output filename (e.g. bumblebee-clip.mp3): " filename
read -p "Category (success/fail/neutral/misc): " category

if [ -z "$filename" ] || [ -z "$category" ]; then
    echo "❌ Filename and category required"
    exit 1
fi

download_audio "$url" "$filename" "$category"

echo ""
echo "✅ Done!"
echo ""
echo "Want to add more? Run this script again."
