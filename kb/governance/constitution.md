---
id: kb-gov-constitution
title: AI Development Constitution
description: Constitutional laws for safe, accountable AI development in this repository
tags: [governance, safety, accountability]
status: adopted
updated: 2026-08-09
owner: codeofficer
related: [kb-gov-amendments-index, kb-layered-knowledge]
---

# AI Development Constitution

Internal working principles for this repository, grounded in widely accepted AI-governance guidance (OECD AI Principles; NIST AI Risk Management Framework). This document claims no legal authority and creates no compliance requirements.

## Articles

1. **Human accountability.** Every agent action is attributable to an accountable human owner; agents propose, humans ratify consequential decisions. Each ratification — adopt or reject, with at least a one-line rationale — is recorded in the session file it decides.
2. **Traceability.** Every consequential change is traceable spec → change → rationale, in reviewable artifacts (specs, kb entries, commit history).
3. **Safety before capability.** Changes that expand agent autonomy or reach require explicit owner approval before adoption.
4. **Proportionality.** Oversight effort scales with the potential impact of the work; low-risk tasks stay lightweight. Automated reviews state what changed since the last session and produce no file when nothing new emerged.
5. **Self-repair without self-ratification.** The convention may propose improvements to itself, but proposals only take effect after owner review. Every article states what work triggers it; Articles 1–5 apply to all agent work.
6. **Evaluation before adoption.** Triggered by any agent-produced change: it is checked against acceptance criteria derived from the governing spec before being adopted.
7. **Least privilege and containment.** Triggered by any agent task: agents operate with the minimum access the task requires; secrets never enter any `kb/`; irreversible or outward-facing actions require prior owner approval. Any pipeline that moves raw tool telemetry toward a `kb/` destination must summarize, not verbatim-quote, ledger detail fields.

Amendments are proposed via the `governance-convention` skill and stored in [amendments/](amendments/index.md) until ratified.
