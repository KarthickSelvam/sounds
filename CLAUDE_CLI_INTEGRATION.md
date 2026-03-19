# 🤖 Claude CLI Sound Integration Guide

## Problem

Claude CLI doesn't automatically trigger sounds because it's a separate process that doesn't know about the sound system.

## Solutions (Pick One)

### ✅ Solution 1: Shell Function Wrapper (RECOMMENDED)

**Already installed!** Just reload your shell:

```bash
source ~/.zshrc
```

Now `claude` command will:
- Play sound when starting
- Play success sound when done (exit code 0)
- Play error sound if it fails

**Test it:**
```bash
claude "What's 2+2?"
# 🔊 Start sound → Claude runs → 🔊 Success sound
```

---

### 🎯 Solution 2: Manual Triggers (Ask Claude CLI)

When using Claude CLI, **ask it to trigger sounds**:

```
"Write a function and play a success sound when done"

"Refactor this code, then trigger a sound"

"Run the tests and play appropriate sounds"
```

Claude CLI can call:
```bash
~/.claude/hooks/sound-trigger.sh task-complete "Done!"
```

---

### 🔧 Solution 3: Explicit Sound Commands

Add sound triggers to any script Claude CLI creates:

```bash
# In your script
npm test && ~/.claude/hooks/sound-trigger.sh test-pass "Tests passed" || \
            ~/.claude/hooks/sound-trigger.sh test-fail "Tests failed"
```

---

## How It Works

### Shell Function (Solution 1)

Location: `~/.claude-sound-integration.sh`

```bash
claude() {
    # Play start sound
    ~/sounds/claude-sounds.sh task-start "Starting"
    
    # Run actual Claude CLI
    command claude "$@"
    
    # Play completion sound
    if success; then
        ~/sounds/claude-sounds.sh task-complete "Done"
    else
        ~/sounds/claude-sounds.sh error "Failed"
    fi
}
```

### Manual Triggers (Solution 2)

Claude CLI can execute:
```bash
~/.claude/hooks/sound-trigger.sh [action] [message]
```

Available actions:
- `task-complete` (success)
- `code-written` (success)
- `refactor-done` (success)
- `test-pass` (success)
- `test-fail` (fail)
- `error` (fail)
- `thinking` (neutral)
- `bumblebee` (misc)

---

## Testing

### Test Wrapper Function
```bash
# Reload shell
source ~/.zshrc

# Test
claude "Say hello"
# Should hear: start sound → Claude runs → success sound
```

### Test Manual Trigger
```bash
~/.claude/hooks/sound-trigger.sh bumblebee "Transform!"
# Should hear: Bumblebee sound
```

### Test in Claude CLI Session
```
"Play a success sound"
```

Claude CLI should run:
```bash
~/.claude/hooks/sound-trigger.sh task-complete "Success!"
```

---

## Files Created

| File | Purpose |
|------|---------|
| `~/.claude-sound-integration.sh` | Shell wrapper function |
| `~/.claude/hooks/sound-trigger.sh` | Sound hook script |
| `~/.claude/sound-config.md` | Config for Claude CLI to read |
| `~/bin/claude-with-sounds` | Alternative wrapper script |
| `~/sounds/CLAUDE_CLI_INTEGRATION.md` | This guide |

---

## Current Status

✅ **Shell function wrapper**: Installed (needs `source ~/.zshrc`)  
✅ **Sound hook script**: Ready at `~/.claude/hooks/sound-trigger.sh`  
✅ **Documentation**: Created for Claude CLI reference  
⚠️  **Active sessions**: Need to reload shell or restart  

---

## Recommendations

**For best experience:**

1. **Use shell function wrapper** (Solution 1)
   ```bash
   source ~/.zshrc
   claude "your prompt"
   ```

2. **Ask Claude CLI to trigger sounds** when appropriate
   ```
   "Complete this task and play a success sound"
   ```

3. **Add sound triggers to important scripts**
   ```bash
   npm test && sound-success || sound-fail
   ```

---

## Troubleshooting

### Wrapper not working?
```bash
# Check if function exists
type claude
# Should show: claude is a shell function

# If not, reload:
source ~/.zshrc
```

### Sounds not playing?
```bash
# Test sound system directly
~/sounds/play.sh misc

# Test hook
~/.claude/hooks/sound-trigger.sh bumblebee "Test"
```

### Want to disable?
```bash
# Comment out in ~/.zshrc:
# source ~/.claude-sound-integration.sh

# Then reload
source ~/.zshrc
```

---

## Advanced: Per-Action Hooks

Want Claude CLI to trigger specific sounds for specific actions?

**Create custom wrapper:**
```bash
claude-code() {
    source ~/.zshrc
    claude "$@"
    ~/sounds/claude-sounds.sh code-written "Code complete"
}

claude-test() {
    source ~/.zshrc
    claude "$@" && \
        ~/sounds/claude-sounds.sh test-pass || \
        ~/sounds/claude-sounds.sh test-fail
}
```

---

## Integration with AGENTS.md

If you have a custom AGENTS.md for Claude CLI, add:

```markdown
## Sound Feedback

After completing tasks, trigger sounds:

\`\`\`bash
~/.claude/hooks/sound-trigger.sh task-complete "Task done"
\`\`\`

When tests pass:
\`\`\`bash
~/.claude/hooks/sound-trigger.sh test-pass "Tests passed"
\`\`\`
```

---

**Bottom line:** Reload your shell (`source ~/.zshrc`), then `claude` commands will automatically trigger sounds! 🔊
