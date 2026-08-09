---
id: kb-gov-end-session-review
title: End-Session Review Enforcement
description: How the SessionEnd hook automatically runs the convention's review and where proposals land
tags: [governance, hooks, enforcement]
status: adopted
updated: 2026-08-08
owner: codeofficer
related: [kb-gov-constitution, kb-gov-amendments-index]
---

# End-Session Review Enforcement

When any Claude Code session in this repository ends, a `SessionEnd` hook (`.claude/settings.json`) runs `.claude/hooks/end-session-review.sh`, which launches one detached headless review (pinned to Sonnet) with two duties: the governance review per the `governance-convention` skill, and friction synthesis per `kb/self-improvement.md`.

- **Output:** governance session files in `kb/governance/amendments/` and improvement proposals in `kb/improvements/` (all `status: proposed`), with any executable artifacts quarantined in `.claude/staging/` — saved for owner review at their convenience. Under Article 4, a duty with nothing new writes nothing.
- **Containment:** the headless run's permissions only allow writing inside `kb/governance/amendments/`, `kb/improvements/`, and `.claude/staging/`. It cannot modify the constitution, live skills, hooks, `CLAUDE.md`, or other knowledge, and it does not run git. Adoption always requires the owner's `ratify` action.
- **Mechanics:** a recursion guard (`GOVERNANCE_REVIEW_HOOK` env var) stops the review session from re-triggering itself; a lock directory prevents concurrent reviews; output logs to `.claude/hooks/end-session-review.log` (gitignored).
