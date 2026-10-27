#!/usr/bin/env bash
# jarvis-speak.sh — speak text aloud using whatever local TTS engine is
# available on this machine. Fully offline, no API keys, no network calls.
#
# Usage:
#   scripts/jarvis-speak.sh "Enumeration on port 445 found a writable share."
#   echo "some text" | scripts/jarvis-speak.sh
#
# Engine preference (first one found wins):
#   1. piper   - neural TTS, far more natural, needs a voice model downloaded once
#   2. espeak-ng / espeak - robotic but ships in Kali's repos, zero setup
#
# Install options on Kali:
#   sudo apt install espeak-ng                  # quick, robotic, works today
#   # or, for a much better voice:
#   pip install piper-tts  (or see https://github.com/rhasspy/piper)
#   # then download a voice model, e.g. en_US-lessac-medium, and set:
#   export JARVIS_PIPER_MODEL=/path/to/en_US-lessac-medium.onnx

set -euo pipefail

text="${*:-$(cat)}"
[ -z "$text" ] && exit 0

if command -v piper >/dev/null 2>&1 && [ -n "${JARVIS_PIPER_MODEL:-}" ]; then
    echo "$text" | piper --model "$JARVIS_PIPER_MODEL" --output_raw 2>/dev/null \
        | aplay -r 22050 -f S16_LE -t raw - 2>/dev/null
elif command -v espeak-ng >/dev/null 2>&1; then
    espeak-ng -v en-us+m3 -s 165 "$text" 2>/dev/null
elif command -v espeak >/dev/null 2>&1; then
    espeak -v en-us -s 165 "$text" 2>/dev/null
else
    # No TTS engine installed. Fail quietly so the agent's teaching flow
    # never breaks just because voice isn't set up — this prints instead.
    echo "[jarvis-speak: no TTS engine found — install espeak-ng, or piper for a better voice]" >&2
    echo "$text"
fi
