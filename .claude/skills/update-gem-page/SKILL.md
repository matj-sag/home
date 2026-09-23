---
name: update-gem-page
description: Refresh the weekly Apama GEM meeting page in Confluence (space "apama") with current status. Use when the user asks to update the GEM page, prepare for the GEM meeting, or refresh a specific GEM section such as the zone deployment versions. Each updatable section is a separate task file under tasks/.
---

# Update the Apama GEM page

The GEM page is recreated each week by copying the previous week's page, so the
*content* is stale on arrival and the *structure* is stable. This skill finds
this week's page and refreshes one or more sections in place.

## 1. Find this week's page

**There is exactly one GEM page per week.** It is usually dated the Wednesday,
but the meeting gets moved for scheduling, so the date in the title may be any
weekday. Match on the **week**, never on "is it today's date".

- Site (cloudId): `cumulocity.atlassian.net`, space key `apama`.
- Title format: `YYYY-MM-DD Apama GEM Meeting`.
- Find it with `searchConfluenceUsingCql`:
  `space = apama AND title ~ "Apama GEM Meeting" ORDER BY created DESC`
- Take the newest page and read the date out of its title. If that date falls in
  the **current Monday-to-Sunday week**, that is this week's page — use it, even
  if the date is not today and not a Wednesday.
- If the newest page's date is in an earlier week, the copy for this week has
  not been made yet. Say so and ask whether to update that page or wait. Do not
  assume it is missing just because today is past Wednesday.

**Never create a GEM page.** If one seems to be missing, ask. A second page for a
week that already has one — under a different date, or because the meeting
moved — is a real failure mode: it splits the week's notes across two pages and
the wrong one gets copied forward next week.

- Read it with `getConfluencePage` using `contentFormat: markdown` to see the
  current values; write back with `updateConfluencePage`.

**Beware collapsible sections.** The page uses expand blocks (`<details>` /
`<summary>` in HTML). The markdown rendering **drops the summary heading and
inlines the contents**, so collapsed content looks like it belongs to the
enclosing section and the heading appears to be missing entirely. When a task
concerns content inside an expand — or you cannot find a heading the user says
exists — re-read with `contentFormat: "html"`. The HTML body may be too large to
return inline; it is saved to a file, so extract the part you need with jq or
python rather than re-reading it whole.

## 2. Pick the tasks

Ask which sections to refresh unless the user already said. Run only what was asked.

| Task | Section on the page | File |
| --- | --- | --- |
| Zone deployments | `## Apama Cumulocity deployments` | `tasks/zone-deployments.md` |
| Customer issues | `## Customer issues` | `tasks/customer-issues.md` |
| Matt's personal section | `Matt:` bullets at the page foot | `tasks/matt-personal.md` |

<!-- Add new tasks by creating tasks/<name>.md and adding a row here. Keep each
     task file self-contained: where the data lives, how to read it, and the
     exact target section and formatting on the page. -->

## 3. Report before writing

Always show the user the proposed new values (old → new) and what is still in
flight before calling `updateConfluencePage`. Flag anything that looks like a
risk against a deadline mentioned in the page's own "Extra agenda items" section.

## 4. Writing back

- Edit **only** the target section. Preserve everything else verbatim, including
  empty bullets, empty table cells and the long Jira query URLs — they are
  intentional and get filled in during the meeting.
- The page is a Confluence *live* page; `updateConfluencePage` replaces the whole
  body, so build the new body from the version just read, not from memory.
