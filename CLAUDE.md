# Repository Rules: Autopoietic Harness Plugin Engine

This repository is the universal Claude Code plugin engine `@codeofficer/autopoietic-harness`.

## Governing rule

Every directory follows the nearest `CLAUDE.md` found in its own directory or an ancestor directory. A more-local `CLAUDE.md` supplements the root rules and, where they conflict, takes precedence for its subtree.

## Layered Knowledge & Core Concepts

Baseline plugin concepts live in `core-kb/` (Open Knowledge Format — see `core-kb/okf-format.md`). 
Repo-local knowledge lives in `kb/` (scaffolded via `/autopoietic-harness:init`). A more-local `kb/` supplements and takes precedence over broader knowledge. Start discovery at the nearest `kb/index.md`, then walk up. See `core-kb/layered-knowledge.md`.

## Conventions

- Before adopting any convention not clearly implied by existing repository files, ask the repository owner first.
- Keep every file short, focused, and single-purpose.
- On recurring friction (repeated failures, guessed conventions, retries), log telemetry to `.autopoietic/friction/events.jsonl` (see `core-kb/self-improvement.md`).
- OKF concept files use the frontmatter schema defined in `core-kb/okf-format.md`.

## Package Layout

- `.claude-plugin/` — plugin manifest (`plugin.json`), lifecycle bindings (`hooks.json`), marketplace catalog (`marketplace.json`), and system prompt (`system-prompt.md`)
- `hooks/` — engine lifecycle hook scripts (`session-start-prompt.sh`, `pending-proposals.sh`, `enforce-policy.sh`, `log-friction.sh`, `end-session-review.sh`, `status-check.sh`)
- `skills/` — namespaced interactive verbs (`init`, `status`, `ratify`, `migrate`)
- `core-kb/` — baseline governance concepts shipped with the plugin package (`constitution.md`, `self-improvement.md`, `primitive-selection.md`, `okf-format.md`, `layered-knowledge.md`)
- `templates/` — scaffolding templates for `/init` (`CLAUDE.md.template`, `repo-kb-index.template.md`, governance indexes)
- `.autopoietic/` — local plugin state (friction telemetry ledger, staging quarantine, enabled flag)
- `kb/` — local repository knowledge base (scaffolded via `/init` for dogfooding maintainer governance)
