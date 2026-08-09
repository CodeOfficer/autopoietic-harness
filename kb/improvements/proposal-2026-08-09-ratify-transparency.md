---
id: kb-imp-ratify-transparency
title: Ratify Transparency and Granularity
description: Ratify skill must show a plain-English manifest per item and take item-by-item decisions, side-actions decoupled
tags: [improvements, governance, ratify]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-self-improvement, kb-gov-constitution]
---

# Proposal: Ratify Transparency and Granularity

Friction observed: `/ratify` presented pending items as pre-bundled choice packages ("adopt all five", "adopt 2–5"), forcing votes without per-item understanding — against the spirit of Article 1 (human accountability).

**Change (primitive: skill revision):** the `ratify` skill now requires (1) a plain-English manifest for every pending item — what changes, why it's needed, before vs. after, risks & dissents — before any interactive options; (2) item-by-item decisions, never pre-bundled groups unless the owner asks; (3) side-actions (e.g. dissent counter-proposals) surfaced only after ratifications complete, as clearly labeled optional tasks.

**Acceptance criteria:** every `/ratify` run shows the four-part manifest per item before its first question, and no question offers a multi-item bundle unprompted.

## Ratification (2026-08-09)

**Adopted** — direct owner instruction defining the criteria; implemented in `.claude/skills/ratify/SKILL.md`.
