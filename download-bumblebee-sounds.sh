#!/bin/bash
# download-bumblebee-sounds.sh - Get Bumblebee-style sounds from legal sources
set -e

SOUNDS_DIR="$HOME/sounds"
cd "$SOUNDS_DIR"

echo "🤖 Downloading Bumblebee-style sounds..."
echo ""

# Check for required tools
if ! command -v sox &> /dev/null; then
    echo "⚠️  sox not found. Install with: brew install sox"
    echo "   (Needed for radio effects)"
    echo ""
fi

if ! command -v yt-dlp &> /dev/null && ! command -v youtube-dl &> /dev/null; then
    echo "⚠️  yt-dlp/youtube-dl not found. Install with: brew install yt-dlp"
    echo "   (Optional: for YouTube audio extraction)"
    echo ""
fi

# Phase 1: Free robot/mechanical sounds from SoundBible
echo "📦 Phase 1: Downloading free robot sounds from SoundBible..."
echo ""

download_sound() {
    local url="$1"
    local filename="$2"
    local category="$3"
    local dest="$SOUNDS_DIR/$category/$filename"
    
    if [ -f "$dest" ]; then
        echo "  ⏭️  $filename (already exists)"
        return
    fi
    
    echo "  ⬇️  $filename"
    curl -sL "$url" -o "$dest" || echo "     ❌ Failed"
}

# Success sounds (transformation complete, mission accomplished)
echo "✅ Transformation/Success sounds:"
download_sound "https://soundbible.com/grab.php?id=1682&type=mp3" "robot-blip.mp3" "success"
download_sound "https://soundbible.com/grab.php?id=1669&type=mp3" "robot-blip-2.mp3" "success"

# Fail sounds (malfunction, error)
download_sound "https://soundbible.com/grab.php?id=1361&type=mp3" "dying-robot.mp3" "fail"
download_sound "https://soundbible.com/grab.php?id=1308&type=mp3" "fizzle.mp3" "fail"
download_sound "https://soundbible.com/grab.php?id=1320&type=mp3" "short-circuit.mp3" "fail"

# Neutral sounds (computing, processing)
echo "⚪️ Processing/Neutral sounds:"
download_sound "https://soundbible.com/grab.php?id=1317&type=mp3" "robot-computing.mp3" "neutral"
download_sound "https://soundbible.com/grab.php?id=1276&type=mp3" "robot-computing-2.mp3" "neutral"
download_sound "https://soundbible.com/grab.php?id=756&type=mp3" "robot-movement.mp3" "neutral"

# Movement sounds
echo "🦾 Robot movement sounds:"
download_sound "https://soundbible.com/grab.php?id=1369&type=mp3" "robot-arm.mp3" "neutral"
download_sound "https://soundbible.com/grab.php?id=1364&type=mp3" "robot-leg.mp3" "neutral"
download_sound "https://soundbible.com/grab.php?id=1193&type=mp3" "robot-machine.mp3" "neutral"

# Servo motors
download_sound "https://soundbible.com/grab.php?id=1427&type=mp3" "small-motor.mp3" "neutral"
download_sound "https://soundbible.com/grab.php?id=1425&type=mp3" "servo-motor.mp3" "neutral"
download_sound "https://soundbible.com/grab.php?id=1440&type=mp3" "large-motor.mp3" "neutral"

echo ""
echo "✅ Phase 1 complete!"
echo ""

# Phase 2: Generate voice clips with robot effect
echo "🗣️  Phase 2: Generating Bumblebee-style voice clips..."
echo ""

