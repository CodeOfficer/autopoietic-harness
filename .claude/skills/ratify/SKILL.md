---
name: ratify
description: Owner-invoked promotion verb — use when the owner asks to ratify, reject, or review pending proposals in kb/improvements/ or kb/governance/amendments/.
---

# Ratify

## Purpose

Apply the owner's decision on pending proposals: promote staged artifacts into the live harness, or reject with a recorded rationale. This is the only path from `status: proposed` to a live mechanism (constitution Articles 1, 5, 7).

## Inputs

- Pending items: files with `status: proposed` listed in `kb/improvements/index.md` and `kb/governance/amendments/index.md`.
- Their staged artifacts, if any, under `.claude/staging/<proposal-id>/`.
- The lifecycle rules in `kb/self-improvement.md`.

## Steps

1. List pending proposals; confirm with the owner which to decide (never assume scope).
2. For each decided proposal, show what adoption concretely changes — the staged artifact or the amendment text.
3. **Adopt:** verify the target tier is legitimate (root targets need graduation evidence: ratified in ≥2 projects, or a project-agnostic argument the owner accepts); apply the artifact to its live location; note how its acceptance criteria will be checked (Article 6); set `status: adopted`.
4. **Reject:** set `status: deprecated` with a checkbox-level rationale (e.g. "rejected — out of scope").
5. Either way: record the decision and rationale in the proposal file per Article 1, update the relevant index, delete the proposal's staging directory, and commit.

## Constraints

- Only runs interactively at the owner's request — never from a hook or headless session.
- Decide only what the owner named; leave everything else `proposed`.
- Never edit a proposal's substance while deciding it; counter-proposals are new proposals.
