# Cursor Sound Integration Guide

Cursor 1.7+ supports [hooks](https://cursor.com/docs/hooks) that run custom scripts at key points in the agent loop. This guide shows how to wire up Bumblebee sounds to Cursor.

## Setup

### 1. Create the hook script

Save this as `~/.cursor/hooks/bumblebee-sound.sh`:

```bash
#!/bin/bash
# bumblebee-sound.sh - Play Bumblebee sounds from Cursor hooks
# Reads JSON from stdin, plays appropriate sound, returns JSON to stdout

SOUNDS_DIR="$HOME/sounds"
INPUT=$(cat)

# Parse the hook event name
EVENT=$(echo "$INPUT" | grep -o '"hook_event_name":"[^"]*"' | sed 's/"hook_event_name":"//;s/"//')

case "$EVENT" in
    afterFileEdit)
        "$SOUNDS_DIR/play.sh" success &
        ;;
    beforeShellExecution)
        "$SOUNDS_DIR/play.sh" neutral &
        ;;
    stop)
        "$SOUNDS_DIR/play.sh" success &
        ;;
esac

# Allow the action to proceed
echo '{"continue": true}'
```

Make it executable:

```bash
chmod +x ~/.cursor/hooks/bumblebee-sound.sh
```

### 2. Configure hooks.json

Create `.cursor/hooks.json` in your project root (or globally at `~/.cursor/hooks.json`):

```json
{
  "version": 1,
  "hooks": {
    "afterFileEdit": [
      {
        "command": "~/.cursor/hooks/bumblebee-sound.sh"
      }
    ],
    "beforeShellExecution": [
      {
        "command": "~/.cursor/hooks/bumblebee-sound.sh"
      }
    ],
    "stop": [
      {
        "command": "~/.cursor/hooks/bumblebee-sound.sh"
      }
    ]
  }
}
```

## Available Hook Events

| Event | When it fires | Sound |
|-------|--------------|-------|
| `afterFileEdit` | After Cursor edits a file | success |
| `beforeShellExecution` | Before running a shell command | neutral |
| `beforeMCPExecution` | Before calling an MCP tool | neutral |
| `beforeReadFile` | Before reading a file | (none by default) |
| `beforeSubmitPrompt` | When you submit a prompt | neutral |
| `stop` | When the agent finishes | success |

## Advanced: Context-Aware Sounds

The hook receives JSON on stdin with details about what happened. You can use this to play different sounds based on context:

```bash
#!/bin/bash
# Advanced hook - plays different sounds based on file type or command

SOUNDS_DIR="$HOME/sounds"
INPUT=$(cat)

EVENT=$(echo "$INPUT" | grep -o '"hook_event_name":"[^"]*"' | sed 's/"hook_event_name":"//;s/"//')

case "$EVENT" in
    afterFileEdit)
        FILE=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | sed 's/"file_path":"//;s/"//')
        case "$FILE" in
            *.test.*|*_test.*|*spec.*)
                "$SOUNDS_DIR/play.sh" neutral &  # Test file edited
                ;;
            *)
                "$SOUNDS_DIR/play.sh" success &  # Code file edited
                ;;
        esac
        ;;
    beforeShellExecution)
        "$SOUNDS_DIR/play.sh" neutral &
        ;;
    stop)
        "$SOUNDS_DIR/play.sh" success &
        ;;
esac

echo '{"continue": true}'
```

## Stdin/Stdout Format

Cursor sends JSON on stdin:

```json
{
  "conversation_id": "abc-123",
  "hook_event_name": "afterFileEdit",
  "file_path": "src/app.ts",
  "edits": [
    { "old_string": "...", "new_string": "..." }
  ],
  "workspace_roots": ["/Users/you/project"]
}
```

Your script must return JSON on stdout:

```json
{
  "continue": true
}
```

Use `stderr` for any debug logging (stdout is reserved for Cursor communication):

```bash
echo "debug info" >&2
```

## Troubleshooting

### Sounds not playing?

```bash
# Test the hook script directly
echo '{"hook_event_name":"afterFileEdit"}' | ~/.cursor/hooks/bumblebee-sound.sh

# Test the sound system
~/sounds/play.sh success
```

### Hook not firing?

- Make sure `hooks.json` is in your project's `.cursor/` directory
- Check the script is executable: `chmod +x ~/.cursor/hooks/bumblebee-sound.sh`
- Check Cursor version is 1.7 or later

### Want to disable?

Remove or rename `.cursor/hooks.json`, or remove the specific event entries.
