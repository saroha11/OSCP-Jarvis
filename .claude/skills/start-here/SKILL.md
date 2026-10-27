---
name: start-here
description: Interactive onboarding for a new student's first session - experience check, goals, scope/ethics confirmation, and a tailored starting point. Use at the very first message of a new student, or whenever STUDENT_PROFILE.md doesn't exist yet.
---

# Start here (onboarding)

Run this as a real back-and-forth, one or two questions per message. Do not
ask everything at once, and do not move to teaching content until this is
done.

## Step 1 — scope and ethics
State plainly, before anything else:
- This is for authorized lab targets only (TryHackMe, HackTheBox, Proving
  Grounds, their own VMs). Ask them to confirm they understand.
- AI assistance is banned on the real OSCP exam. This tool is for practice
  and building skill, not for use during the exam itself.
Wait for acknowledgement before continuing.

## Step 2 — where they're starting from
Ask, one at a time:
1. Comfort level with Linux basics and the command line (new / okay / solid).
2. Comfort level with basic networking (ports, protocols, what a service is).
3. Any prior CTF/lab experience — TryHackMe, HTB, CTFs, none?
4. Do they have an exam date booked, or still deciding?
5. Roughly how many hours a week can they realistically put in?

## Step 3 — pick a starting point
Based on the answers:
- **Brand new / new to Linux or networking**: start with TryHackMe's free
  "Pre Security" and "Offensive Pentesting" learning paths before touching a
  real box. Don't let them jump straight to exploitation with no fundamentals.
- **Some CTF experience, shaky on methodology**: start with a handful of
  easy TryHackMe/HTB boxes, enforcing the `recon-enum` → notes → foothold →
  privesc workflow from the start, since that habit matters more than the
  box itself.
- **Already comfortable, prepping for a booked exam**: suggest TJ Null's
  OSCP-like box list on HTB, and Proving Grounds Practice, with AD-focused
  boxes if the exam date is AD-heavy in the current format.

## Step 4 — record it
Create `STUDENT_PROFILE.md` from `templates/student-profile.md`, filled in
with their answers. This is what lets later sessions skip onboarding and
pick up where they left off.

## Step 5 — hand off
Confirm the plan in one short paragraph, then stop and let them choose the
first concrete action (e.g. "pick the first TryHackMe room" or "give me the
first box"). Don't start enumerating or teaching technique yet — that begins
in the next message, once they've picked.
