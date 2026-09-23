# Task: zone deployments

Report which Apama version each Cumulocity zone is running, and when it got there.

## Source of truth

Gmail, label **`Source control/Zone Deployments`** (label id `Label_5757180393099492645`).
Quote the label name in queries — `label:"Source control/Zone Deployments"`.
Searching by the label *id* returns nothing.

Each deployment is a GitHub PR in `Cumulocity/c8y-ops-zone-<N>`, one PR per
cluster per component, titled:

> Update `<cluster>` cluster `<component>` with version `27.<n>.0` and HIR flag false (PR #NNNNN)

## Method

Use `apama-ctrl-1c-4g` as the bellwether component — it ships with every
release, exists in every zone, and covers more clusters than the other
`apama-ctrl-*` charts, so one query per zone is enough:

```
label:"Source control/Zone Deployments" subject:(zone-<N> apama-ctrl-1c-4g)
```

Run zones 0–4 in parallel, `pageSize` ~12, and read the thread messages:

- **`Merged #NNNNN into <cluster>`** — this is the deployment. Its date is the
  publish date. The highest version with a merge message is what the zone runs.
- A thread with only the `c8y-cicd-automation-1[bot] left a comment` message, or
  an `approved this pull request` with no merge, is **still open** — raised, not
  deployed. Report these separately as in flight.
- **`Closing this PR automatically: a newer version ... is now available`** — the
  version was skipped, never deployed. Do not report it.

A zone is only fully on a version once every cluster in it has merged; if some
clusters merged and others are still open, say which are outstanding.

If a zone query is ambiguous, narrow to a specific cluster, e.g.
`subject:(zone-1 eu-latest apama-ctrl-1c-4g) Merged`.

## Zones and their clusters

| Zone | Character | Clusters seen |
| --- | --- | --- |
| zone-0 | earliest / internal | preprod-c8y-io-eks, training-c8y-io-aks |
| zone-1 | dev + eu-latest | eu-latest-cumulocity-com-eks, abb-dev-aks, bsci-dev-eks, itron-us-dev-aks, sap-dev-aks, solenis-dev-aks |
| zone-2 | production APAC | apj-cumulocity-com-eks, jp-cumulocity-com-eks |
| zone-3 | production + test | c8y-cumulocity-com-eks, us-cumulocity-com-eks, emea-cumulocity-com-aks, abb-test-aks, flexco-test-eks |
| zone-4 | production, dedicated | abb-prod-aks, bsci-prod, sap-eu-prod-aks, sap-us-prod-aks, solenis-prod, stw-prod-eks |

Versions flow roughly zone-0 → zone-1 → zone-2/3/4, so higher zone numbers lag.
`eu-latest` (zone-1) is the one that matters for "when will customers see it".

Do **not** use `apama-ctrl-smartrulesmt` — it is being retired in favour of
`apama-ctrl-mt`, which is not yet onboarded onto all zones, so neither is a
reliable bellwether during the transition. Once `-mt` is on every zone it
becomes a candidate; `-1c-4g` is fine either way.

The cluster lists above are what has been observed, not a guarantee — a zone may
gain clusters. Take the clusters from the query results rather than assuming
this table is complete.

Other components deploy alongside in the same batch — `apama-ctrl-starter`,
`apama-ctrl-mt`, `apama-ctrl-smartrulesmt`, `apama-ctrl-250mc-1g`, `apama-subscription-mgr`,
`streaming-analytics-app`, `data-prep-app`, `data-prep-ctrl`, `data-prep-plugin`.
Only check these if the user asks about a specific component (e.g. tracking a
Data Preparation rollout).

## Target section on the page

```
## Apama Cumulocity deployments

**Deployments (Updated on <today>)**

- **27.253.0** is deployed to zone-4 on <date>
- **27.253.0** is deployed to zone-3 on <date>
- ...
```

Keep the existing zone-4 → zone-0 ordering and the `**version** is deployed to
zone-N on <date>` wording. Dates are the merge dates found above. Add a short
note under the list for anything in flight (PRs raised but unmerged), rather
than reporting an unmerged version as deployed.
