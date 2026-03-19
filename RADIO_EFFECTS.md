# 🎙️ Radio Effects — Technical Details

## What Are Radio Effects?

Radio effects transform clean voice recordings to sound like **walkie-talkie / military radio communications** — perfect for Bumblebee-style audio feedback.

## Technical Implementation

Using **SoX** (Sound eXchange), we apply a chain of audio effects:

### 1. Bandpass Filter (300-3000 Hz)
```bash
highpass 300    # Remove bass below 300 Hz
lowpass 3000    # Remove treble above 3000 Hz
```
**Why:** Real radios have limited frequency range. This creates the characteristic "tinny" radio sound.

### 2. Compression/Companding
```bash
compand 0.3,1 6:-70,-60,-20 -5 -90 0.2
```
**Why:** Simulates radio compression/limiting. Makes quiet and loud parts more uniform, like real radio transmission.

### 3. Light Reverb
```bash
reverb 10 20 40
```
**Why:** Adds subtle "space" — simulates the acoustic environment of radio transmission (equipment enclosures, transmission space).

## Result

**Before:** Clear, natural voice  
**After:** Sounds like it's coming through a walkie-talkie or military radio

## Files Processed

**35 voice clips** got radio treatment:

### Success (11 sounds)
- affirmative-radio.aiff
- roger-that-radio.aiff
- mission-accomplished-radio.aiff
- excellent-radio.aiff
- target-acquired-radio.aiff
- glass-radio.aiff, hero-radio.aiff, bottle-radio.aiff, sosumi-radio.aiff, tink-radio.aiff, roger-radio.aiff

### Fail (7 sounds)
- negative-radio.aiff
- malfunction-radio.aiff
- abort-radio.aiff
- error-detected-radio.aiff
- basso-radio.aiff, sosumi-radio.aiff, submarine-radio.aiff

### Neutral (8 sounds)
- standing-by-radio.aiff
- processing-radio.aiff
- complete-radio.aiff
- acknowledged-radio.aiff
- ping-radio.aiff, pop-radio.aiff, blow-radio.aiff, purr-radio.aiff

### Misc/Bumblebee (9 sounds)
- transform-rollout-radio.aiff
- autobots-rollout-radio.aiff
- bumblebee-online-radio.aiff
- scanning-radio.aiff
- systems-operational-radio.aiff
- bumblebee-radio.aiff, frog-radio.aiff, funk-radio.aiff, morse-radio.aiff

## Playback Behavior

**The system now:**
- 80% of the time: Plays **radio-processed** version (if available)
- 20% of the time: Plays original **clean** version
- This creates variety while keeping the radio aesthetic dominant

## Compare Sounds

```bash
# Interactive comparison tool
sound-compare

# Manual comparison
afplay ~/sounds/misc/transform-rollout.aiff        # Original
afplay ~/sounds/misc/transform-rollout-radio.aiff  # Radio
```

## Create More Radio Sounds

Want to add more radio-processed sounds?

```bash
# 1. Create or add a new voice clip
say -v "Daniel" -o ~/sounds/success/new-clip.aiff "Your message"

# 2. Apply radio effect
sox ~/sounds/success/new-clip.aiff \
    ~/sounds/success/new-clip-radio.aiff \
    highpass 300 \
    lowpass 3000 \
    compand 0.3,1 6:-70,-60,-20 -5 -90 0.2 \
    reverb 10 20 40

# 3. Done! It'll play randomly
```

Or just re-run:
```bash
~/sounds/download-bumblebee-sounds.sh
```

## Examples of Use

### Git Commit (with radio effect)
```bash
git commit -m "feat: new feature"
# 🔊 Plays: "Mission accomplished" (radio-processed)
```

### Test Pass (with radio effect)
```bash
test-with-sound npm test
# 🔊 Plays: "Affirmative" (radio-processed)
```

### Claude Task Complete (with radio effect)
```bash
~/sounds/claude-sounds.sh task-complete "Refactoring done"
# 🔊 Plays: Random success sound (80% chance of radio effect)
```

## Why Radio Effects?

**Bumblebee communicates through radio clips** in the Transformers movies. Radio effects make your coding feedback feel like:
- Emergency/military communications
- Sci-fi robot transmissions
- Mission control updates
- Bumblebee talking to you! 🤖

## Technical Notes

**SoX Chain Explanation:**

```bash
sox input.aiff output.aiff \
    highpass 300 \           # Cut frequencies below 300 Hz (removes bass rumble)
    lowpass 3000 \           # Cut frequencies above 3000 Hz (removes crisp highs)
    compand 0.3,1 \         # Attack/decay times
        6:-70,-60,-20 \      # Transfer function (compression curve)
        -5 -90 0.2 \         # Gain, knee, delay
    reverb 10 20 40          # Room size, HF damping, reverberance
```

**Processing Time:** ~0.1-0.3 seconds per sound (negligible)

**File Size:** Slightly smaller (compression removes some data)

## Customization

Want different radio characteristics?

### More Distorted (battle-damaged radio)
```bash
sox input.aiff output.aiff \
    highpass 400 lowpass 2500 \     # Narrower range
    overdrive 5 \                    # Add distortion
    reverb 20 40 60                  # More reverb
```

### Cleaner (modern digital radio)
```bash
sox input.aiff output.aiff \
    highpass 200 lowpass 4000 \     # Wider range
    compand 0.1,0.3 6:-70,-60,-20 -5 -90 0.1
    # No reverb
```

### Space/Intercom Style
```bash
sox input.aiff output.aiff \
    highpass 500 lowpass 2000 \     # Very narrow
    reverb 50 50 100 \               # Lots of reverb
    echo 0.8 0.9 60 0.3              # Add echo
```

## Tools

- `sound-compare` — Interactive comparison tool
- `~/sounds/play.sh` — Now prefers radio versions
- `~/sounds/download-bumblebee-sounds.sh` — Re-process all sounds

---

**Radio effects installed. Transform and roll out!** 🤖📻
