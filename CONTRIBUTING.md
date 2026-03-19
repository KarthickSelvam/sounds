# Contributing to Bumblebee Sound System

Thanks for your interest in contributing! Here's how you can help.

## Ways to Contribute

- **Report bugs** -- Open an issue describing what happened and what you expected
- **Suggest sounds** -- Have an idea for a new sound category or event trigger? Open an issue
- **Add platform support** -- Help make this work on Linux or Windows
- **Improve scripts** -- Bug fixes, error handling, new features
- **Documentation** -- Fix typos, clarify instructions, add examples

## Getting Started

1. Fork the repository
2. Clone your fork
3. Run `./build-library.sh` to generate the sound library (requires macOS)
4. Make your changes
5. Test that sounds still play: `./play.sh success`
6. Submit a pull request

## Guidelines

### Code Style
- Use `set -e` at the top of shell scripts
- Quote all variable expansions (`"$var"` not `$var`)
- Check for required tools before using them
- Provide helpful error messages when something is missing

### Sound Files
- **Do not commit sound files** to the repository -- they are generated/downloaded at install time
- If adding a new sound source, update the download scripts and `SOUND_CREDITS.md`
- Only use sounds with compatible licenses (Public Domain, CC0, CC-BY, MIT)
- Never include copyrighted movie clips or Apple system sounds in the repo

### Commits
- Write clear commit messages describing what changed and why
- Keep changes focused -- one feature or fix per PR

### Pull Requests
- Describe what your PR does and why
- Reference any related issues
- Test on macOS before submitting (note if untested on other platforms)

## Adding Platform Support

The project currently requires macOS for:
- `afplay` -- audio playback
- `say` -- text-to-speech voice generation
- `osascript` -- desktop notifications

To add Linux/Windows support, provide alternative implementations for these commands in the relevant scripts. Use platform detection (`uname`) to select the right tool.

## Questions?

Open an issue -- happy to help!
