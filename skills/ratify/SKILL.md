---
name: ratify
description: Owner-invoked promotion verb — use when the owner asks to ratify, reject, or review pending proposals in kb/improvements/ or kb/governance/amendments/ or global proposals cache.
---

# Autopoietic Harness: Ratify

## Purpose

Apply the owner's decision on pending proposals: promote staged artifacts into the live harness (either locally in the target repository or upstream to the maintainer source directory), or reject with a recorded rationale. This is the only path from `status: proposed` to a live mechanism (constitution Articles 1, 5, 7).

## Inputs

- Pending items: files with `status: proposed` listed in `kb/improvements/index.md`, `kb/governance/amendments/index.md`, or `.claude/friction/proposals.json`.
- Their staged artifacts, if any, under `.staging/<proposal-id>/`.
- Plugin environment options: `CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH` (default `~/code/autopoietic-harness`).
- The lifecycle rules in `core-kb/self-improvement.md`.

## Initialization Guard (Prerequisite)

Before running ratify, check if the current repository is initialized with Autopoietic Harness:
- Verify that `kb/governance/constitution.md` or `.claude/autopoietic-enabled` exists in the working repository root (`$CLAUDE_PROJECT_DIR`).
- **If NOT initialized**: Stop immediately and tell the owner:
  > ⚠️ **Autopoietic Harness is not initialized in this repository.**  
  > Please run `/autopoietic-harness:init` first to scaffold the local governance structure and knowledge base.

## Steps

1. Find every pending item (`status: proposed` in the two indexes or `.claude/friction/proposals.json`).
2. **Manifest before any vote.** Output one chat message containing a card for EVERY pending item, in this exact shape:

   - Header: `📌 Item N: <Title>` — always starting with the 📌 emoji.
   - **Bottom Line (ELI5)** — first bullet, directly beneath the header: one sentence in everyday, non-intimidating language, zero governance jargon, saying what this actually means for the owner.
   - **What changes** — plain English, no jargon.
   - **Why it's needed** — the friction or gap it solves.
   - **Before vs. after** — what stays true today if rejected, what becomes true if adopted.
   - **Risks & dissents** — panel objections, edge cases, potential breakages.
3. **Target Destination Selection (Maintainer Upstream Mode)**:
   - For each proposal to be adopted, ask the owner whether to:
     - **Option A: Adopt Locally (Target Repository)**: Apply staged changes and KB entries directly to the current repository (`kb/`, `.staging/`).
     - **Option B: Promote Upstream (Maintainer Mode)**: Copy staged artifacts and KB entries directly into `$CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH` (e.g., `~/code/autopoietic-harness`) for global plugin distribution.
4. **Single-screen, item-by-item decisions.** After the full manifest, take decisions in ONE step covering all items: a single selection prompt listing every item together.
5. **Adopt:** verify the target tier is legitimate; apply the artifact to its designated location (Local or Upstream); set `status: adopted`.
6. **Reject:** set `status: deprecated` with a checkbox-level rationale (e.g. "rejected — out of scope").
7. Either way: record each decision and rationale in the proposal file per Article 1, update the relevant index, delete the proposal's staging directory, and commit.

## Constraints

- Requires repository initialization (`kb/governance/constitution.md` or `.claude/autopoietic-enabled`).
- Only runs interactively at the owner's request — never from a hook or headless session.
- The manifest always precedes the options: the owner never votes on an item explained only by a label.
- Every card carries its 📌 header and its Bottom Line (ELI5) first.
- Background process NEVER auto-promotes upstream. Upstream promotion happens ONLY when interactively selected in this skill.
