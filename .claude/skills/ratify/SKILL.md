---
name: ratify
description: Owner-invoked promotion verb — use when the owner asks to ratify, reject, or review pending proposals in kb/improvements/ or kb/governance/amendments/.
---

# Ratify

## Purpose

Apply the owner's decision on pending proposals: promote staged artifacts into the live harness, or reject with a recorded rationale. This is the only path from `status: proposed` to a live mechanism (constitution Articles 1, 5, 7).

## Inputs

- Pending items: files with `status: proposed` listed in `kb/improvements/index.md` and `kb/governance/amendments/index.md`.
- Their staged artifacts, if any, under `.staging/<proposal-id>/`.
- The lifecycle rules in `kb/self-improvement.md`.

## Steps

1. Find every pending item (`status: proposed` in the two indexes).
2. **Manifest before any vote.** Output one chat message containing a card for EVERY pending item, in this exact shape:

   - Header: `📌 Item N: <Title>` — always starting with the 📌 emoji.
   - **Bottom Line (ELI5)** — first bullet, directly beneath the header: one sentence in everyday, non-intimidating language, zero governance jargon, saying what this actually means for the owner.
   - **What changes** — plain English, no jargon.
   - **Why it's needed** — the friction or gap it solves.
   - **Before vs. after** — what stays true today if rejected, what becomes true if adopted.
   - **Risks & dissents** — panel objections, edge cases, potential breakages.
3. **Single-screen, item-by-item decisions.** After the full manifest, take decisions in ONE step covering all items: a single selection prompt listing every item together, or — when items exceed one screen's option limit — ask the owner to reply in chat with item numbers (e.g. "Adopt 1, 2, 4; reject 3"). Never page items across multiple question screens, and never present pre-bundled packages ("adopt all", "adopt 2–5") unless the owner has asked for grouping.
4. **Adopt:** verify the target tier is legitimate (root targets need graduation evidence: ratified in ≥2 projects, or a project-agnostic argument the owner accepts); apply the artifact to its live location; note how its acceptance criteria will be checked (Article 6); set `status: adopted`.
5. **Reject:** set `status: deprecated` with a checkbox-level rationale (e.g. "rejected — out of scope").
6. Either way: record each decision and rationale in the proposal file per Article 1, update the relevant index, delete the proposal's staging directory, and commit.
7. **Side-actions last.** Only after all ratifications are recorded, surface optional follow-ups (e.g. acting on a dissenter's counter-proposal) as clearly labeled new tasks — never mixed into the ratification vote.

## Constraints

- Only runs interactively at the owner's request — never from a hook or headless session.
- The manifest always precedes the options: the owner never votes on an item explained only by a label.
- Every card carries its 📌 header and its Bottom Line (ELI5) first — an item the owner cannot understand from that one sentence is not ready to be voted on.
- Decide only what the owner named; leave everything else `proposed`.
- Never edit a proposal's substance while deciding it; counter-proposals are new proposals.
