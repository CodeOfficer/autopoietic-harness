---
id: kb-self-improvement
title: Self-Improvement Lifecycle
description: How observed friction becomes ratified harness improvements without self-ratification
tags: [improvements, lifecycle, governance]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-primitive-selection, kb-gov-end-session-review, kb-layered-knowledge, kb-gov-constitution]
---

# Self-Improvement Lifecycle

Four stages, governed by the constitution (Articles 1, 4, 5, 6, 7):

1. **Observe.** Friction lands in the gitignored ledger `.claude/friction/events.jsonl`: mechanically via the `PostToolUseFailure` / `PermissionDenied` hooks, and by agents appending one-line notes for recurring friction they notice. Raw telemetry never enters `kb/`.
2. **Synthesize.** The SessionEnd review reads the ledger, clusters recurring events by root cause, picks a primitive per [primitive-selection.md](primitive-selection.md), and writes a proposal to `kb/improvements/` with acceptance criteria. Executable artifacts (draft skills, hook diffs) go to `.staging/<proposal-id>/` — inert by construction, since the harness only loads from live locations.

   The ledger records **only failures**, so it cannot show that a later attempt succeeded. Three rules keep that from becoming false knowledge:

   - **Iteration is not friction.** Repeated failures while converging on a goal are the cost of the work. A pattern counts only when independent sessions, separated in time and doing *unrelated* work, hit the same wall — not when one stretch of work retried its way to success.
   - **Observation, not diagnosis.** The ledger shows *what* failed, never *why*. State the observed pattern and say the cause is unverified; never assert a root cause the review could not check (it has no shell). "Probes for X failed three times; cause unverified" — not "X is unavailable."
   - **Half-life test.** If a fact would not survive a container rebuild or hold on another machine, it is state, not knowledge: no `kb/` entry at any tier. Conventions and decisions age slowly; installed tools and `PATH` age in minutes. Never propose a mechanism that instructs agents to stop checking something — a wrong belief plus an instruction not to look cannot be corrected.
3. **Ratify.** The owner runs the `ratify` skill: adopt (apply staged artifact, record decision per Article 1, commit) or reject (checkbox rationale). Nothing promotes itself.
4. **Promote by tier.** Session ledger → project-local layer (proposal targets the project's own `kb/` or `CLAUDE.md`) → repo baseline. Root promotion requires **graduation evidence: the pattern ratified in ≥2 projects**, or a stated project-agnostic argument; it is a second proposal and second ratification, and reduces local copies to pointers. Reviews may also propose deprecation when a mechanism's target friction no longer appears.
