# Contributing

This project grows from real study sessions, not from someone sitting down
and writing a giant exploit-technique reference in one go. That's on purpose
— content grounded in "here's what actually came up on a real box" ages
better than a generic dump, and it keeps the project from turning into yet
another static cheatsheet (there are plenty of those already).

## What's welcome

- Filling in parts of the placeholder skills (`web-attacks`, `linux-privesc`,
  `windows-privesc`, `ad-attacks`) based on techniques you actually practiced
  — generalized, not tied to one specific lab box.
- Improvements to `start-here` onboarding, `hint-mode`'s hint ladder, or the
  note templates.
- Bug fixes to any scripts (e.g. `scripts/jarvis-speak.sh`).
- Documentation clarity fixes.

## What's not welcome

- Spoilers for specific retired/active lab machines (box names, exact
  walkthroughs). Keep contributions at the technique level, not "how to beat
  box X".
- Anything aimed at real-world, non-lab targets, or techniques whose only
  use is against systems the contributor doesn't have authorization for.
- Credentials, lab IPs, VPN configs, or anything else that identifies a real
  environment.
- Content that encourages using this tool, or AI assistance generally,
  during the actual OSCP exam — that's against OffSec's exam rules.

## How to contribute

1. Fork the repo, branch off `main`.
2. Make your change. If you're adding to a skill, follow the existing
   `SKILL.md` format (YAML frontmatter with `name`/`description`, then the
   content).
3. Open a PR describing what you learned and why it's generalizable (not
   specific to a box you don't want to spoil).
4. Be ready for a question or two — mainly to make sure nothing
   box-specific or scope-violating slipped in.

## Style

- Teach-the-why, not just the command. This project is for people learning
  methodology, not copy-pasting.
- Keep skills agent-agnostic — no Claude-Code-only syntax or assumptions.
- Short and clear over exhaustive. Link out to HackTricks/GTFOBins/etc.
  rather than re-hosting their content wholesale.
