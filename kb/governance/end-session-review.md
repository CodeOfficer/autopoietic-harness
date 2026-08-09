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

- **Output:** governance session files in `kb/governance/amendments/` and improvement proposals in `kb/improvements/` (all `status: proposed`), with any executable artifacts quarantined in `.staging/` — saved for owner review at their convenience. Under Article 4, a duty with nothing new writes nothing.
- **Containment (verified 2026-08-09):** `--allowedTools` is an allow-list, not a restriction — omitted tools fall through to the rest of the permission stack, where read-only shell commands are auto-approved. So the guarantees rest on two mechanisms:
  - **Writes:** only `Edit(path)` rules grant file writes. The run can write inside `kb/governance/amendments/`, `kb/improvements/`, and `.staging/` and nowhere else — tested directly: a write to an unlisted `kb/` path is denied. It cannot modify the constitution, live skills, hooks, or `CLAUDE.md`.
  - **Shell:** `--disallowedTools "Bash"` denies the shell outright (deny beats allow), so the run cannot execute commands or read outside the repo. Without this flag, read-only commands such as `git log` execute regardless of the allow-list.
  - **Staging path:** artifacts live in `.staging/`, not under `.claude/` — `.claude/` is a built-in sensitive path that an `Edit()` rule cannot override, so writes there are always denied.

  Adoption always requires the owner's `ratify` action.
- **Mechanics:** a recursion guard (`GOVERNANCE_REVIEW_HOOK` env var) stops the review session from re-triggering itself; a lock directory prevents concurrent reviews; output logs to `.claude/hooks/end-session-review.log` (gitignored).
