#!/usr/bin/env bash
# jarvis-watch.sh — start a logged terminal session so Claude can narrate
# your own commands live, without you ever copy-pasting anything.
#
# Usage: scripts/jarvis-watch.sh <box-name>
#
# What it does: wraps THIS shell in `script`, which transcribes every
# keystroke and every line of output, in real time, to:
#   boxes/<box-name>/session.log
#
# Work completely normally in this terminal — type your own commands,
# SSH into the target yourself, run nmap/gobuster/whatever you'd run
# anyway. You are driving, on purpose: that's the muscle memory the exam
# actually tests.
#
# In a SEPARATE terminal, start (or continue) Claude Code in this repo and
# say something like:
#   "watch boxes/<box-name>/session.log and narrate as I go"
#
# From then on, after you run a command (or a small batch) here, just
# switch over and say "go" / "next" / press enter — Claude tails only the
# NEW lines since last time and explains what you just ran, why, and what
# to expect — zero paste, every time.
#
# Type `exit` in this terminal when you're done to close the log cleanly.

set -euo pipefail
name="${1:?Usage: jarvis-watch.sh <box-name>}"
dir="boxes/$name"
mkdir -p "$dir"
log="$dir/session.log"

echo "Logging this session to $log"
echo "In your Claude Code window, say: watch $log and narrate as I go"
echo "Then just say 'go' after each command you run here. Type 'exit' to stop logging."
echo

script -q -f "$log"
