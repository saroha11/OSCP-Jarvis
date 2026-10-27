# OSCP Jarvis

An interactive OSCP study tutor made of plain files: `CLAUDE.md` +
`.claude/skills/`. There's no backend, no shared account, no hosting — you
clone this repo and point **your own** AI coding agent at it. Nobody else
sees your sessions, your notes, or your lab IPs.

It's built to teach methodology through back-and-forth, not to hand you a
cheatsheet. The agent asks what you've tried, nudges before it answers, and
makes you write things down — because that habit is most of what OSCP
actually tests.

## Quick start

```
git clone https://github.com/saroha11/OSCP-Jarvis.git
cd OSCP-Jarvis
```

**With Claude Code** (what this was built against): run `claude` in this
folder. It picks up `CLAUDE.md` and the skills automatically. Say `start` or
just say hi — the `start-here` skill handles onboarding.

Claude Code has no native desktop GUI on Linux — the terminal CLI above is
the main way to run it on Kali, and it's where your actual pentest tools
(`nmap`, `gobuster`, etc.) run too. If you'd rather have a split view —
file tree and editor on one side, chat on the other — install VS Code and
the Claude Code extension:

```
sudo apt install code                 # or the .deb from code.visualstudio.com
code --install-extension anthropic.claude-code
code .                                # open this folder, then open the Claude Code panel
```

Everything still runs as real commands in Kali underneath; VS Code is just
a nicer window around the same CLI.

**With any other agent** (Cursor, Aider, a plain chat model, etc.): paste
`CLAUDE.md` in as your system prompt or first message. When a topic in
`.claude/skills/*/SKILL.md` comes up (enumeration, privesc, a new box), paste
that skill's file in too. The content is agent-agnostic by design.

## Layout

- `CLAUDE.md` — the tutor's rules: scope/ethics, teaching style, workflow
- `.claude/skills/`
  - `start-here` — interactive onboarding for a first session
  - `hint-mode` — graduated hints instead of answers
  - `recon-enum` — enumeration methodology
  - `box-notes` — per-machine notes and study-log upkeep
  - `web-attacks`, `linux-privesc`, `windows-privesc`, `ad-attacks` —
    placeholders, filled in collaboratively as real boxes are worked, so the
    content stays grounded in practice rather than being a generic dump
- `templates/student-profile.md`, `templates/box-notes.md` — filled in per
  student / per box
- `STUDY_LOG.md` — running log of sessions and weak areas (yours, local —
  not shared with anyone)

## Live-watch: zero-copy-paste narration while you work

The default mode: **you** run commands in your own terminal (SSH into the
target, `nmap`, whatever) — Claude explains each one in real time from a
session log, without a single copy-paste. This is deliberate: you drive,
because that's the skill the actual exam tests; Claude narrates and coaches.

```
scripts/jarvis-watch.sh <box-name>
```

This logs everything you type/see to `boxes/<box-name>/session.log`. In a
**separate** Claude Code window in this same repo, say:

```
watch boxes/<box-name>/session.log and narrate as I go
```

Then just say "go" after each command (or small batch) — Claude reads only
what's new and explains what you ran, why, and what the output means. See
`.claude/skills/live-watch/SKILL.md` for details.

## Optional: JARVIS-style voice

Want it to talk, like JARVIS did for Tony Stark — and be able to ask it
questions out loud too? It's opt-in, fully local and offline: no cloud
TTS/STT, no API key, nothing leaves your machine.

**Spoken answers** (quick start):
```
sudo apt install espeak-ng          # quick, robotic, works immediately
```
Then say "turn on voice" in a session, or set `voice: on` in
`STUDENT_PROFILE.md`. For a much more natural voice, install
[Piper](https://github.com/rhasspy/piper) — see
`.claude/skills/jarvis-voice/SKILL.md`. Used sparingly: key findings and
summaries, never raw scan dumps.

**Ask it questions out loud too** (push-to-talk): `scripts/jarvis-voice-chat.sh`
adds speech input via [whisper.cpp](https://github.com/ggml-org/whisper.cpp)
(free, local, offline). Runs in its own terminal alongside your normal one —
see the script's header comment for one-time setup, and
`.claude/skills/jarvis-voice/SKILL.md` for the honest limitations.

## Scope — read this

Lab targets only: TryHackMe, HackTheBox, OffSec Proving Grounds/PEN-200, or
your own VMs. Never point this at a real third-party system. The agent is
instructed to confirm scope before scanning and to refuse anything else.

OffSec prohibits AI assistance **during the actual OSCP exam**. This is a
study tool, not something to bring into the exam itself.

## Contributing

This is meant to grow from real study sessions, not from someone writing a
giant exploit-technique dump up front. If you fill in parts of
`web-attacks`/`linux-privesc`/`windows-privesc`/`ad-attacks` while working
real boxes, PRs that generalize what you learned (no box-specific spoilers,
no real-world target info) are welcome.

## License

MIT — see `LICENSE`.
