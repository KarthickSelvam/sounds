#!/bin/bash
# freesound-downloader.sh - Search and download from Freesound.org
# Requires Freesound API key (free registration at freesound.org)
set -e

SOUNDS_DIR="$HOME/sounds"
CONFIG_FILE="$SOUNDS_DIR/.freesound_api_key"

echo "🔊 Freesound.org Downloader"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for API key
if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚠️  Freesound API key not found"
    echo ""
    echo "To use this tool:"
    echo "  1. Register at https://freesound.org"
    echo "  2. Get your API key from https://freesound.org/apiv2/apply"
    echo "  3. Save it: echo 'YOUR_API_KEY' > $CONFIG_FILE"
    echo ""
    echo "Freesound is FREE and has 600,000+ sounds!"
    echo ""
    exit 1
fi

API_KEY=$(cat "$CONFIG_FILE")

# Function to search Freesound
search_freesound() {
    local query="$1"
    local limit="${2:-10}"
    
    echo "🔍 Searching for: \"$query\""
    echo ""
    
    # Search via API
    response=$(curl -s "https://freesound.org/apiv2/search/text/?query=$query&token=$API_KEY&fields=id,name,previews,license&page_size=$limit")
    
    # Parse results (basic JSON parsing with grep/sed)
    echo "$response" | grep -o '"name":"[^"]*"' | sed 's/"name":"//g' | sed 's/"//g' | nl
    
    echo ""
    echo "Found sounds. Results saved to temp."
    echo "$response" > "$SOUNDS_DIR/.freesound_results.json"
}

# Function to download by ID
download_by_id() {
    local sound_id="$1"
    local category="$2"
    
    echo "⬇️  Downloading sound ID: $sound_id"
    
    # Get sound details
    details=$(curl -s "https://freesound.org/apiv2/sounds/$sound_id/?token=$API_KEY")
    
    # Extract preview URL and name
    preview_url=$(echo "$details" | grep -o '"preview-hq-mp3":"[^"]*"' | sed 's/"preview-hq-mp3":"//g' | sed 's/"//g')
    name=$(echo "$details" | grep -o '"name":"[^"]*"' | head -1 | sed 's/"name":"//g' | sed 's/"//g')
    
    if [ -z "$preview_url" ]; then
        echo "❌ Failed to get download URL"
        return 1
    fi
    
    # Sanitize filename
    filename=$(echo "$name" | tr ' ' '-' | tr -cd '[:alnum:]-._').mp3
    dest="$SOUNDS_DIR/$category/$filename"
    
    if [ -f "$dest" ]; then
        echo "  ⏭️  Already exists: $filename"
        return 0
    fi
    
    # Download
    curl -sL "$preview_url" -o "$dest"
    echo "  ✅ Saved: $category/$filename"
}

# Interactive mode
echo "Search queries for Bumblebee-style sounds:"
echo "  - transformer sound"
echo "  - robot movement"
echo "  - servo motor"
echo "  - mechanical"
echo "  - radio static"
echo "  - walkie talkie"
echo "  - electronic beep"
echo ""

read -p "Search query: " query

if [ -z "$query" ]; then
    echo "❌ Query required"
    exit 1
fi

search_freesound "$query" 10

echo ""
read -p "Download sound ID (or 'skip'): " sound_id

if [ "$sound_id" == "skip" ] || [ -z "$sound_id" ]; then
    echo "Skipped."
    exit 0
fi

read -p "Category (success/fail/neutral/misc): " category

if [ -z "$category" ]; then
    category="misc"
fi

download_by_id "$sound_id" "$category"

echo ""
echo "✅ Done!"
echo ""
echo "Search again? Run this script again."
