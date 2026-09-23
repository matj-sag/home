---
name: update-gem-page
description: Refresh the weekly Apama GEM meeting page in Confluence (space "apama") with current status. Use when the user asks to update the GEM page, prepare for the GEM meeting, or refresh a specific GEM section such as the zone deployment versions. Each updatable section is a separate task file under tasks/.
---

# Update the Apama GEM page

The GEM page is recreated each week by copying the previous week's page, so the
*content* is stale on arrival and the *structure* is stable. This skill finds
this week's page and refreshes one or more sections in place.

## 1. Find this week's page

- Site (cloudId): `cumulocity.atlassian.net`, space key `apama`.
- Title format: `YYYY-MM-DD Apama GEM Meeting`, dated the **Wednesday** of that week.
- Find it with `searchConfluenceUsingCql`:
  `space = apama AND title ~ "Apama GEM Meeting" ORDER BY created DESC`
  and pick the newest title whose date is today or the current week.
- If the newest page is from a previous week, the copy hasn't been made yet — say
  so and ask whether to update last week's page or wait.
- Read it with `getConfluencePage` using `contentFormat: markdown` to see the
  current values; write back with `updateConfluencePage`.

## 2. Pick the tasks

Ask which sections to refresh unless the user already said. Run only what was asked.

| Task | Section on the page | File |
| --- | --- | --- |
| Zone deployments | `## Apama Cumulocity deployments` | `tasks/zone-deployments.md` |
| Customer issues | `## Customer issues` | `tasks/customer-issues.md` |

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
