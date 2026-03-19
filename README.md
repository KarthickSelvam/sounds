# Bumblebee Sound System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Audio feedback for your development workflow — like Bumblebee talking through radio clips, but for code.

> **Platform:** macOS only. Requires `afplay`, `say`, and `osascript` (included with macOS).

## Installation

```bash
git clone https://github.com/karthickselvam/sounds.git ~/sounds
cd ~/sounds
./build-library.sh                    # Generate base sounds from macOS system sounds
./download-bumblebee-sounds.sh        # Download robot sounds + generate voice clips
```

Optional setup:
```bash
./setup-global-git-hooks.sh           # Auto-add hooks to new repos
cd your-repo && ~/sounds/install-git-hooks.sh  # Add hooks to existing repo
```

## What's Installed

### Sound Library
- `~/sounds/` - Main directory
  - `success/` - Victory sounds (test pass, build success, refactor done)
  - `fail/` - Error sounds (test fail, build error)
  - `neutral/` - Notification sounds (commit, file save, process start)
  - `misc/` - Fun sounds (Bumblebee mode, easter eggs)

### Core Scripts
- `~/sounds/play.sh [category]` - Play random sound from category
- `~/sounds/event-listener.sh [category] [message]` - Log + play + notify
- `~/bin/sound [category] [message]` - Global trigger (in your PATH)

### Quick Commands
- `sound-success "message"` - Play success sound
- `sound-fail "message"` - Play fail sound
- `sound-neutral "message"` - Play neutral sound
- `sound-misc` - Play misc/fun sound

### Git Integration
- **Global hooks** - All NEW repos get sound hooks automatically
- **Install to existing**: `cd repo && ~/sounds/install-git-hooks.sh`
- Hooks:
  - `post-commit` - Sounds based on commit type (feat:, fix:, refactor:, etc.)
  - `pre-push` - Sound before pushing
  - `post-merge` - Success/fail based on merge result
  - `post-checkout` - Sound when switching branches

### Test Integration
- `test-with-sound [command]` - Wrap any test runner
  - Example: `test-with-sound npm test`
  - Example: `test-with-sound pytest`

### Claude Integration
- `~/sounds/claude-sounds.sh [action] [message]` - Claude can trigger contextual sounds
- Actions: task-start, task-complete, code-written, refactor-done, test-pass, test-fail, error, bumblebee

## Usage

### Manual Triggers
```bash
sound success "Build complete"
sound fail "Tests failed"
sound neutral "Starting deployment"
sound misc  # Random fun sound
```

### Git Workflow
Just work normally — sounds happen automatically:
```bash
git commit -m "feat: add new feature"  # → success sound
git commit -m "wip: temp work"         # → neutral sound
git push                               # → neutral sound
git checkout main                      # → neutral sound
```

### Tests
```bash
test-with-sound npm test
test-with-sound pytest tests/
test-with-sound make test
```

### Claude Sessions
Claude can trigger sounds during work:
- Starting a task -> neutral
- Completing refactoring -> success
- Tests pass -> success
- Error -> fail
- Bumblebee mode -> misc

### Event Log
All events logged to: `~/sounds/events.log`

View recent events:
```bash
tail -f ~/sounds/events.log
```

## Customization

### Add Your Own Sounds
1. Download .aiff, .wav, or .mp3 files
2. Drop into appropriate category folder:
   - `~/sounds/success/`
   - `~/sounds/fail/`
   - `~/sounds/neutral/`
   - `~/sounds/misc/`
3. They'll automatically be picked up by the random player

### Create Voice Clips
```bash
say -v "Daniel" -o ~/sounds/success/custom.aiff "Your message here"
say -v "Zarvox" -o ~/sounds/misc/robot.aiff "Robots are cool"
```

Available voices (macOS):
- Daniel, Samantha, Alex (natural)
- Zarvox, Trinoids (robotic)
- Run `say -v ?` to see all

### Rebuild Sound Library
```bash
~/sounds/build-library.sh
```

## Files

```
~/sounds/
├── README.md                    # This file
├── play.sh                      # Random sound player
├── event-listener.sh            # Event system
├── claude-sounds.sh             # Claude integration
├── build-library.sh             # Rebuild sound library
├── install-git-hooks.sh         # Install to repo
├── setup-global-git-hooks.sh    # Configure global
├── events.log                   # Event history
├── success/                     # Success sounds
├── fail/                        # Fail sounds
├── neutral/                     # Neutral sounds
├── misc/                        # Fun sounds
└── git-hooks/                   # Hook templates

~/bin/
├── sound                        # Global trigger
├── sound-success               # Quick success
├── sound-fail                  # Quick fail
├── sound-neutral               # Quick neutral
├── sound-misc                  # Quick misc
└── test-with-sound             # Test wrapper

~/.git-templates/hooks/          # Global git hooks
```

## Examples

### CI/CD Integration
```yaml
# .github/workflows/test.yml
- name: Run tests
  run: |
    ssh build-server "cd repo && test-with-sound npm test"
```

### Build Scripts
```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:sound": "test-with-sound npm test",
    "build": "webpack && sound-success 'Build complete'",
    "deploy": "npm run build && deploy.sh && sound-success 'Deployed!'"
  }
}
```

### Makefile
```makefile
test:
	test-with-sound pytest tests/

deploy:
	./deploy.sh && sound-success "Deployed to production"
```

## Troubleshooting

### Sounds not playing?
```bash
# Test direct playback
afplay ~/sounds/success/glass.aiff

# Test play script
~/sounds/play.sh success

# Check sound files exist
ls ~/sounds/success/
```

### Git hooks not firing?
```bash
# Check hooks are installed
ls -la .git/hooks/

# Reinstall
~/sounds/install-git-hooks.sh

# Test manually
.git/hooks/post-commit
```

### PATH issues?
```bash
# Reload shell
source ~/.zshrc

# Check PATH
echo $PATH | grep "$HOME/bin"

# Add manually
export PATH="$HOME/bin:$PATH"
```

## Philosophy

Good code makes noise when it should. Like Bumblebee communicating through radio — clear signals at key moments.

- **Success**: Celebrate wins. Tests passing matters.
- **Failure**: Hear problems immediately. Don't ignore them.
- **Neutral**: Mark progress. Small wins compound.
- **Misc**: Have fun. Code is creative work.

## Requirements

- **macOS** (uses `afplay`, `say`, `osascript`)
- **Optional:** `sox` for radio effects (`brew install sox`)
- **Optional:** `yt-dlp` for YouTube clip extraction (`brew install yt-dlp`)

## License

MIT -- see [LICENSE](LICENSE) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

*"Any fool can write code that a computer can understand. Good programmers write code that humans can understand."*
-- Martin Fowler

And now, code that makes delightful sounds too.
