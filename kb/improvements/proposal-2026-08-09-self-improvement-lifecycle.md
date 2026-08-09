---
id: kb-imp-self-improvement-lifecycle
title: Self-Improvement Lifecycle
description: Proposal to generalize the governance self-repair loop into friction-driven self-improvement
tags: [improvements, lifecycle, meta]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-self-improvement, kb-primitive-selection, kb-gov-end-session-review]
---

# Proposal: Self-Improvement Lifecycle

Generalize the adopted governance loop (observe → synthesize → propose → ratify) to all execution friction.

## Design

1. **Observation:** `PostToolUseFailure` and `PermissionDenied` hooks append events to the gitignored ledger `.claude/friction/events.jsonl`; working agents append one-line friction notes to the same ledger.
2. **Synthesis:** the single existing SessionEnd headless review also reads the ledger, clusters recurring events by root cause, and writes proposals here with acceptance criteria (Art. 6).
3. **Primitive selection:** per the rubric in `kb/primitive-selection.md` — cheapest primitive that kills the root cause.
4. **Containment & promotion:** artifacts are quarantined in `.claude/staging/` (inert by construction); the owner promotes or rejects via the `ratify` skill. Tier ladder: session ledger → project-local layer → repo baseline, where root promotion requires the pattern ratified in ≥2 projects or a stated project-agnostic argument.

## Owner-decided parameters

- One combined reviewer run (governance + friction synthesis).
- Staging location: `.claude/staging/`.
- Tier-2 graduation threshold: ratified in ≥2 projects.

## Ratification (2026-08-09)

**Adopted** by the owner, who set the three parameters above. Implemented: friction-logging hooks, `kb/primitive-selection.md`, `kb/self-improvement.md`, widened end-session reviewer, `ratify` skill, friction-note rule in root `CLAUDE.md`. Acceptance criteria verified by stub tests at implementation time; ongoing check is whether ledger events produce proposals only when new.

## Acceptance criteria

- Friction events appear in the ledger without agent discipline.
- The end-session review produces improvement proposals only when the ledger has new content.
- No mechanism goes live without an owner `ratify` action recorded per Article 1.
