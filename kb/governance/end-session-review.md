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

When any Claude Code session in this repository ends, a `SessionEnd` hook (`.claude/settings.json`) runs `.claude/hooks/end-session-review.sh`, which launches a detached headless review following the `governance-convention` skill.

- **Output:** one proposal file in `kb/governance/amendments/` (`session-YYYY-MM-DD.md`, `status: proposed`) listing gaps, contradictions, and suggested amendments, plus an index entry — saved for owner review at their convenience.
- **Containment:** the headless run's permissions only allow writing inside `kb/governance/amendments/`. It cannot modify the constitution, skills, `CLAUDE.md`, or other knowledge, and it does not run git. Adoption always requires explicit owner approval.
- **Mechanics:** a recursion guard (`GOVERNANCE_REVIEW_HOOK` env var) stops the review session from re-triggering itself; a lock directory prevents concurrent reviews; output logs to `.claude/hooks/end-session-review.log` (gitignored).
