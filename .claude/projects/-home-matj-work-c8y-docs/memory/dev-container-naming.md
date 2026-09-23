---
name: dev-container-naming
description: "Apama dev container naming convention — dairy cow names (amd64), parts of a cow's arm (arm64)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0f27ccd7-5bfe-4d12-a3fb-9ec369ddb564
---

Apama dev containers (in apama-infrastructure-server-containers/dev-envs) are cattle-not-pets and named after traditional dairy cows. amd64: daisy, buttercup, bessie (debian12 y2026). arm64 containers are named for parts of a cow's arm/foreleg: hoof, brisket (debian12), shank (debian13, APMF-2733). Spare name candidates: clover, molly, gertie (amd64); hock, fetlock, knuckle (arm64).

**Why:** brisket/shank are the only arm64 dev environments — no physical arm hardware exists; new OS versions get a new container instance rather than in-place upgrades.

**How to apply:** when a plan adds a dev environment, name it per this convention and deploy a new instance alongside the old one.
