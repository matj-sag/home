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

**Being notified about something makes it *less* important here, not more.** The
user reads their own mail. Anything that arrived this morning will be seen
anyway, and repeating it wastes the top of the list. The value of this skill is
entirely in what produced **no notification** — a doc nobody commented on, a
thread that simply stopped, a proposal nobody replied to. When two items are
otherwise equal, the silent one goes first, and something that pinged this
morning should usually not be in band 1 at all.

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

### Never include

- **Zone deployment PRs** (`c8y-ops-zone-*`). They matter for the GEM page, not
  for the user's own day, and there are dozens of them. The `update-gem-page`
  skill covers them.
- Anything in `state.json`'s `dismissed` list. See **State** — reasons include
  things the user simply cannot action, such as lacking permission on a project,
  which is invisible from the data.

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

**Bullet these, one line each — never a run-on paragraph.** This band is a recall
aid, not an exception report: its job is to keep reminding the user that things
exist, so they can stop holding them in their head. Being broad is the point.
Include documents written and shared, proposals out for feedback, threads
awaiting a reply, PRs in review, and work-in-progress AI sessions — not only
things with an open question.

For each: what it is, who has it, and **how long since anything happened**. The
age is what makes the band useful; it is how the user spots something drifting.

Say explicitly when an item sits here *because* it is waiting on someone else,
and flag when that wait is getting long.

**Aging rule.** Anything whose last traffic is **more than ~14 days** old is no
longer "in flight" — move it to band 3, and say that is why it moved. This is
the main way things travel between bands, and it happens without the user doing
anything, which is exactly the drift they want caught.

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
- **AI sessions, across every machine** — run
  `python3 ~/.claude/skills/day-plan/scripts/scan-sessions.py --days 30`.

  Transcripts are **per-machine** and no host can see another's, so the laptop
  alone shows well under half the picture. The script covers all three stores:

  | Host | Store | Covers |
  | --- | --- | --- |
  | local | `~/.claude/projects` | the laptop |
  | devpod | `/workspaces/apamabld/.claude/projects` via ssh | dev container work; `/home/apamabld` is a symlink onto the Longhorn PVC, so this survives stop/start |
  | looter | `/users/ukcam/matj/.claude/projects` via ssh | the shared home, so the whole wider machine estate in one read |

  Each line is date, host, project, size and the opening prompt, which is enough
  to recognise what a session was. Size is a rough proxy for how deep it went.
  Sessions abandoned mid-thread are good band 3 candidates.

  If a host is unreachable the script says so on stderr — **pass that on**. The
  devpod is often stopped, and a missing machine is a missing slice of the
  picture, not an absence of work.

**Not reachable:** claude.ai web chats and Google Chat. Say so once at the end,
so the user knows which part of the picture they are holding themselves.

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
- **Record why.** Much of what makes an item unactionable is invisible in the
  data: the user may lack permission on a project, or it may belong to someone
  else. You cannot detect that, so when the user says it, write it to
  `dismissed` with the reason and never surface it again.
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