# Check available voices
if command -v say &> /dev/null; then
    echo "📢 Creating radio-style voice clips:"
    
    # Success messages (radio-style)
    say -v "Daniel" -o "$SOUNDS_DIR/success/affirmative.aiff" "Affirmative" 2>/dev/null && echo "  ✅ affirmative.aiff"
    say -v "Daniel" -o "$SOUNDS_DIR/success/roger-that.aiff" "Roger that" 2>/dev/null && echo "  ✅ roger-that.aiff"
    say -v "Daniel" -o "$SOUNDS_DIR/success/mission-accomplished.aiff" "Mission accomplished" 2>/dev/null && echo "  ✅ mission-accomplished.aiff"
    say -v "Alex" -o "$SOUNDS_DIR/success/excellent.aiff" "Excellent" 2>/dev/null && echo "  ✅ excellent.aiff"
    say -v "Daniel" -o "$SOUNDS_DIR/success/target-acquired.aiff" "Target acquired" 2>/dev/null && echo "  ✅ target-acquired.aiff"
    
    # Fail messages
    echo ""
    echo "❌ Failure messages:"
    say -v "Daniel" -o "$SOUNDS_DIR/fail/negative.aiff" "Negative" 2>/dev/null && echo "  ❌ negative.aiff"
    say -v "Ralph" -o "$SOUNDS_DIR/fail/malfunction.aiff" "System malfunction" 2>/dev/null && echo "  ❌ malfunction.aiff"
    say -v "Daniel" -o "$SOUNDS_DIR/fail/abort.aiff" "Abort, abort" 2>/dev/null && echo "  ❌ abort.aiff"
    say -v "Alex" -o "$SOUNDS_DIR/fail/error-detected.aiff" "Error detected" 2>/dev/null && echo "  ❌ error-detected.aiff"
    
    # Neutral messages
    echo ""
    echo "⚪️ Status messages:"
    say -v "Daniel" -o "$SOUNDS_DIR/neutral/standing-by.aiff" "Standing by" 2>/dev/null && echo "  ⚪️ standing-by.aiff"
    say -v "Daniel" -o "$SOUNDS_DIR/neutral/processing.aiff" "Processing" 2>/dev/null && echo "  ⚪️ processing.aiff"
    say -v "Daniel" -o "$SOUNDS_DIR/neutral/complete.aiff" "Complete" 2>/dev/null && echo "  ⚪️ complete.aiff"
    say -v "Alex" -o "$SOUNDS_DIR/neutral/acknowledged.aiff" "Acknowledged" 2>/dev/null && echo "  ⚪️ acknowledged.aiff"
    
    # Bumblebee-specific (robotic voices)
    echo ""
    echo "🤖 Bumblebee-style:"
    say -v "Zarvox" -o "$SOUNDS_DIR/misc/transform-rollout.aiff" "Transform and roll out" 2>/dev/null && echo "  🤖 transform-rollout.aiff"
    say -v "Zarvox" -o "$SOUNDS_DIR/misc/autobots-rollout.aiff" "Autobots, roll out" 2>/dev/null && echo "  🤖 autobots-rollout.aiff"
    say -v "Trinoids" -o "$SOUNDS_DIR/misc/bumblebee-online.aiff" "Bumblebee online" 2>/dev/null && echo "  🤖 bumblebee-online.aiff"
    say -v "Zarvox" -o "$SOUNDS_DIR/misc/scanning.aiff" "Scanning for targets" 2>/dev/null && echo "  🤖 scanning.aiff"
    say -v "Trinoids" -o "$SOUNDS_DIR/misc/systems-operational.aiff" "All systems operational" 2>/dev/null && echo "  🤖 systems-operational.aiff"
else
    echo "⚠️  'say' command not available (macOS only)"
fi

echo ""
echo "✅ Phase 2 complete!"
echo ""

# Phase 3: Apply radio effects (if sox is available)
if command -v sox &> /dev/null; then
    echo "🎛️  Phase 3: Adding radio effects to voice clips..."
    echo ""
    
    mkdir -p "$SOUNDS_DIR/processed"
    
    process_with_radio_effect() {
        local input="$1"
        local output="${input%.*}-radio.${input##*.}"
        
        if [ ! -f "$input" ]; then
            return
        fi
        
        # Skip if already processed
        if [ -f "$output" ]; then
            return
        fi
        
        echo "  📻 Processing $(basename "$input")"
        
        # Add radio/walkie-talkie effect
        sox "$input" "$output" \
            highpass 300 \
            lowpass 3000 \
            compand 0.3,1 6:-70,-60,-20 -5 -90 0.2 \
            reverb 10 20 40 \
            2>/dev/null || echo "     ❌ Failed"
    }
    
    # Process voice clips
    for file in "$SOUNDS_DIR"/{success,fail,neutral,misc}/*.aiff; do
        [ -f "$file" ] && process_with_radio_effect "$file"
    done
    
    echo ""
    echo "✅ Phase 3 complete! Radio-effect versions created with '-radio' suffix"
else
    echo "ℹ️  Phase 3 skipped (sox not installed)"
    echo "   Install with: brew install sox"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Bumblebee sound library complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Count sounds
total=$(find "$SOUNDS_DIR"/{success,fail,neutral,misc} -type f \( -name "*.aiff" -o -name "*.mp3" -o -name "*.wav" \) 2>/dev/null | wc -l)
echo "Total sounds: $total"
echo ""

echo "Test them:"
echo "  ~/sounds/play.sh success"
echo "  ~/sounds/play.sh fail"
echo "  ~/sounds/play.sh neutral"
echo "  ~/sounds/play.sh misc"
echo ""

echo "For more sources, see:"
echo "  ~/sounds/BUMBLEBEE_SOURCES.md"
