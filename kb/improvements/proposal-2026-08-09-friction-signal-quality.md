---
id: kb-imp-friction-signal-quality
title: Friction Signal Quality Rules
description: Three rules stopping failure-only telemetry from becoming false knowledge
tags: [improvements, lifecycle, telemetry]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-self-improvement, kb-primitive-selection]
---

# Proposal: Friction Signal Quality Rules

**Friction observed:** the 2026-08-09 review read three failed `lazygit` probes and proposed recording "lazygit and all package managers are unavailable" as root-tier knowledge, instructing agents to stop probing. The tools were installed the whole time. The owner's account explains the events: a session deliberately installing, uninstalling, and reinstalling `lazygit` — iteration toward a goal that succeeded, not an obstacle.

**Root cause:** the ledger records only failures, so it structurally cannot show that a later attempt succeeded. Three distinct errors followed from that: diagnosing a cause from symptom-only evidence, treating within-work iteration as a recurring pattern, and recording volatile machine state as durable repository knowledge.

**Change (primitive: process rules in existing concepts — no new mechanism):**

1. **Iteration is not friction** — a pattern requires independent sessions, separated in time, doing unrelated work.
2. **Observation, not diagnosis** — state the observed pattern, mark the cause unverified; the reviewer has no shell and cannot check.
3. **Half-life test** — a fact that would not survive a container rebuild is state, not knowledge, and earns no primitive at any tier. Never propose a mechanism instructing agents to stop checking something: a wrong belief plus an instruction not to look cannot be corrected.

Recorded in `kb/self-improvement.md` (stage 2) and `kb/primitive-selection.md`, and passed to the reviewer in the hook's duty-2 prompt.

## Acceptance criteria

- No proposal asserts an unverified root cause; observed patterns are labelled as such.
- No proposal records installed-tool or `PATH` state as `kb/` knowledge.
- A session that retries its way to success produces no proposal.

## Ratification (2026-08-09)

**Adopted** — owner-directed after diagnosing the `lazygit` incident together. Deliberately tuned to catch obvious noise rather than chase zero noise: an over-tuned filter suppresses real signal, and that failure is invisible, whereas a bad proposal costs one rejection at the `ratify` gate.
