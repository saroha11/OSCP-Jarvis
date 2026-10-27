#!/usr/bin/env bash
# jarvis-live.sh — one-command live tutor overlay.
#
# You work in a real shell pane. A second pane shows narration that updates
# on its own. A background watcher notices when you pause after a command
# and automatically asks Claude to explain what just happened — no "go",
# no copy-paste, no screen-capture/OCR tricks (we already have clean text
# straight from the terminal, which is more reliable than reading pixels).
#
# Usage: scripts/jarvis-live.sh <box-name>
#
# Requires: tmux (required), inotify-tools (optional — falls back to
# polling every 2s if `inotifywait` isn't installed):
#   sudo apt install tmux inotify-tools
#
# Layout once running:
#   left pane  - your real shell, logged to boxes/<name>/session.log
#   right pane - boxes/<name>/narration.log, tailed live (the "overlay")
#   background - the watcher process described above
#
# Notes / honest limits:
#   - `claude -p --continue` must work non-interactively in your setup
#     (logged in, same conversation you want it appended to). If your
#     Claude Code version uses different flags for "continue last
#     conversation", adjust the `claude -p --continue` line below.
#   - The 2s+1s debounce means narration lands a few seconds after you
#     stop typing, not instantly mid-command. That's intentional — it
#     waits for a command to actually finish before commenting on it.
#   - Detach from tmux with Ctrl-b then d. The watcher keeps running until
#     you Ctrl-C this script or close the terminal it's running in.

set -euo pipefail
name="${1:?Usage: jarvis-live.sh <box-name>}"
dir="boxes/$name"
mkdir -p "$dir"
log="$dir/session.log"
narration="$dir/narration.log"
touch "$log"
: > "$narration"

session="jarvis-$name"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux not found. Install it: sudo apt install tmux"
    exit 1
fi
if ! command -v claude >/dev/null 2>&1; then
    echo "claude CLI not found on PATH."
    exit 1
fi

watcher() {
    local last_size=0
    while true; do
        if command -v inotifywait >/dev/null 2>&1; then
            inotifywait -q -e modify "$log" >/dev/null 2>&1 || true
        fi
        sleep 2   # debounce: let output settle before treating it as "done"

        local size
        size="$(stat -c%s "$log" 2>/dev/null || echo 0)"
        [ "$size" = "$last_size" ] && continue

        sleep 1   # one more beat to confirm output really stopped
        local size2
        size2="$(stat -c%s "$log" 2>/dev/null || echo 0)"
        [ "$size2" != "$size" ] && continue   # still writing, wait longer

        local new_content
        new_content="$(tail -c +"$((last_size + 1))" "$log" 2>/dev/null | strings)"
        last_size="$size2"

        if [ -n "$(echo "$new_content" | tr -d '[:space:]')" ]; then
            answer="$(claude -p --continue "Narrate this new terminal activity briefly for a student: what command(s) ran, why, and what the output means. A few sentences, not an essay.

$new_content" 2>/dev/null || true)"

            if [ -n "$answer" ]; then
                {
                    echo "----- $(date +%H:%M:%S) -----"
                    echo "$answer"
                    echo
                } >> "$narration"
                bash "$SCRIPT_DIR/jarvis-speak.sh" "$answer" >/dev/null 2>&1 || true
            fi
        fi
    done
}

tmux kill-session -t "$session" 2>/dev/null || true
tmux new-session -d -s "$session" -n live
tmux send-keys -t "$session:live" "script -q -f '$log'" C-m
tmux split-window -h -t "$session:live" "tail -f '$narration'"
tmux select-pane -t "$session:live.0"

watcher &
watcher_pid=$!
trap 'kill "$watcher_pid" 2>/dev/null || true' EXIT

echo "Live session started for '$name'."
echo "Left pane: your real shell. Right pane: auto-updating narration."
echo "Detach with Ctrl-b then d. Re-attach later with: tmux attach -t $session"
echo
tmux attach -t "$session"
