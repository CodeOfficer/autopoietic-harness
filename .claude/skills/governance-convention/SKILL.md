---
name: governance-convention
description: Run a self-repairing AI-governance constitutional convention session — use when asked to convene the panel, draft or debate constitutional laws, or review the constitution.
---

# Governance Constitutional Convention

## Purpose

Convene a simulated expert panel that drafts, debates, and proposes constitutional laws for safe, accountable AI development in this repository. The convention repairs itself over time via end-session reviews. It claims no legal authority and invents no compliance requirements.

## Panel

Five expert personas, each drafting independently before any debate:

1. **ML safety researcher** — alignment, evaluation, failure modes.
2. **AI-governance policy expert** — accountability structures, oversight norms.
3. **Security engineer** — misuse, access control, agent containment.
4. **Ethicist** — fairness, human impact, value trade-offs.
5. **Product engineer** — practicality, developer workflow, proportional oversight.

Plus two roles: a **facilitator**, who collects proposals, structures debate, and surfaces disagreements without advocating; and a **chair**, who rules on process and distills debate into concise proposed amendments.

## Inputs

- Current constitution: `kb/governance/constitution.md`.
- Prior sessions: `kb/governance/amendments/`.
- Grounding: current, widely accepted AI-governance principles (e.g. OECD AI Principles, NIST AI RMF). Cite the principle a proposal draws on; if no accepted principle supports it, say so plainly.

## Steps

1. Read the inputs above; the facilitator states the session's focus (a gap, a conflict, or a review request).
2. Each persona independently drafts 1–3 proposed laws or amendments, with a one-line rationale and grounding.
3. The facilitator groups overlapping proposals and surfaces every disagreement explicitly — do not smooth them over.
4. The panel debates the disagreements; the chair distills the result into a concise set of proposed amendments, recording dissents.
5. **End-session review:** the panel identifies gaps, contradictions, and proposed improvements to the convention itself (this skill, the panel, the process).
6. Write one session file to `kb/governance/amendments/session-YYYY-MM-DD.md` (OKF frontmatter per `kb/okf-format.md`, `status: proposed`) containing: proposed amendments, dissents, and the end-session review. Add it to `kb/governance/amendments/index.md`.

## End-session enforcement

The end-session review (step 5–6) is not only manual: a `SessionEnd` hook in `.claude/settings.json` runs `.claude/hooks/end-session-review.sh`, which performs the review headlessly after every session and saves proposals to `kb/governance/amendments/`. See `kb/governance/end-session-review.md`.

## Outputs

- One OKF session file of proposed amendments and convention improvements, saved for owner review.

## Constraints

- **Never apply proposals automatically** — not to the constitution, and not to this skill. Only the owner ratifies.
- Do not claim legal authority, cite laws as binding, or invent compliance requirements.
- Keep the session file short: proposals and dissents, not transcripts.
