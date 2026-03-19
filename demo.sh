#!/bin/bash
# demo.sh - Demonstrate the sound system

echo "🔊 Bumblebee Sound System Demo"
echo "================================"
echo ""

echo "1. Success sound..."
sleep 1
~/sounds/claude-sounds.sh task-complete "Demo task 1 complete"
sleep 2

echo "2. Neutral sound..."
sleep 1
~/sounds/claude-sounds.sh task-start "Starting demo task 2"
sleep 2

echo "3. Fail sound..."
sleep 1
~/sounds/claude-sounds.sh error "Simulated error"
sleep 2

echo "4. Bumblebee mode! 🤖"
sleep 1
~/sounds/claude-sounds.sh bumblebee "Transform and roll out!"
sleep 2

echo ""
echo "✅ Demo complete!"
echo ""
echo "Check the event log:"
echo "  tail ~/sounds/events.log"
echo ""
echo "Try it yourself:"
echo "  sound success \"I did it!\""
echo "  sound-misc"
echo ""
echo "Full docs: ~/sounds/README.md"
