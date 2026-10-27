---
name: live-watch
description: Narrate a student's own terminal session live from a log file, with zero copy-paste - the student drives the keyboard themselves, Claude explains each command as it happens. Use when the student says "watch my session", "narrate as I go", "watch <logfile>", or similar.
---

# Live watch

The student runs commands themselves, in their own terminal. Two ways to
narrate, both zero-copy-paste:

- **Manual trigger**: `scripts/jarvis-watch.sh <box-name>` logs to
  `boxes/<box-name>/session.log` via `script`. You narrate when they say
  "go"/"next" after each command, in a separate Claude Code window.
- **Automatic overlay** (faster, recommended): `scripts/jarvis-live.sh
  <box-name>` runs the whole thing in one tmux session — their real shell
  in one pane, an auto-updating narration overlay in the other, driven by
  a background watcher that notices when they pause after a command and
  asks Claude to explain it automatically. No "go" needed at all. This is
  the more interview-coach-style experience, built from clean terminal
  text rather than screen-capture/OCR (which this setup doesn't need,
  since the text is already available directly).

## Why this exists
Running the commands yourself is the point — that's the exam skill. Claude
driving for you turns this into a video you watch, not practice. This mode
keeps the student's hands on the keyboard and puts Claude in the
"explaining over your shoulder" role instead.

## How to run it
1. Confirm the log file exists (`boxes/<name>/session.log`) and the target
   is a confirmed lab IP (per the scope rules in `CLAUDE.md`), same as any
   other session.
2. Track how much of the file you've already read — e.g. remember the
   line count or byte offset from last time. Read only the new portion
   each time (`tail -c +<offset> boxes/<name>/session.log`, or simply
   `tail -n 50` if starting fresh), not the whole file repeatedly.
3. After the student says "go" / "next" / similar: read the new lines,
   identify the command(s) run and their output, and narrate:
   - what the command does and why someone would run it here
   - what the output means — did it find something, is it a dead end
   - anything worth flagging: a likely mistake, a better flag to use, a
     faster way, or (per `hint-mode`) a question back if they typed
     something odd and their intent isn't clear
4. Keep each narration short — a few sentences per command, not an essay.
   If several commands landed since last check, group them, don't narrate
   line-by-line.
5. Stay in `hint-mode` rules: if they're clearly stuck or just ran
   something that won't work, nudge rather than immediately handing over
   the fix, unless they ask directly.

## Boundaries
- Never run commands into the student's session yourself in this mode —
  you are reading, not driving. If a next step is worth suggesting, say
  it; let them type it themselves.
- `script` logs literally everything, including anything typed by
  mistake. If a password or secret shows up in the log, don't repeat it
  back in chat — just note it happened and suggest they avoid typing real
  secrets into a logged session.
- Stop narrating and flag clearly if the log shows a command aimed outside
  the agreed lab scope.
