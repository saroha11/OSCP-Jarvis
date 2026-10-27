# oscp-jarvis

My Claude Code setup for studying OSCP. Clone this into a Kali VM at home
and run `claude` in the project root.

```
git clone <this repo>
cd oscp-jarvis
claude
```

## Layout

- `CLAUDE.md` — tutor instructions (hint-first teaching, scope/ethics rules)
- `.claude/skills/` — `hint-mode`, `recon-enum`, `web-attacks`, `linux-privesc`,
  `windows-privesc`, `ad-attacks`, `box-notes`
- `templates/box-notes.md` — per-machine note template
- `boxes/` — one folder per machine worked, with notes + raw scan output
- `STUDY_LOG.md` — running log of sessions and weak areas

`hint-mode` and `recon-enum` are filled in. The exploitation/privesc/AD
skills (`web-attacks`, `linux-privesc`, `windows-privesc`, `ad-attacks`)
start as placeholders — we fill them in together while working real
TryHackMe/HTB/Proving Grounds boxes, so the content stays grounded in
practice rather than being a generic dump.

## Scope

Lab targets only (TryHackMe, HackTheBox, OffSec Proving Grounds/PEN-200,
my own VMs). Never used against real third-party systems. Not used during
the actual OSCP exam, which prohibits AI assistance.
