---
name: tpsafe-rules-source-urls
description: "Patched third-party source URLs for compliance scanning live in the tpsafe-rules repo, not in apama-cep's 3rd_party_dependencies.properties"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 4d4d00fa-c49a-4c7d-a093-98c282ba5ac8
  modified: 2026-09-04T13:14:13.492Z
---

The scannable source location for a patched third party is declared in the
**tpsafe-rules** repo (checkout at `/home/matj/work/tpsafe-rules`) as a
`sourceURL` on a `purlPrefixes` rule — *not* in apama-cep's
`apama-src/3rd_party_dependencies.properties`. The properties file's `*_LEGAL`
lines carry the purl that the tpsafe rule keys off; a missing `url=` there is
not what makes a compliance check fail.

Rule files: `component-rules/c-cpp-component-mappings.yaml` (native),
`component-rules/maven-opensource-component-rules.yaml` (Java), alphabetical by
component name. A patched entry pairs `sourceURL` with
`isModificationOf: <upstream purl>`.

Patched source goes in a **public GitHub repo under whatever personal account
the person doing the work has** — there is no org convention, and `bph-c8y` in
the existing rules is just whoever did it last time, not a shared location. The
repo is effectively throwaway: it only has to exist long enough for the scanner
to fetch it once, so don't treat these URLs as durable or worry about a
permanent home.

`sourceURL` points at a tag archive tarball, e.g.
`https://github.com/bph-c8y/paho.mqtt.c/archive/refs/tags/paho-c-${version}.tar.gz`;
`${version}` interpolates from the matched purl. ~69 rules use GitHub; ~18
older ones (antlr included) still point at `https://svn.apama.com/dev/apama-lib-src/...`
zips.
