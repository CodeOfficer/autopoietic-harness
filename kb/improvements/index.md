---
id: kb-improvements-index
title: Improvement Proposals
description: Self-improvement proposals synthesized from observed friction, awaiting owner review
tags: [index, improvements]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-self-improvement, kb-gov-amendments-index]
---

# Improvement Proposals

Proposals produced by the automated end-session review (or manual sessions) from observed friction, named `proposal-YYYY-MM-DD-<slug>.md`, with `status: proposed`. Any executable artifact a proposal carries is quarantined in `.claude/staging/<proposal-id>/` and is inert until promoted.

Proposals are **never applied automatically**. The owner decides via the `ratify` skill; decisions are recorded in the proposal file per constitution Article 1. See [../self-improvement.md](../self-improvement.md) for the lifecycle.

## Proposals

- [proposal-2026-08-09-self-improvement-lifecycle.md](proposal-2026-08-09-self-improvement-lifecycle.md) — the friction-observation and promotion lifecycle itself — **adopted**
- [proposal-2026-08-09-pending-proposals-visibility.md](proposal-2026-08-09-pending-proposals-visibility.md) — SessionStart hook surfacing the ratification queue — **adopted**
- [proposal-2026-08-09-ratify-transparency.md](proposal-2026-08-09-ratify-transparency.md) — per-item plain-English manifest and granular decisions in ratify — **adopted**
- [proposal-2026-08-09-test.md](proposal-2026-08-09-test.md) — dry-run test proposal (Friday ☕ commit marker) — **rejected**
- ~~proposal-2026-08-09-sandbox-missing-tools~~ — claimed `lazygit`/`apt`/`snap` are absent; verification showed all three are installed. **Deleted 2026-08-09** as factually wrong at the premise.
