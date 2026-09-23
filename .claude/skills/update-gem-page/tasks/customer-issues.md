# Task: customer issues

Refresh the `## Customer issues` section — re-summarise the entries already
there, re-file them into the right category, and surface anything new.

**This task cannot complete on its own.** A large share of the section comes from
the Analytics/Apama Discuss Google Chat space, which is not reachable from here.
Produce a first pass over the reachable sources, then hand back an explicit list
of what could not be verified. Never present the draft as a complete section.

## The cardinal rule: state comes from the comments

Determine the current state of an issue by **reading the full comment thread**,
oldest to newest, and summarising where it actually stands.

- The Jira **status** field is a weak hint for categorisation, not an authority.
  It is often behind the conversation.
- The **assignee** field carries almost no signal — it is frequently wrong. Do
  not infer ownership, progress or who is blocked from it. If the comments say
  someone is looking at it, believe the comments.
- The last comment is usually the most informative, but read the whole thread —
  the last comment is often "any update?" from support, which tells you the state
  is *waiting on us*, not what the state is.
- Watch for the conversation moving off-ticket: comments frequently link to a
  `chat.google.com` room, meaning the real state is in chat. Flag those; do not
  guess what happened there.

Write each entry the way the page already does: customer name and ticket, a
short plain-language line on the problem, then the current state in **bold**.

## Sources

Run these in parallel. cloudId `cumulocity.atlassian.net`.

1. **Unresolved customer itracs** (the "bottom filter" — the main source of new items):
   ```
   (filter in ("Apama - Open customer issues")) OR (project = "CST" AND status NOT IN (Closed, Resolved) AND "product[dropdown]" = APAMA) ORDER BY project DESC, createdDate DESC
   ```
2. **Company-wide escalations**, include only what is Apama-relevant:
   - hot issues: `project = CST AND "cst hot issue[dropdown]" = Yes AND status NOT IN (Closed, Resolved)`
   - crisis: `project = CST AND "Severity CST[Radio Buttons]" = Crisis AND resolved is EMPTY`
   - security: `project = CST AND "Security related incident[Checkboxes]" = Yes AND status NOT IN (Closed, Resolved)`

   These are company-wide, so most hits belong to other teams. Judge relevance
   from the summary and the product field; say explicitly when the answer is
   "nothing relevant to us" rather than silently dropping them.
3. **Tech community**, last 7 days only:
   `https://community.cumulocity.com/tag/streaming-analytics-apama`
   (the old `techcommunity.cumulocity.com` host 301s here). Most weeks there is
   nothing new; an empty bullet under "Tech Forums / Help" is a normal outcome.
4. **Existing entries on the page** — every bullet already in the section, whether
   or not it appears in a filter above.

Fetch comments with `fields: ["key","summary","status","updated","comment"]` and
`responseContentFormat: "markdown"`.

## Categories

Re-file each entry into the headings the page already uses, based on what the
comments say:

| Heading | Means |
| --- | --- |
| Escalations / CRISIS / Active production issues | live production impact, or formally escalated |
| Actively working | we hold the ball and work is in progress |
| Waiting for customer | we have asked them something and are blocked on the answer |
| Waiting for close | our work is done; ticket open pending confirmation or admin |
| Moved to another team | no longer ours; say who has it |

Entries move between weeks — re-deciding the category is the point of the pass,
not an optional extra. Note in the report when something changed category.

## Output: a diff, not a finished section

Report in three parts:

1. **Verified and updated** — entries backed by a ticket, with the re-summarised
   state and any category change (old → new).
2. **New candidates** — in a filter but not on the page. Include a recommendation
   on whether it belongs; some are deliberately excluded.
3. **Could not verify** — entries on the page with no ticket behind them in any
   reachable filter. List them by name. These are the ones only the user can
   refresh, from the **Analytics/Apama Discuss Google Chat space**. Ask the user
   to do that pass, and offer to fold the result back in.

Expect part 3 to be substantial — historically most of the section. Do not
quietly drop an entry just because no ticket was found for it; an entry with no
ticket is a gap to report, never a resolved item.

## Follow-up mode

The user will often come back with extra tickets found in chat that the filter
missed, e.g. "also look at PAB-1234 and CST-5678". Treat these exactly like
filter hits: read the whole comment thread, summarise the state, propose a
category, and merge them into the same three-part report. No separate process.
