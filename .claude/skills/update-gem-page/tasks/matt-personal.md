# Task: Matt's personal section

The bullets under **`Matt:`** at the very bottom of the page, in the "PM and
architect status (Nick, Matt)" section. Its purpose: anything Matt has done
personally this week that is of interest to the group **and not covered
elsewhere on the page**.

This runs in two phases. Do not skip to phase 2.

## Phase 1 — propose candidates, no prose

Gather activity, then split it into two lists. Write **no bullet prose** in this
phase; the point is to jog the user's memory, and a polished draft invites
rubber-stamping of things that don't deserve the space.

1. **Already covered elsewhere on the page** — matches an existing bullet here
   or content in another section. Name what it maps to, one line each.
2. **Not mentioned anywhere** — the candidates. For each: what it was, who was
   involved, the date, and a link. Add a sentence on why it might interest the
   group, and say plainly when you think it probably doesn't.

Order list 2 by likely interest, **not** chronologically:

1. Email threads and documents — decisions, proposals, outreach, things others
   asked for. Highest value: they represent influence and judgement, and appear
   in no other tracker.
2. Anything with a consequence for the rest of the team — an announcement, a
   migration, something people must now do differently.
3. PRs and commits last. These are usually already compressed into one bullet
   by the user, and a long PR list buries the interesting items.

### Some candidates belong in a different section

A candidate that **requires an action from other people** is not a "Matt" bullet
— it belongs under the top-level `## Extra agenda items for today`, which is for
things the meeting must actually discuss or act on.

Sort each candidate: *interesting to know* stays in the Matt list; *someone else
now has to do something* is proposed for Extra agenda items. Say which you are
proposing and why. The test is whether a reader has a task afterwards.

For example, completing a Debian upgrade is of interest and belongs in the Matt
bullets; retiring looter, which forces everyone to rebase branches and move to
dev containers, is an agenda item. The same piece of work can generate both.

Close phase 1 by reminding the user that conversations, reviews, advice and
decisions steered are invisible to every source here, and are often the best
content in this section.

## Sources

Cover the last 7 days. Run them in parallel.

**Sent mail — the strongest source.** Highest value and the most sensitive, so
keep it scoped to the work week and filter hard:
```
in:sent after:<YYYY/MM/DD> -label:"Source control" -label:Build -label:Defects
```
Then discard: subjects starting `Accepted:`, `Tentatively Accepted:`,
`Declined:`, `Invitation:` (calendar auto-replies — they were a third of the
hits in testing), and anything from a `noreply`/`drive-shares` sender. What
remains is real correspondence. Read the thread where the reply matters: a
response often carries the actual state, such as a blocker or a commitment.

**Google Drive.** `list_recent_files` with `orderBy: lastModifiedByMe`. Picks up
documents, specs and decks, and corroborates mail — a doc usually has a covering
email. Ignore: untitled documents, auto-generated meeting notes and recordings,
and anything obviously personal (this account's Drive holds personal files, so
never list them as work candidates).

**GitHub.** Authorship is self-declared and reliable here, unlike Jira's
assignee field.
```
gh search prs --author=matj-sag --updated=">=<YYYY-MM-DD>" --limit 50 --json repository,number,title,state,updatedAt,url
gh search prs --reviewed-by=matj-sag --updated=">=<YYYY-MM-DD>" --limit 50 --json repository,number,title,state,updatedAt,url
```
Include reviews: review work is otherwise invisible. Do **not** use local
`git log` — the checkouts under `~/work` are usually weeks stale and will
silently return nothing.

**Confluence.** One cheap call, low yield, occasionally corroborates something:
```
contributor = currentUser() AND lastmodified >= now("-8d") AND type = page ORDER BY lastmodified DESC
```
Discard the GEM pages themselves.

Skip Jira comment activity — it duplicates the customer-issues task.

## Phase 2 — draft prose, only for what the user picks

Once the user says which candidates belong, write them. Match the section's
existing voice exactly — it is terse to the point of being telegraphic:

> - Debian 13 upgrade complete, just waiting to promote PAQ
> - Arm docker images ready to merge
> - Looking at getting our SLIs to production
> - Looking at generating a support AI setup to improve the hit rate of them fixing it and reduce poorly filed tickets to us - <link>

Rules:

- **One line each.** Two short clauses at most. If it needs a second sentence,
  it is too long — cut the background, keep the outcome.
- **No "I".** Sentence fragments, no subject pronoun.
- Lead with state, not narrative: "complete, just waiting to promote PAQ",
  "ready to merge". A reader should get the status in the first four words.
- Append a link with ` - <url>` when there is a document or PR worth opening.
  One link per bullet.
- Say what it means for other people where that is the point — an announcement
  that changes someone's workflow is more interesting than the work behind it.
- No adjectives of self-assessment. Never "successfully", "significant",
  "great progress".

Offer the drafted bullets for the user to edit rather than writing them to the
page unprompted.
