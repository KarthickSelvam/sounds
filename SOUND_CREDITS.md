# Sound Credits & Licensing

Bumblebee Sound System uses sounds from multiple sources. **No sound files are included in the repository** -- they are generated or downloaded at install time by the setup scripts.

## Sound Sources

### macOS System Sounds (via `build-library.sh`)

Copied from `/System/Library/Sounds/` at install time. These are Apple's property and are **not redistributable** -- they are only available on macOS systems where they are already installed.

| Sound | Category | Apple Sound Name |
|-------|----------|-----------------|
| glass.aiff | success | Glass |
| hero.aiff | success | Hero |
| bottle.aiff | success | Bottle |
| tink.aiff | success | Tink |
| sosumi.aiff | success, fail | Sosumi |
| basso.aiff | fail | Basso |
| submarine.aiff | fail | Submarine |
| ping.aiff | neutral | Ping |
| pop.aiff | neutral | Pop |
| purr.aiff | neutral | Purr |
| blow.aiff | neutral | Blow |
| funk.aiff | misc | Funk |
| frog.aiff | misc | Frog |
| morse.aiff | misc | Morse |

### Generated Voice Clips (via `download-bumblebee-sounds.sh`)

Created at install time using macOS `say` command with various voices (Daniel, Alex, Zarvox, Trinoids, Ralph). These are original creations generated on the user's machine.

| Sound | Voice | Text | Category |
|-------|-------|------|----------|
| affirmative.aiff | Daniel | "Affirmative" | success |
| roger-that.aiff | Daniel | "Roger that" | success |
| mission-accomplished.aiff | Daniel | "Mission accomplished" | success |
| excellent.aiff | Alex | "Excellent" | success |
| target-acquired.aiff | Daniel | "Target acquired" | success |
| negative.aiff | Daniel | "Negative" | fail |
| malfunction.aiff | Ralph | "System malfunction" | fail |
| abort.aiff | Daniel | "Abort, abort" | fail |
| error-detected.aiff | Alex | "Error detected" | fail |
| standing-by.aiff | Daniel | "Standing by" | neutral |
| processing.aiff | Daniel | "Processing" | neutral |
| complete.aiff | Daniel | "Complete" | neutral |
| acknowledged.aiff | Alex | "Acknowledged" | neutral |
| transform-rollout.aiff | Zarvox | "Transform and roll out" | misc |
| autobots-rollout.aiff | Zarvox | "Autobots, roll out" | misc |
| bumblebee-online.aiff | Trinoids | "Bumblebee online" | misc |
| scanning.aiff | Zarvox | "Scanning for targets" | misc |
| systems-operational.aiff | Trinoids | "All systems operational" | misc |

Radio-effect versions (with `-radio` suffix) are created by processing the above through `sox` audio filters.

### SoundBible.com Downloads (via `download-bumblebee-sounds.sh`)

Downloaded from [SoundBible.com](https://soundbible.com). Licensed under **Attribution 3.0** or **Public Domain**.

| Sound | Category | License |
|-------|----------|---------|
| robot-blip.mp3 | success | Attribution 3.0 / Public Domain |
| robot-blip-2.mp3 | success | Attribution 3.0 / Public Domain |
| dying-robot.mp3 | fail | Attribution 3.0 / Public Domain |
| fizzle.mp3 | fail | Attribution 3.0 / Public Domain |
| short-circuit.mp3 | fail | Attribution 3.0 / Public Domain |
| robot-computing.mp3 | neutral | Attribution 3.0 / Public Domain |
| robot-computing-2.mp3 | neutral | Attribution 3.0 / Public Domain |
| robot-movement.mp3 | neutral | Attribution 3.0 / Public Domain |
| robot-arm.mp3 | neutral | Attribution 3.0 / Public Domain |
| robot-leg.mp3 | neutral | Attribution 3.0 / Public Domain |
| robot-machine.mp3 | neutral | Attribution 3.0 / Public Domain |
| small-motor.mp3 | neutral | Attribution 3.0 / Public Domain |
| servo-motor.mp3 | neutral | Attribution 3.0 / Public Domain |
| large-motor.mp3 | neutral | Attribution 3.0 / Public Domain |

### Freesound.org (via `freesound-downloader.sh`)

Optional. Users can search and download additional sounds using a free Freesound API key. Sounds from Freesound are typically licensed under Creative Commons (check individual sound pages for specific terms).

## Adding Your Own Sounds

When contributing new sound sources:
1. Only use sounds with compatible licenses (Public Domain, CC0, CC-BY, MIT)
2. Document the source, author, and license in this file
3. Add the download to the appropriate script rather than committing sound files directly
4. Never include copyrighted movie/TV/game audio clips
