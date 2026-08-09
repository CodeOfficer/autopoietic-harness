---
id: kb-imp-pending-proposals-visibility
title: Pending-Proposals Visibility
description: SessionStart hook that surfaces how many proposals await ratification
tags: [improvements, hooks, visibility]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-self-improvement, kb-primitive-selection]
---

# Proposal: Pending-Proposals Visibility

The owner had no passive way to see pending proposals; discovering them required running `/ratify` or grepping. Per [primitive-selection.md](../primitive-selection.md) this is deterministic, event-tied, judgment-free behavior — a **hook**.

A `SessionStart` hook runs `.claude/hooks/pending-proposals.sh`, which greps `kb/` for frontmatter `^status: proposed` and shows "N proposal(s) awaiting ratification: <files> — run /ratify to review" at session start; silent when the queue is empty.

## Acceptance criteria

Opening a session with pending proposals shows the count and paths; with an empty queue it shows nothing.

## Ratification (2026-08-09)

**Adopted** by the owner (requested directly, alongside continued use of `/ratify` as the listing verb). Implemented and verified same day: output tested against the one currently pending proposal and confirmed silent-on-empty by exit path.
