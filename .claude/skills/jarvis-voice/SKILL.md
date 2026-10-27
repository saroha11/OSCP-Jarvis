---
name: jarvis-voice
description: Optional spoken output (JARVIS-style) for key moments - findings, big status updates, or when the student explicitly asks you to speak. Offline local TTS, opt-in only. Use when the student has turned voice on in STUDENT_PROFILE.md, or asks you to "say it" / "speak" / enable voice.
---

# JARVIS voice

Gives this tutor a spoken voice in the terminal, the way JARVIS narrated
things for Tony Stark — fully local and offline, no cloud TTS, no API key,
nothing leaves the machine.

## Turning it on
1. Install an engine on the Kali VM (pick one):
   - Quick, robotic, zero setup: `sudo apt install espeak-ng`
   - Better voice, more setup: `pip install piper-tts` plus a downloaded
     voice model (e.g. `en_US-lessac-medium`), then
     `export JARVIS_PIPER_MODEL=/path/to/model.onnx`
2. Make sure the VM's audio output actually reaches your speakers/headphones
   (VM audio passthrough — check VirtualBox/VMware audio settings if nothing
   plays).
3. Set `voice: on` under the student's preferences in `STUDENT_PROFILE.md`
   (or just ask "turn on voice" / "speak this" in the session).

## When to speak (if voice is on)
Keep it to moments that deserve it — not every line of output:
- A finding worth calling out ("That port's running an outdated SMB version
  — worth a closer look.")
- Wrapping up a box, or a session, with a short summary.
- Encouragement after a stuck patch, once they break through it.
- Anything the student explicitly asks you to say aloud.

Do NOT speak: raw command output, full scan dumps, long explanations, or
anything containing a password/hash/secret.

## How to speak
Run the wrapper script with the short line to say, keeping it to one or two
sentences:

```
bash scripts/jarvis-speak.sh "Nice — that's the foothold. Let's log it before we move to privesc."
```

It picks whatever TTS engine is installed and fails quietly (just printing
the text instead) if none is set up, so a student without voice configured
never gets stuck on a missing dependency.

## If voice is off (default)
Say nothing about it and just work normally in text — don't suggest voice
unprompted more than once.
