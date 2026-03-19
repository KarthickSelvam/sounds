# Sound Event Mapping

## Categories

- `success/` — Tests pass, build succeeds, refactoring complete
- `fail/` — Tests fail, build breaks, merge conflict
- `neutral/` — Commit created, file saved, process started
- `misc/` — Anything creative/fun (Bumblebee radio clips, easter eggs)

## Integration Points

### Git Hooks
Add to `.git/hooks/post-commit`:
```bash
~/sounds/play.sh success
```

### Test Runners
- **pytest**: Add to `conftest.py` or use `--tb=short && ~/sounds/play.sh success || ~/sounds/play.sh fail`
- **npm test**: Package.json scripts with `&& ~/sounds/play.sh success`

### Claude Sessions
When I complete a task, I can trigger:
```bash
~/sounds/play.sh neutral
```

### Manual
```bash
~/sounds/play.sh misc  # For fun
```

## Download Suggestions

### Success Sounds
- Classic "ding" or "tada"
- 8-bit victory jingles
- Short positive radio clips ("Roger that!", "Affirmative")

### Fail Sounds
- Error beep
- Buzzer
- Radio static / "Negative"

### Neutral
- Click, whoosh, subtle beep
- File save "thunk"

### Misc (Bumblebee Mode)
- Old radio snippets
- Movie quotes
- Song fragments
- Voice clips from Transformers
