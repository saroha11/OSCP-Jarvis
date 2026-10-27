#!/usr/bin/env bash
# jarvis-voice-chat.sh — push-to-talk voice Q&A for OSCP Jarvis.
# Fully free and local: no cloud STT/TTS, no API key, nothing leaves the VM.
#
# Flow: press Enter → speak your question → press Enter again → it
# transcribes with whisper.cpp, sends the text into your ongoing Claude Code
# conversation, and speaks the answer back with Piper (or espeak-ng as a
# fallback, via jarvis-speak.sh).
#
# IMPORTANT — this runs in its OWN terminal, separate from the one where you
# type commands. Both talk to the same ongoing Claude Code conversation (via
# `claude -p --continue`), so your voice questions and typed questions share
# history and context — but they are two terminals, not one. This is a CLI
# limitation, not a bug: Claude Code has no built-in mic/speaker loop, so
# this script is the glue that gives it one.
#
# One-time setup:
#   1. Speech-to-text — whisper.cpp:
#      git clone https://github.com/ggml-org/whisper.cpp && cd whisper.cpp
#      make && ./models/download-ggml-model.sh base.en
#      export JARVIS_WHISPER_BIN=/path/to/whisper.cpp/main
#      export JARVIS_WHISPER_MODEL=/path/to/whisper.cpp/models/ggml-base.en.bin
#   2. Text-to-speech — Piper (see scripts/jarvis-speak.sh header for setup):
#      export JARVIS_PIPER_MODEL=/path/to/en_US-lessac-medium.onnx
#   3. Recording — arecord ships with alsa-utils on Kali:
#      sudo apt install alsa-utils
#
# Usage:
#   scripts/jarvis-voice-chat.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WHISPER_BIN="${JARVIS_WHISPER_BIN:-}"
WHISPER_MODEL="${JARVIS_WHISPER_MODEL:-}"

if [ -z "$WHISPER_BIN" ] || [ -z "$WHISPER_MODEL" ]; then
    echo "Set JARVIS_WHISPER_BIN and JARVIS_WHISPER_MODEL first — see this"
    echo "script's header comment, or .claude/skills/jarvis-voice/SKILL.md,"
    echo "for one-time whisper.cpp setup."
    exit 1
fi

if ! command -v arecord >/dev/null 2>&1; then
    echo "arecord not found. Install it: sudo apt install alsa-utils"
    exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
    echo "claude CLI not found on PATH."
    exit 1
fi

echo "JARVIS voice chat — free, local, offline."
echo "Press ENTER to ask a question, Ctrl+C to quit."
echo

while true; do
    read -r -p "[press ENTER to speak] " _
    tmp_wav="$(mktemp --suffix=.wav)"
    trap 'rm -f "$tmp_wav"' RETURN

    echo "Recording... press ENTER to stop."
    arecord -q -f S16_LE -r 16000 -c 1 "$tmp_wav" &
    rec_pid=$!
    read -r -p "" _
    kill "$rec_pid" 2>/dev/null || true
    wait "$rec_pid" 2>/dev/null || true

    echo "Transcribing..."
    question="$("$WHISPER_BIN" -m "$WHISPER_MODEL" -f "$tmp_wav" --no-timestamps 2>/dev/null \
        | sed '/^\s*$/d' | tr -s '\n' ' ')"
    rm -f "$tmp_wav"

    if [ -z "$question" ]; then
        echo "(didn't catch anything — try again)"
        continue
    fi
    echo "You asked: $question"

    echo "Asking Claude..."
    # -c/--continue appends to the most recent conversation. If your Claude
    # Code version uses different flags for this, run `claude --help` and
    # adjust here — this is the one part most likely to need a tweak.
    answer="$(claude -p --continue "$question" 2>/dev/null || true)"

    if [ -z "$answer" ]; then
        echo "(no response — check that a Claude Code session exists to continue)"
        continue
    fi
    echo "$answer"
    echo

    bash "$SCRIPT_DIR/jarvis-speak.sh" "$answer"
done
