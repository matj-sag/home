---
name: day-plan
description: Morning triage for Matt. Produces an ordered view of what is in flight, what is fine and needs no attention, and what could be picked up again, so he can judge what to work on today. Use at the start of the day, or when asked what to work on, what is outstanding, or what has stalled.
---

# Day plan

An ordered priority list to start the day with. Not a status report and not a
list of everything — a judgement aid. The user decides what to work on; this
gives them the state of the board in one screen.

Their work no longer comes off a backlog. It lives in email threads, Google
docs, PRs, Jira, AI sessions and conversations, and the failure mode is not
forgetting *to do* something — it is forgetting that something exists at all.

## The ordering principle

Rank by **what changes if you do nothing today**, not by recency and not by age.

Inputs to that, roughly in order of weight:

1. **A commitment with a date.** A release date, a customer deadline, a promise
   made in a thread. Check the current GEM page's "Extra agenda items" for dates
   in flight (see the `update-gem-page` skill for finding that page).
2. **A meeting today or tomorrow that touches it.** If there is a 1:1 with
   Sandeep tomorrow, anything needing his decision is due today. Meetings make
   otherwise-quiet items urgent, and they are the main reason this is a *daily*
   list rather than a weekly one.
3. **Someone is blocked on you.** A review requested, a question asked twice, a
   thread where the last message is theirs and it ends in a question.
4. **Someone is blocked and does not know it.** You owe a reply you have not
   sent, and they are waiting quietly.
5. **Decay risk.** Something will get harder or die if left: a PR going stale
   against a moving branch, a proposal losing its moment, a person about to go
   on leave.

Everything else is band 2.

## Output: three bands, in this order

### 1. Needs you today
Ordered, most consequential first. Each line: what it is, why it is here today,
and the smallest next action. Aim for **five or fewer**. If more qualify, say so
and cut to the top five rather than listing them all — a long band 1 is the same
as no band 1.

Lead with the day's shape: meetings, and roughly how much unbooked time is
actually left. A list of eight things is useless on a day with two free hours,
and saying so is part of the job.

### 2. In flight, fine for now
Things genuinely in progress that do not need attention today. **Do not
enumerate in detail** — one line each at most, or a count with names. This band
exists to be reassuring, so the user can stop holding it in their head. If it
takes more than a few lines, it is too verbose.

Say explicitly when something is in this band *because* it is waiting on someone
else, and when the wait becomes unreasonable.

### 3. Could pick up again
Dormant, but worth resurrecting. **Three to five, ranked by value, never a dump.**
For each, say why now — what has changed that makes it live again, or that it
simply never got closed. Proposals awaiting a decision are the richest seam here;
they die silently and nobody chases them.

Prefer items where a small action restarts them. "Ping X for a decision" beats
"rewrite the design".

## Sources

Run in parallel. Details of query syntax and pitfalls are in
`update-gem-page/tasks/matt-personal.md`, which covers the same sources.

- **Calendar** — `list_events` for today and tomorrow. Gives the day's shape,
  free time, and which topics have a forcing function. Note attached documents;
  a meeting with a doc usually implies prep.
- **Mail** — `in:sent` for the last ~14 days, filtered per the matt-personal
  rules. For each thread, find who sent the **last** message: theirs means the
  ball is with the user; ours means they are the blocker. A thread ending in a
  question from them is band 1.
- **GitHub** — `gh search prs --author=matj-sag --state=open` and
  `--reviewed-by=matj-sag`. Sort by `updatedAt` ascending. Under a week is band
  2; weeks-to-months is band 3. Ignore anything over a year unless it relates to
  something live today.
- **Jira** — issues where the user is reporter or commenter and the last comment
  is not theirs. Trust the comments, not the assignee field, which is often wrong.
- **Google Drive** — `list_recent_files` with `orderBy: lastModifiedByMe`.
  Documents they wrote and shared are often awaiting feedback. Ignore personal
  files; this account's Drive holds them.
- **Local AI sessions** — `~/.claude/projects/*/*.jsonl`, one file per Claude
  Code session. The first user message of each reconstructs what it was about,
  and the file mtime gives when it was last touched. This is the only view of
  the user's AI work. Sessions abandoned mid-thread are good band 3 candidates.

**Not reachable:** claude.ai web chats, Google Chat. Say so once at the end, so
the user knows which part of the picture they are holding themselves.

## State

`~/.claude/day-plan/state.json` carries what the user has told you, so the list
improves rather than repeating itself:

```json
{
  "active": [{"id": "...", "note": "what it is", "added": "YYYY-MM-DD"}],
  "snoozed": [{"id": "...", "until": "YYYY-MM-DD"}],
  "dismissed": [{"id": "...", "reason": "..."}],
  "lastRun": "YYYY-MM-DD",
  "lastShown": ["id", "..."]
}
```

- **Read it first.** Honour `snoozed` and `dismissed` — never re-raise a
  dismissed item, and do not resurrect a snoozed one before its date.
- **Band 1 is partly declared, not derived.** What the user considers actively
  in progress cannot be inferred reliably from systems. On the first run, propose
  a seed list from the evidence and ask them to confirm or correct it. Afterwards
  treat `active` as authoritative and merge evidence into it.
- **Mark what is new.** Compare against `lastShown` and flag items not shown last
  time. Without this the same dormant PRs appear every morning and the user
  learns to skim past the whole thing — which kills the skill.
- Offer to snooze or dismiss anything at the end, and write the file.

## Tone

Terse. No preamble, no restating the question, no "great progress". The user is
reading this before their first meeting. A line they have to parse twice has
failed.
