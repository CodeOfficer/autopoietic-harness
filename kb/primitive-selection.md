---
id: kb-primitive-selection
title: Primitive Selection Rubric
description: How to choose the mechanism (kb, skill, hook, rule, script, process) that fixes a friction root cause
tags: [improvements, conventions]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-self-improvement, kb-okf-format]
---

# Primitive Selection Rubric

Choose the **cheapest primitive that plausibly kills the root cause**. Two ordering questions:

1. Does the fix require judgment at use-time? → yes: kb concept or skill; no: hook or script.
2. Must it be enforced, or merely advised? → enforced: hook or permission rule; advised: kb or `CLAUDE.md`.

| Root cause looks like… | Primitive |
|---|---|
| Agent lacked a fact or misread a convention | kb concept |
| Recurring multi-step workflow needing judgment | skill |
| Deterministic behavior tied to an event, no judgment needed | hook |
| Constraint that must never be missed in any turn | `CLAUDE.md` rule — always-loaded, most expensive, use last |
| Missing tool or repeated environment setup | script |
| Unclear specs, undecidable tradeoffs, human bottleneck | process proposal to the owner — do not automate a human problem |

Every proposal states the primitive chosen, why cheaper ones don't suffice, and acceptance criteria (constitution Article 6).
