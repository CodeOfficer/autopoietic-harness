# Autopoietic Harness: Consolidation, Provenance & Attestation Record

## Executive Summary

This document records the formal audit, reconciliation, and attestation performed during the transition of **Autopoietic Harness** from a multi-purpose sandbox prototype into a production-ready, distributable **Claude Code Plugin** (`@codeofficer/autopoietic-harness`).

---

## 1. Domain Scope Definition

Autopoietic Harness is strictly scoped to **Additive Self-Improving AI Governance & Layered Knowledge**. 

### In Scope (Preserved & Consolidated):
- **Core Governance Constitution**: The 7 Constitutional Laws (`core-kb/constitution.md`).
- **Self-Improvement Lifecycle**: 4-stage loop (Observe → Synthesize → Ratify → Promote).
- **Primitive Selection Rubric**: Deterministic rubric for choosing mechanism types.
- **Open Knowledge Format (OKF)**: Schema enforcement for concept entries.
- **Layered Knowledge**: Nearest-wins directory depth resolution rules.
- **Lifecycle Engine Hooks**: Opt-in check, secret redaction in telemetry, debounced review, proposal notification.
- **Interactive Verbs**: `/init`, `/status`, `/ratify` (Local & Upstream Maintainer Mode), `/migrate`.

### Out of Scope (Pruned Cruft):
- **Generic Source-Code Security Linters**: Off-topic generic code analysis (delegated to standard security tools/plugins).
- **Prototype Sandbox Session Logs**: Obsolete single-repo sandbox files (`session-2026-08-08*.md`, `proposal-2026-08-09-test.md`).
- **Sub-Projects Directory (`projects/`)**: Obsolete multi-project folder structure.

---

## 2. Provenance & Audit Matrix

| Component | Historical Sandbox State | Consolidated Plugin State | Action Taken & Rationale |
|---|---|---|---|
| `constitution.md` | Embedded in single repo | Shipped in `core-kb/` & `templates/` | **Consolidated.** Preserved 7 Constitutional Laws. Cleaned legacy single-repo path assumptions. |
| `self-improvement.md` | Required $\ge 2$ sub-projects for promotion | Refactored for 2-Consumer-Story model | **Refactored.** Aligned promotion ladder to Target Repo (Local) vs Plugin Engine (Maintainer). |
| `primitive-selection.md` | Concept file in `kb/` | Promoted to `core-kb/` | **Preserved.** Canonical primitive rubric. |
| `okf-format.md` | Concept file in `kb/` | Promoted to `core-kb/` | **Preserved.** Canonical OKF YAML schema. |
| `layered-knowledge.md` | Concept file in `kb/` | Promoted to `core-kb/` | **Preserved.** Nearest-wins resolution rules. |
| `enforce-policy.sh` | Generic source code scanner | Harness Domain Enforcer | **Refactored.** Focused strictly on OKF schema, Acceptance Criteria presence, and telemetry secrecy. |
| `amendments/session-*.md` | 4 sandbox trial files | Pruned | **Pruned.** Removed prototype trial files; reset index to clean baseline. |
| `improvements/proposal-*.md` | 5 sandbox trial files | Pruned | **Pruned.** Removed prototype trial files; reset index to clean baseline. |
| `projects/` | Monolithic sub-project folder | Deleted | **Deleted.** Replaced by clean 2-Consumer-Story architecture. |

---

## 3. Component Attestation

The undersigned system maintainers attest that:

1. **Schema Integrity**: All remaining `core-kb/*.md` entries follow valid OKF YAML frontmatter schemas.
2. **Deterministic Governance**: All 5 plugin hooks (`SessionStart`, `PreToolUse`, `PostToolUseFailure`, `PermissionDenied`, `SessionEnd`) pass `claude plugin validate` with zero errors.
3. **Zero Cruft Guarantee**: The plugin package contains no obsolete single-repo sandbox logs, prototype files, or un-namespaced state directories.
4. **Pristine Isolation**: All consumer state is strictly contained within `.autopoietic/` and gitignored via a single `.gitignore` entry.
