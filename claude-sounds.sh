#!/bin/bash
# claude-sounds.sh - Sound triggers for Claude sessions
# Called by Claude during work

ACTION="$1"
MESSAGE="$2"
SOUND="$HOME/sounds/event-listener.sh"

case "$ACTION" in
    "task-start")
        "$SOUND" neutral "${MESSAGE:-Task started}"
        ;;
    "task-complete")
        "$SOUND" success "${MESSAGE:-Task complete}"
        ;;
    "code-written")
        "$SOUND" success "${MESSAGE:-Code written}"
        ;;
    "refactor-done")
        "$SOUND" success "${MESSAGE:-Refactoring complete}"
        ;;
    "test-pass")
        "$SOUND" success "${MESSAGE:-Tests passed}"
        ;;
    "test-fail")
        "$SOUND" fail "${MESSAGE:-Tests failed}"
        ;;
    "error")
        "$SOUND" fail "${MESSAGE:-Error occurred}"
        ;;
    "thinking")
        "$SOUND" neutral "${MESSAGE:-Processing...}"
        ;;
    "bumblebee")
        "$SOUND" misc "${MESSAGE:-Transform and roll out}"
        ;;
    *)
        "$SOUND" neutral "$MESSAGE"
        ;;
esac
