---
name: box-notes
description: Create and maintain per-machine notes using the standard template, and keep STUDY_LOG.md updated. Use at the start of a new box and after finishing one.
---

# Box notes

## Starting a box
1. Ask for the box name and platform (THM/HTB/PG) and confirm it's a lab target.
2. Copy `templates/box-notes.md` to `boxes/<name>/notes.md`.
3. Create `boxes/<name>/scans/` for raw tool output.
4. Fill in target IP, platform, and date started.

## While working
Keep the notes updated as we go — don't wait until the end:
- Enumeration table (port, service, version, idea, status)
- Commands run and what they returned (link to files in `scans/`)
- Dead ends, so we don't repeat them

## Finishing a box
1. Fill in: foothold summary, privesc summary, root/system flag.
2. Add a short "lessons" section: what was the key insight, what took too
   long, what to do faster next time.
3. Append a line to `STUDY_LOG.md`: date, box, platform, weak areas hit,
   time taken if known.
4. Suggest one related box to reinforce the weak area.
