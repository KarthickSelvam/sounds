#!/bin/bash
# demo-radio.sh - Demonstrate radio-enhanced Bumblebee system

echo "🤖 Bumblebee Sound System — Radio Effects Demo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "You now have 84 sounds with 35 radio-processed voice clips!"
echo ""
echo "Listen to the difference..."
echo ""

# Success sounds
echo "✅ SUCCESS — Mission Accomplished (radio-processed)"
afplay ~/sounds/success/mission-accomplished-radio.aiff 2>/dev/null
sleep 3

echo ""
echo "✅ SUCCESS — Roger That (radio-processed)"
afplay ~/sounds/success/roger-that-radio.aiff 2>/dev/null
sleep 3

echo ""

# Fail sounds
echo "❌ FAIL — Negative (radio-processed)"
afplay ~/sounds/fail/negative-radio.aiff 2>/dev/null
sleep 3

echo ""

# Neutral sounds
echo "⚪️ NEUTRAL — Standing By (radio-processed)"
afplay ~/sounds/neutral/standing-by-radio.aiff 2>/dev/null
sleep 3

echo ""

# Bumblebee
echo "🤖 BUMBLEBEE MODE — Transform and Roll Out!"
afplay ~/sounds/misc/transform-rollout-radio.aiff 2>/dev/null
sleep 3

echo ""
echo "🤖 BUMBLEBEE MODE — Autobots, Roll Out!"
afplay ~/sounds/misc/autobots-rollout-radio.aiff 2>/dev/null
sleep 3

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Demo complete!"
echo ""
echo "Voice clips now sound like walkie-talkie communications!"
echo ""
echo "Technical details:"
echo "  - Bandpass filter: 300-3000 Hz"
echo "  - Compression/companding"
echo "  - Light reverb"
echo ""
echo "Try it yourself:"
echo "  sound-compare          # Compare original vs radio"
echo "  sound-misc             # Random Bumblebee sound"
echo "  ~/sounds/RADIO_EFFECTS.md   # Full technical guide"
echo ""
echo "Transform and roll out! 🤖📻"
